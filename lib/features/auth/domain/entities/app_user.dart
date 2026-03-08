class AppUser {
  const AppUser({
    required this.id,
    this.email,
    this.displayName,
    this.emailVerified = false,
    this.lastSignInAt,
    this.providerIds = const <String>[],
  });

  final String id;
  final String? email;
  final String? displayName;
  final bool emailVerified;
  final DateTime? lastSignInAt;
  final List<String> providerIds;
}
