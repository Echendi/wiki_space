import '../entities/app_user.dart';

/// Contrato de autenticacion de la feature.
///
/// Define operaciones de acceso, cierre de sesion y consulta de estado.
abstract class AuthRepository {
  /// Flujo reactivo del usuario autenticado actual.
  Stream<AppUser?> get authStateChanges;

  /// Snapshot sincronico del usuario actual.
  AppUser? get currentUser;

  /// Inicia sesion con correo y contrasena.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Crea una cuenta con correo y contrasena.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Inicia sesion con proveedor Google.
  Future<void> signInWithGoogle();

  /// Inicia sesion con proveedor Facebook.
  Future<void> signInWithFacebook();

  /// Actualiza el nombre visible del usuario autenticado.
  Future<void> updateDisplayName(String displayName);

  /// Cierra la sesion local y remota del usuario.
  Future<void> signOut();

  /// Verifica si existe sesion persistida recuperable.
  Future<bool> hasPersistedSession();
}
