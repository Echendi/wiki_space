import '../repositories/auth_repository.dart';

class SignInWithEmailAndPasswordUseCase {
  const SignInWithEmailAndPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required String email,
    required String password,
  }) {
    return _repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
