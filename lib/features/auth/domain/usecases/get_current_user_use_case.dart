import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

/// Obtiene el usuario autenticado actual desde el repositorio.
class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  /// Retorna el usuario actualmente autenticado o `null`.
  AppUser? call() => _repository.currentUser;
}
