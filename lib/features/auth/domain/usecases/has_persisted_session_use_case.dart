import '../repositories/auth_repository.dart';

/// Valida si hay una sesion local persistida utilizable.
class HasPersistedSessionUseCase {
  const HasPersistedSessionUseCase(this._repository);

  final AuthRepository _repository;

  /// Retorna `true` si existe sesion local recuperable.
  Future<bool> call() => _repository.hasPersistedSession();
}
