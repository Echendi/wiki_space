import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_user.dart';

/// Traduce un `User` de Firebase a la entidad de dominio [AppUser].
class FirebaseUserMapper {
  const FirebaseUserMapper._();

  /// Convierte un usuario de infraestructura a modelo puro de dominio.
  static AppUser toDomain(User user) {
    final providerIds = user.providerData
        .map((provider) => provider.providerId)
        .where((id) => id.trim().isNotEmpty)
        .toList(growable: false);

    return AppUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      emailVerified: user.emailVerified,
      lastSignInAt: user.metadata.lastSignInTime,
      providerIds: providerIds,
    );
  }
}
