# Documentacion de pruebas

Este directorio incluye pruebas enfocadas en la feature de autenticacion para cubrir tres niveles clave:

1. Cubit: valida transiciones de estado y mapeo de errores de presentacion.
2. Caso de uso: valida delegacion correcta hacia el repositorio (contrato de dominio).
3. Widget: valida comportamiento visual/funcional de un componente reutilizable.

## Pruebas implementadas

- `test/features/auth/presentation/cubit/auth_cubit_test.dart`
  Descripcion:
  Verifica que `AuthCubit` emite estados esperados (`loading`, `success`, `failure`) al iniciar sesion con email y al manejar errores de dominio/plataforma.
  Cobertura principal:
- Flujo exitoso de login por email.
- Error de credenciales invalidas (`invalid-credential`).
- Error de configuracion de Google (`google-config-error`).

- `test/features/auth/domain/usecases/sign_in_with_email_and_password_use_case_test.dart`
  Descripcion:
  Verifica que `SignInWithEmailAndPasswordUseCase` delega la llamada al `AuthRepository` con los parametros exactos y que propaga errores de dominio al caller.
  Cobertura principal:
- Interaccion correcta caso de uso -> repositorio.
- Una sola invocacion esperada.
- Propagacion de `AuthException` cuando el repositorio falla (por ejemplo, `invalid-credential`).

- `test/features/auth/presentation/widgets/themed_auth_field_test.dart`
  Descripcion:
  Verifica comportamiento del widget `ThemedAuthField` en validacion de formulario y configuracion visual.
  Cobertura principal:
- Render de error cuando el validador falla.
- Respeto de `obscureText` y render de `suffixIcon`.

## Ejecucion

Para correr todas las pruebas:

```bash
flutter test
```

Para correr solo las pruebas agregadas:

```bash
flutter test test/features/auth/presentation/cubit/auth_cubit_test.dart
flutter test test/features/auth/domain/usecases/sign_in_with_email_and_password_use_case_test.dart
flutter test test/features/auth/presentation/widgets/themed_auth_field_test.dart
```
