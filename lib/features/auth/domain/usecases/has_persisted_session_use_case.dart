import '../repositories/auth_repository.dart';

class HasPersistedSessionUseCase {
  const HasPersistedSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<bool> call() => _repository.hasPersistedSession();
}
