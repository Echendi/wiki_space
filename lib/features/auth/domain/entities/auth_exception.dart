/// Excepcion de dominio para errores de autenticacion.
///
/// `code` contiene una clave estable que presentation transforma en mensaje.
class AuthException implements Exception {
  const AuthException({
    required this.code,
    this.message,
  });

  final String code;
  final String? message;

  @override
  String toString() => message == null ? code : '$code: $message';
}
