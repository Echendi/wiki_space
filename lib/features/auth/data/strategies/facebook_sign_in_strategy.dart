import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/entities/auth_exception.dart';
import '../mappers/firebase_user_mapper.dart';
import 'auth_sign_in_strategy.dart';

class FacebookSignInStrategy implements AuthSignInStrategy {
  const FacebookSignInStrategy({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<AppUser> signIn() async {
    final loginResult = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    switch (loginResult.status) {
      case LoginStatus.success:
        final token = loginResult.accessToken?.token;
        if (token == null || token.isEmpty) {
          throw const AuthException(
            code: 'facebook-login-failed',
            message: 'No se recibio token de Facebook.',
          );
        }

        final credential = FacebookAuthProvider.credential(token);
        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final user = userCredential.user;
        if (user == null) {
          throw const AuthException(
            code: 'user-not-found',
            message: 'No se pudo completar el acceso con Facebook.',
          );
        }

        return FirebaseUserMapper.toDomain(user);
      case LoginStatus.cancelled:
        throw const AuthException(
          code: 'aborted-by-user',
          message: 'El usuario cancelo el inicio de sesion con Facebook.',
        );
      case LoginStatus.failed:
        throw AuthException(
          code: 'facebook-login-failed',
          message:
              loginResult.message ?? 'Fallo la autenticacion con Facebook.',
        );
      case LoginStatus.operationInProgress:
        throw const AuthException(
          code: 'operation-not-allowed',
          message: 'Ya hay una operacion de Facebook en progreso.',
        );
    }
  }
}
