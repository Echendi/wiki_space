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
