import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

/// Expone un stream con cambios del estado de autenticacion.
class WatchAuthStateUseCase {
  const WatchAuthStateUseCase(this._repository);

  final AuthRepository _repository;

  /// Retorna un stream reactivo de sesion de usuario en dominio.
  Stream<AppUser?> call() => _repository.authStateChanges;
}
