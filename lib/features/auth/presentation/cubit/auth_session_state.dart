import '../../domain/entities/app_user.dart';

/// Estado simplificado de sesion global de autenticacion.
class AuthSessionState {
  const AuthSessionState({
    this.user,
  });

  final AppUser? user;

  bool get isAuthenticated => user != null;
}
