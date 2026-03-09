import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wiki_space/features/auth/domain/entities/auth_exception.dart';
import 'package:wiki_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:wiki_space/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:wiki_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:wiki_space/features/auth/presentation/cubit/auth_state.dart';

/// Mock del repositorio para aislar el comportamiento del cubit.
class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AuthCubit', () {
    late _MockAuthRepository repository;
    late AuthCubit cubit;

    setUp(() {
      repository = _MockAuthRepository();
      cubit = AuthCubit(AuthUseCases.fromRepository(repository));
    });

    tearDown(() async {
      await cubit.close();
    });

    blocTest<AuthCubit, AuthState>(
      'emite loading y success cuando el inicio de sesion con email finaliza correctamente',
      build: () {
        when(
          () => repository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.signInWithEmail(
        email: 'test@correo.com',
        password: 'Password123!',
      ),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthViewStatus.loading)
            .having((s) => s.action, 'action', AuthAction.signInEmail)
            .having((s) => s.errorCode, 'errorCode', isNull),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthViewStatus.success)
            .having((s) => s.action, 'action', AuthAction.signInEmail)
            .having((s) => s.errorCode, 'errorCode', isNull),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emite loading y failure con codigo invalid-credential cuando el dominio lanza AuthException',
      build: () {
        when(
          () => repository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const AuthException(code: 'invalid-credential'));
        return cubit;
      },
      act: (cubit) => cubit.signInWithEmail(
        email: 'test@correo.com',
        password: 'incorrecta',
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

    blocTest<AuthCubit, AuthState>(
      'emite error google-config-error cuando Google devuelve PlatformException de configuracion',
      build: () {
        when(() => repository.signInWithGoogle()).thenThrow(
          PlatformException(
            code: 'sign_in_failed',
            details: 'ApiException: 10',
          ),
        );
        return cubit;
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
  });
}
