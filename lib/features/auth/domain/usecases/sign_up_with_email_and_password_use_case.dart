import '../repositories/auth_repository.dart';

class SignUpWithEmailAndPasswordUseCase {
  const SignUpWithEmailAndPasswordUseCase(this._repository);

  final AuthRepository _repository;

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
