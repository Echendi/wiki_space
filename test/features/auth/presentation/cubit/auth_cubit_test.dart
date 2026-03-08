import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wiki_space/features/auth/domain/entities/auth_exception.dart';
import 'package:wiki_space/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:wiki_space/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:wiki_space/features/auth/domain/usecases/has_persisted_session_use_case.dart';
import 'package:wiki_space/features/auth/domain/usecases/sign_in_with_email_and_password_use_case.dart';
import 'package:wiki_space/features/auth/domain/usecases/sign_in_with_facebook_use_case.dart';
import 'package:wiki_space/features/auth/domain/usecases/sign_in_with_google_use_case.dart';
import 'package:wiki_space/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:wiki_space/features/auth/domain/usecases/sign_up_with_email_and_password_use_case.dart';
import 'package:wiki_space/features/auth/domain/usecases/update_display_name_use_case.dart';
import 'package:wiki_space/features/auth/domain/usecases/watch_auth_state_use_case.dart';
import 'package:wiki_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:wiki_space/features/auth/presentation/cubit/auth_state.dart';

class _MockGetCurrentUserUseCase extends Mock
    implements GetCurrentUserUseCase {}

class _MockWatchAuthStateUseCase extends Mock
    implements WatchAuthStateUseCase {}

class _MockHasPersistedSessionUseCase extends Mock
    implements HasPersistedSessionUseCase {}

class _MockSignInWithEmailAndPasswordUseCase extends Mock
    implements SignInWithEmailAndPasswordUseCase {}

class _MockSignUpWithEmailAndPasswordUseCase extends Mock
    implements SignUpWithEmailAndPasswordUseCase {}

class _MockSignInWithGoogleUseCase extends Mock
    implements SignInWithGoogleUseCase {}

class _MockSignInWithFacebookUseCase extends Mock
    implements SignInWithFacebookUseCase {}

class _MockUpdateDisplayNameUseCase extends Mock
    implements UpdateDisplayNameUseCase {}

class _MockSignOutUseCase extends Mock implements SignOutUseCase {}

void main() {
  group('AuthCubit', () {
    late _MockGetCurrentUserUseCase getCurrentUser;
    late _MockWatchAuthStateUseCase watchAuthState;
    late _MockHasPersistedSessionUseCase hasPersistedSession;
    late _MockSignInWithEmailAndPasswordUseCase signInWithEmailAndPassword;
    late _MockSignUpWithEmailAndPasswordUseCase signUpWithEmailAndPassword;
    late _MockSignInWithGoogleUseCase signInWithGoogle;
    late _MockSignInWithFacebookUseCase signInWithFacebook;
    late _MockUpdateDisplayNameUseCase updateDisplayName;
    late _MockSignOutUseCase signOut;

    late AuthUseCases authUseCases;

    setUp(() {
      getCurrentUser = _MockGetCurrentUserUseCase();
      watchAuthState = _MockWatchAuthStateUseCase();
      hasPersistedSession = _MockHasPersistedSessionUseCase();
      signInWithEmailAndPassword = _MockSignInWithEmailAndPasswordUseCase();
      signUpWithEmailAndPassword = _MockSignUpWithEmailAndPasswordUseCase();
      signInWithGoogle = _MockSignInWithGoogleUseCase();
      signInWithFacebook = _MockSignInWithFacebookUseCase();
      updateDisplayName = _MockUpdateDisplayNameUseCase();
      signOut = _MockSignOutUseCase();

      authUseCases = AuthUseCases(
        getCurrentUser: getCurrentUser,
        watchAuthState: watchAuthState,
        hasPersistedSession: hasPersistedSession,
        signInWithEmailAndPassword: signInWithEmailAndPassword,
        signUpWithEmailAndPassword: signUpWithEmailAndPassword,
        signInWithGoogle: signInWithGoogle,
        signInWithFacebook: signInWithFacebook,
        updateDisplayName: updateDisplayName,
        signOut: signOut,
      );

      when(
        () => signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => signUpWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});
      when(() => signInWithGoogle()).thenAnswer((_) async {});
      when(() => signInWithFacebook()).thenAnswer((_) async {});
      when(() => updateDisplayName(any())).thenAnswer((_) async {});
      when(() => signOut()).thenAnswer((_) async {});
    });

    blocTest<AuthCubit, AuthState>(
      'signInWithEmail emite loading y success',
      build: () => AuthCubit(authUseCases),
      act: (cubit) => cubit.signInWithEmail(
        email: 'dev@wiki.com',
        password: 'Password123!',
      ),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthViewStatus.loading)
            .having((s) => s.action, 'action', AuthAction.signInEmail),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthViewStatus.success)
            .having((s) => s.action, 'action', AuthAction.signInEmail),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'signInWithGoogle mapea developer_error a google-config-error',
      build: () {
        when(
          () => signInWithGoogle(),
        ).thenThrow(
          PlatformException(
            code: 'sign_in_failed',
            details: 'ApiException: 10',
          ),
        );

        return AuthCubit(authUseCases);
      },
      act: (cubit) => cubit.signInWithGoogle(),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthViewStatus.loading)
            .having((s) => s.action, 'action', AuthAction.signInGoogle),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthViewStatus.failure)
            .having((s) => s.action, 'action', AuthAction.signInGoogle)
            .having((s) => s.errorCode, 'errorCode', 'google-config-error'),
      ],
    );

    test('signUpWithEmail actualiza displayName cuando llega con contenido',
        () async {
      final cubit = AuthCubit(authUseCases);
      addTearDown(cubit.close);

      await cubit.signUpWithEmail(
        email: 'user@wiki.com',
        password: 'Password123!',
        displayName: 'David',
      );

      verify(
        () => signUpWithEmailAndPassword(
          email: 'user@wiki.com',
          password: 'Password123!',
        ),
      ).called(1);
      verify(() => updateDisplayName('David')).called(1);
    });

    blocTest<AuthCubit, AuthState>(
      'propaga AuthException como failure con errorCode',
      build: () {
        when(
          () => signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          const AuthException(code: 'invalid-credential'),
        );

        return AuthCubit(authUseCases);
      },
      act: (cubit) => cubit.signInWithEmail(
        email: 'x@x.com',
        password: 'bad',
      ),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthViewStatus.loading)
            .having((s) => s.action, 'action', AuthAction.signInEmail),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthViewStatus.failure)
            .having((s) => s.action, 'action', AuthAction.signInEmail)
            .having((s) => s.errorCode, 'errorCode', 'invalid-credential'),
      ],
    );
  });
}
