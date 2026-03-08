import '../../domain/entities/app_user.dart';

abstract class AuthSignInStrategy {
  Future<AppUser> signIn();
}
