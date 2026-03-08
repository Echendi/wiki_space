import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/entities/app_user.dart';
import '../domain/entities/auth_exception.dart';
import '../domain/repositories/auth_repository.dart';
import 'strategies/auth_sign_in_strategy.dart';
import 'strategies/firebase_auth_strategies.dart';

class AuthService implements AuthRepository {
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

  @override
  Stream<AppUser?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map(_mapUser);

  @override
  AppUser? get currentUser => _mapUser(_firebaseAuth.currentUser);

  Future<AppUser> signInWithStrategy(AuthSignInStrategy strategy) async {
    final user = await strategy.signIn();
    await _persistSession(user.id);
    return user;
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await signInWithStrategy(
      EmailPasswordSignInStrategy(
        firebaseAuth: _firebaseAuth,
        email: email,
        password: password,
      ),
    );
  }

  @override
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
      throw const AuthException(
        code: 'user-not-found',
        message: 'No se pudo crear un usuario valido.',
      );
    }

    await _persistSession(user.uid);
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return;
    }

    final normalized = displayName.trim();
    if (normalized.isEmpty) {
      return;
    }

    await user.updateDisplayName(normalized);
    await user.reload();
  }

  @override
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

  @override
  Future<void> signInWithGoogle() async {
    await signInWithStrategy(
      GoogleSignInStrategy(
        firebaseAuth: _firebaseAuth,
        googleSignIn: _googleSignIn,
      ),
    );
  }

  @override
  Future<void> signInWithFacebook() async {
    await signInWithStrategy(
      FacebookSignInStrategy(
        firebaseAuth: _firebaseAuth,
      ),
    );
  }

  @override
  Future<bool> hasPersistedSession() async {
    final existingUser = _firebaseAuth.currentUser;
    if (existingUser != null) {
      await _persistSession(existingUser.uid);
      return true;
    }

    final storedUid = await _secureStorage.read(key: _uidKey);
    return storedUid != null && storedUid.isNotEmpty;
  }

  Future<void> _persistSession(String uid) async {
    final token = await _firebaseAuth.currentUser?.getIdToken();

    if (token != null && token.isNotEmpty) {
      await _secureStorage.write(key: _tokenKey, value: token);
    }

    await _secureStorage.write(key: _uidKey, value: uid);
  }

  AppUser? _mapUser(User? user) {
    if (user == null) {
      return null;
    }

    final providerIds = user.providerData
        .map((provider) => provider.providerId)
        .where((id) => id.trim().isNotEmpty)
        .toList(growable: false);

    return AppUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      emailVerified: user.emailVerified,
      lastSignInAt: user.metadata.lastSignInTime,
      providerIds: providerIds,
    );
  }
}
