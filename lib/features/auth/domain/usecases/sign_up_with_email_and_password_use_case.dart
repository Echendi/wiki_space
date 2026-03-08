import '../repositories/auth_repository.dart';

/// Ejecuta registro de cuenta con correo y contrasena.
class SignUpWithEmailAndPasswordUseCase {
  const SignUpWithEmailAndPasswordUseCase(this._repository);

  final AuthRepository _repository;

  /// Ejecuta registro por email/password con datos del formulario.
  Future<void> call({
    required String email,
    required String password,
  }) {
    return _repository.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
