import '../../domain/entities/app_user.dart';

/// Contrato para estrategias de autenticacion intercambiables.
abstract class AuthSignInStrategy {
  /// Ejecuta el flujo de autenticacion.
  ///
  /// Retorna el [AppUser] autenticado o lanza excepcion de dominio.
  Future<AppUser> signIn();
}
