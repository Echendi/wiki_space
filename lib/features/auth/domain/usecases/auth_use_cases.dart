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

class AuthUseCases {
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

  final GetCurrentUserUseCase getCurrentUser;
  final WatchAuthStateUseCase watchAuthState;
  final HasPersistedSessionUseCase hasPersistedSession;
  final SignInWithEmailAndPasswordUseCase signInWithEmailAndPassword;
  final SignUpWithEmailAndPasswordUseCase signUpWithEmailAndPassword;
  final SignInWithGoogleUseCase signInWithGoogle;
  final SignInWithFacebookUseCase signInWithFacebook;
  final UpdateDisplayNameUseCase updateDisplayName;
  final SignOutUseCase signOut;
}
