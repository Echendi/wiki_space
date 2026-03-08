import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/entities/auth_exception.dart';
import '../mappers/firebase_user_mapper.dart';
import 'auth_sign_in_strategy.dart';

class GoogleSignInStrategy implements AuthSignInStrategy {
  const GoogleSignInStrategy({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<AppUser> signIn() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw const AuthException(
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
      throw const AuthException(
        code: 'user-not-found',
        message: 'No se pudo completar el acceso con Google.',
      );
    }

    return FirebaseUserMapper.toDomain(user);
  }
}
