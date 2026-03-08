import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/entities/auth_exception.dart';
import '../mappers/firebase_user_mapper.dart';
import 'auth_sign_in_strategy.dart';

/// Estrategia de login con correo y contrasena de Firebase Auth.
class EmailPasswordSignInStrategy implements AuthSignInStrategy {
  const EmailPasswordSignInStrategy({
    required FirebaseAuth firebaseAuth,
    required this.email,
    required this.password,
  }) : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;
  final String email;
  final String password;

  /// Autentica por email/password y retorna entidad de dominio mapeada.
  ///
  /// Lanza [AuthException] si Firebase no retorna usuario valido.
  @override
  Future<AppUser> signIn() async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw const AuthException(
        code: 'user-not-found',
        message: 'No se encontro un usuario valido.',
      );
    }

    return FirebaseUserMapper.toDomain(user);
  }
}
