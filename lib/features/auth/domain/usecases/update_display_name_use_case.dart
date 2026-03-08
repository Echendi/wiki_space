import '../repositories/auth_repository.dart';

/// Actualiza el nombre visible del usuario autenticado.
class UpdateDisplayNameUseCase {
  const UpdateDisplayNameUseCase(this._repository);

  final AuthRepository _repository;

  /// Actualiza el nombre mostrado del usuario autenticado.
  Future<void> call(String displayName) {
    return _repository.updateDisplayName(displayName);
  }
}
