import '../../domain/entities/app_user.dart';

class AuthSessionState {
  const AuthSessionState({
    this.user,
  });

  final AppUser? user;

  bool get isAuthenticated => user != null;
}
