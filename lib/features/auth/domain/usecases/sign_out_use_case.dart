import '../repositories/auth_repository.dart';

/// Ejecuta cierre de sesion del usuario actual.
class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  /// Ejecuta cierre de sesion local/remoto.
  Future<void> call() => _repository.signOut();
}
