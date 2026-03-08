import '../repositories/auth_repository.dart';

class SignInWithFacebookUseCase {
  const SignInWithFacebookUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.signInWithFacebook();
}
