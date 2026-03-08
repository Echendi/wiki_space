import '../repositories/auth_repository.dart';

/// Ejecuta inicio de sesion mediante Google.
class SignInWithGoogleUseCase {
  const SignInWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  /// Ejecuta login social con proveedor Google.
  Future<void> call() => _repository.signInWithGoogle();
}
