import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService({
    required FirebaseAuth firebaseAuth,
    required FlutterSecureStorage secureStorage,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _secureStorage = secureStorage,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final FlutterSecureStorage _secureStorage;
  final GoogleSignIn _googleSignIn;

  static const _tokenKey = 'auth_token';
  static const _uidKey = 'auth_uid';

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No se encontro un usuario valido.',
      );
    }

    await _persistSession(user);
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No se pudo crear un usuario valido.',
      );
    }

    await _persistSession(user);
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Ignora errores de cierre de sesion del proveedor para priorizar Firebase.
    }

    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {
      // Ignora errores de cierre de sesion del proveedor para priorizar Firebase.
    }

    await _firebaseAuth.signOut();
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _uidKey);
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'aborted-by-user',
        message: 'El usuario cancelo el inicio de sesion con Google.',
      );
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No se pudo completar el acceso con Google.',
      );
    }

    await _persistSession(user);
  }

  Future<void> signInWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    switch (loginResult.status) {
      case LoginStatus.success:
        final token = loginResult.accessToken?.token;
        if (token == null || token.isEmpty) {
          throw FirebaseAuthException(
            code: 'facebook-login-failed',
            message: 'No se recibio token de Facebook.',
          );
        }

        final credential = FacebookAuthProvider.credential(token);
        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final user = userCredential.user;
        if (user == null) {
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No se pudo completar el acceso con Facebook.',
          );
        }

        await _persistSession(user);
        return;
      case LoginStatus.cancelled:
        throw FirebaseAuthException(
          code: 'aborted-by-user',
          message: 'El usuario cancelo el inicio de sesion con Facebook.',
        );
      case LoginStatus.failed:
        throw FirebaseAuthException(
          code: 'facebook-login-failed',
          message:
              loginResult.message ?? 'Fallo la autenticacion con Facebook.',
        );
      case LoginStatus.operationInProgress:
        throw FirebaseAuthException(
          code: 'operation-not-allowed',
          message: 'Ya hay una operacion de Facebook en progreso.',
        );
    }
  }

  Future<bool> hasPersistedSession() async {
    final existingUser = _firebaseAuth.currentUser;
    if (existingUser != null) {
      await _persistSession(existingUser);
      return true;
    }

    final storedUid = await _secureStorage.read(key: _uidKey);
    return storedUid != null && storedUid.isNotEmpty;
  }

  Future<void> _persistSession(User user) async {
    final token = await user.getIdToken();

    if (token != null && token.isNotEmpty) {
      await _secureStorage.write(key: _tokenKey, value: token);
    }

    await _secureStorage.write(key: _uidKey, value: user.uid);
  }
}
