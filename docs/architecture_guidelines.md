# Guia de Arquitectura (Clean + Cubit)

Este documento define reglas practicas para mantener consistencia en `wiki_space`.

## 1) Estructura por feature

Cada feature debe seguir esta base cuando aplique:

- `data/`: implementaciones concretas (API, Firebase, DB, mappers, strategies).
- `domain/`: entidades, contratos (`repositories`) y `usecases`.
- `presentation/`: `pages`, `widgets`, `cubit`.
- `di/`: registro de dependencias del feature.

Regla: la UI nunca debe depender de clases de `data` (ejemplo: `FirebaseAuth`, servicios concretos).

## 2) Regla SOLID de archivos

Una clase por archivo.

- Correcto: `sign_in_with_google_use_case.dart` contiene solo `SignInWithGoogleUseCase`.
- Correcto: archivos tipo barrel solo con `export`.
- Evitar: multiples clases concretas en un mismo archivo.

## 3) Use cases en presentacion

La capa `presentation` consume use cases, no repositorios concretos.

- Correcto: `AuthCubit` usa `AuthUseCases`.
- Evitar: `LoginScreen` llamando directamente `AuthService`.

## 4) Cubit por flujo de pantalla

Usar `Cubit` cuando exista estado asincrono o reglas de error/carga.

Aplicar Cubit para:

- login, registro, social sign-in, logout
- carga remota/cache
- estados con `loading/success/failure`

Puede quedar `StatefulWidget` sin Cubit solo para estado UI local efimero (ejemplo: ocultar password, tabs visuales).

## 5) Scope correcto de Provider/BlocProvider

Error comun: `ProviderNotFoundException` por leer con un `BuildContext` por encima del provider.

Patron recomendado por pantalla:

```dart
late final AuthCubit _authCubit;

@override
void initState() {
  super.initState();
  _authCubit = serviceLocator<AuthCubit>();
}

@override
void dispose() {
  _authCubit.close();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return BlocProvider<AuthCubit>.value(
    value: _authCubit,
    child: BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // UI
      },
    ),
  );
}
```

Regla: si la accion sale desde metodos del `State`, usar la instancia local (`_authCubit`) o un `BuildContext` interno al provider.

## 6) DI (GetIt)

Registrar por feature en su modulo `di/`.

- `Repository` como contrato de dominio.
- Implementacion concreta en `data`.
- `UseCases` como facade para presentation.
- `Cubit` como `registerFactory` (estado por pantalla).

## 7) Testing minimo por feature

Cada feature con logica debe tener:

1. test de un use case
2. test de un cubit
3. test de un widget critico

Para cubit:

- validar secuencia de estados
- validar mapeo de errores a codigos de UI
- validar efectos colaterales importantes

## 8) i18n

Toda cadena visible al usuario debe salir de `AppLocalizations`.
No hardcodear mensajes en widgets/cubits.

## 9) Checklist antes de merge

- [ ] Sin dependencias de `data` en `presentation`
- [ ] Cada clase en su archivo
- [ ] Cubit en flujos asincronos
- [ ] `flutter test` en verde
- [ ] Sin errores de analyzer
- [ ] Strings de UI internacionalizadas

## 10) Estado actual del proyecto

- `home` y `detail`: ya alineados con domain + use case + cubit.
- `auth`: alineado con strategies + use cases + cubit.
- `profile`: siguiente candidato para extraer `domain/usecases/cubit` completo.
- `settings` (tema/idioma en `main`): siguiente candidato para feature dedicada con cubit.

## 11) Conectividad y modo offline

Para conectividad, usar puerto + adapter (patron Adapter):

- Puerto: `core/network/network_status.dart`
- Adapter: `core/network/connectivity_network_status_adapter.dart`

Reglas:

- No confiar solo en `connectivity_plus` (wifi/mobile). Validar alcance real de internet.
- Si el remoto falla, intentar leer cache local antes de fallar la operacion.
- Si no hay cache, emitir excepcion offline explicita del dominio.
- La UI debe mostrar estado offline y opcion de sincronizar al reconectar.

Escenarios esperados:

- Sin red y sin cache: error claro + retry.
- Sin red con cache: funcionar en offline con banner/indicador visual.
- Reconexion: permitir actualizar o sincronizar.
