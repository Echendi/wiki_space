import '../repositories/auth_repository.dart';

/// Ejecuta inicio de sesion mediante Facebook.
class SignInWithFacebookUseCase {
  const SignInWithFacebookUseCase(this._repository);

  final AuthRepository _repository;

  /// Ejecuta login social con proveedor Facebook.
  Future<void> call() => _repository.signInWithFacebook();
}
