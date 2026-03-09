import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wiki_space/features/auth/domain/entities/auth_exception.dart';
import 'package:wiki_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:wiki_space/features/auth/domain/usecases/sign_in_with_email_and_password_use_case.dart';

/// Mock del contrato de repositorio para validar delegacion del caso de uso.
class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('SignInWithEmailAndPasswordUseCase', () {
    late _MockAuthRepository repository;
    late SignInWithEmailAndPasswordUseCase useCase;

    setUp(() {
      repository = _MockAuthRepository();
      useCase = SignInWithEmailAndPasswordUseCase(repository);
    });

    test(
      'delega en el repositorio con los parametros exactos de email y contrasena',
      () async {
        when(
          () => repository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});

        await useCase(
          email: 'usuario@correo.com',
          password: 'Password123!',
        );

        verify(
          () => repository.signInWithEmailAndPassword(
            email: 'usuario@correo.com',
            password: 'Password123!',
          ),
        ).called(1);
        verifyNoMoreInteractions(repository);
      },
    );

    test(
      'propaga AuthException cuando el repositorio retorna error de credenciales invalidas',
      () async {
        when(
          () => repository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const AuthException(code: 'invalid-credential'));

        await expectLater(
          () => useCase(
            email: 'usuario@correo.com',
            password: 'incorrecta',
          ),
          throwsA(
            isA<AuthException>().having(
              (e) => e.code,
              'code',
              'invalid-credential',
            ),
          ),
        );

        verify(
          () => repository.signInWithEmailAndPassword(
            email: 'usuario@correo.com',
            password: 'incorrecta',
          ),
        ).called(1);
      },
    );
  });
}
