import '../repositories/auth_repository.dart';
import 'get_current_user_use_case.dart';
import 'has_persisted_session_use_case.dart';
import 'sign_in_with_email_and_password_use_case.dart';
import 'sign_in_with_facebook_use_case.dart';
import 'sign_in_with_google_use_case.dart';
import 'sign_out_use_case.dart';
import 'sign_up_with_email_and_password_use_case.dart';
import 'update_display_name_use_case.dart';
import 'watch_auth_state_use_case.dart';

/// Fachada de casos de uso de autenticacion.
///
/// Agrupa todas las acciones de la feature para simplificar inyeccion.
class AuthUseCases {
  /// Crea la fachada a partir de casos de uso ya construidos.
  const AuthUseCases({
    required this.getCurrentUser,
    required this.watchAuthState,
    required this.hasPersistedSession,
    required this.signInWithEmailAndPassword,
    required this.signUpWithEmailAndPassword,
    required this.signInWithGoogle,
    required this.signInWithFacebook,
    required this.updateDisplayName,
    required this.signOut,
  });

  /// Fabrica conveniente que instancia todos los casos desde [AuthRepository].
  factory AuthUseCases.fromRepository(AuthRepository repository) {
    return AuthUseCases(
      getCurrentUser: GetCurrentUserUseCase(repository),
      watchAuthState: WatchAuthStateUseCase(repository),
      hasPersistedSession: HasPersistedSessionUseCase(repository),
      signInWithEmailAndPassword: SignInWithEmailAndPasswordUseCase(repository),
      signUpWithEmailAndPassword: SignUpWithEmailAndPasswordUseCase(repository),
      signInWithGoogle: SignInWithGoogleUseCase(repository),
      signInWithFacebook: SignInWithFacebookUseCase(repository),
      updateDisplayName: UpdateDisplayNameUseCase(repository),
      signOut: SignOutUseCase(repository),
    );
  }

  /// Caso de uso para leer usuario actual.
  final GetCurrentUserUseCase getCurrentUser;

  /// Caso de uso para observar cambios de autenticacion.
  final WatchAuthStateUseCase watchAuthState;

  /// Caso de uso para validar sesion persistida.
  final HasPersistedSessionUseCase hasPersistedSession;

  /// Caso de uso de login email/password.
  final SignInWithEmailAndPasswordUseCase signInWithEmailAndPassword;

  /// Caso de uso de registro email/password.
  final SignUpWithEmailAndPasswordUseCase signUpWithEmailAndPassword;

  /// Caso de uso de login Google.
  final SignInWithGoogleUseCase signInWithGoogle;

  /// Caso de uso de login Facebook.
  final SignInWithFacebookUseCase signInWithFacebook;

  /// Caso de uso para actualizar nombre visible.
  final UpdateDisplayNameUseCase updateDisplayName;

  /// Caso de uso de cierre de sesion.
  final SignOutUseCase signOut;
}
