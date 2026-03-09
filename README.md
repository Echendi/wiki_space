# wiki_space

## Tabla de contenido

- [Descripcion general](#descripcion-general)
- [Instalacion y ejecucion](#instalacion-y-ejecucion)
- [Arquitectura aplicada](#arquitectura-aplicada)
- [Estrategia offline](#estrategia-offline)
- [Flujo de autenticacion](#flujo-de-autenticacion)
- [Decisiones tecnicas justificadas](#decisiones-tecnicas-justificadas)
- [Documentacion de pruebas](#documentacion-de-pruebas)
- [Mejoras futuras](#mejoras-futuras)

## Descripcion general

`wiki_space` es una aplicacion Flutter orientada a consulta de contenido tipo wiki sobre astronomia y el espacio, con soporte de autenticacion, navegacion por rutas, cache local y experiencia bilingue (es/en).

El proyecto esta organizado por features y aplica una separacion por capas (`data`, `domain`, `presentation`) para facilitar mantenibilidad, pruebas y evolucion incremental.

Tecnologias principales:

- Flutter + Dart
- Firebase Auth (email/password y proveedores sociales)
- BLoC/Cubit para manejo de estado
- Drift para persistencia local
- Dio para integracion HTTP
- GoRouter para navegacion
- Localizacion con ARB + `AppLocalizations`

## Instalacion y ejecucion

### Prerrequisitos

- Flutter SDK instalado y en `PATH`
- SDK de Dart compatible con el rango del proyecto (`>=3.0.0 <4.0.0`)
- Android Studio o VS Code con emulador/dispositivo disponible

### 1) Clonar e instalar dependencias

```bash
git clone <url-del-repositorio>
cd wiki_space
flutter pub get
```

### 2) Configurar variables de entorno

Para esta prueba tecnica, crea `.env` en la raiz con estos valores:

```dotenv
FIREBASE_ANDROID_API_KEY=AIzaSyCPapMcZmq2kx9lj1M73qTl-hYLGX_5KZo
FIREBASE_ANDROID_APP_ID=1:781393003082:android:dbc8a2fe19f16b6ad6dcb3
FIREBASE_MESSAGING_SENDER_ID=781393003082
FIREBASE_PROJECT_ID=echendi-wiki-space
FIREBASE_STORAGE_BUCKET=echendi-wiki-space.firebasestorage.app
FIREBASE_IOS_API_KEY=AIzaSyDWWyazcNzV4MR6xPQcC9ATVFGzjAQkL9g
FIREBASE_IOS_APP_ID=1:781393003082:ios:6a758e248f1563ebd6dcb3
FIREBASE_IOS_CLIENT_ID=781393003082-88f7jjofpdjcs3s7t4egsip56gqr1j08.apps.googleusercontent.com
FIREBASE_IOS_BUNDLE_ID=com.example.wikiSpace
WIKIPEDIA_API_ENDPOINT_TEMPLATE=https://{lang}.wikipedia.org/w/api.php
WIKI_REQUEST_TIMEOUT_SECONDS=12
NETWORK_PROBE_URL=https://www.google.com/generate_204
NETWORK_PROBE_TIMEOUT_SECONDS=4
```

### Usuario de prueba

Para validar rapidamente el flujo de autenticacion, puedes usar:

- Email: `admin@test.com`
- Password: `Admin123*`

### 3) Ejecutar la aplicacion

```bash
flutter run
```

### 4) Validar calidad basica antes de cambios

```bash
flutter analyze
flutter test
```

## Arquitectura aplicada

El proyecto aplica una arquitectura por features con capas `data`, `domain` y `presentation`, mas un nucleo transversal en `core`.

### Estructura de carpetas

```text
lib/
	core/
		config/
		di/
		network/
		router/
		services/
		settings/
		theme/
		widgets/
	features/
		auth/
			data/
			di/
			domain/
			presentation/
		detail/
			data/
			di/
			domain/
			presentation/
		home/
			data/
			di/
			domain/
			presentation/
				cubit/
				pages/
				widgets/
					cards/
					components/
					content/
					feedback/
		profile/
			presentation/
	l10n/
	main.dart
```

### Patrones usados y donde

- Clean Architecture (por capas):
  - `features/*/data`
  - `features/*/domain`
  - `features/*/presentation`

- Strategy (autenticacion):
  - Contrato: `lib/features/auth/data/strategies/auth_sign_in_strategy.dart`
  - Implementaciones: `lib/features/auth/data/strategies/email_password_sign_in_strategy.dart`, `lib/features/auth/data/strategies/google_sign_in_strategy.dart`
  - Orquestacion: `lib/features/auth/data/firebase_auth_service.dart` (`signInWithStrategy`)

- Adapter (offline/conectividad):
  - Puerto: `lib/core/network/network_status.dart`
  - Adapter concreto: `lib/core/network/connectivity_network_status_adapter.dart`

- Repository:
  - Contrato: `lib/features/auth/domain/repositories/auth_repository.dart`
  - Implementacion: `lib/features/auth/data/firebase_auth_service.dart`
  - Ejemplo adicional: `lib/features/detail/domain/repositories/article_detail_repository.dart` y `lib/features/detail/data/repositories/article_detail_repository_impl.dart`

- Use Case:
  - Casos de uso auth en `lib/features/auth/domain/usecases/*.dart`
  - Ejemplo: `lib/features/auth/domain/usecases/sign_in_with_email_and_password_use_case.dart`

- Facade (agrupacion de casos de uso):
  - `lib/features/auth/domain/usecases/auth_use_cases.dart`

- Factory Method (creacion desde repositorio):
  - `AuthUseCases.fromRepository(...)` en `lib/features/auth/domain/usecases/auth_use_cases.dart`

- Dependency Injection (IoC con service locator):
  - Registro global: `lib/core/di/service_locator.dart`
  - Registros por feature: `lib/features/*/di/*.dart`

- State Management (Cubit/BLoC):
  - `lib/features/auth/presentation/cubit/auth_cubit.dart`
  - `lib/features/detail/presentation/cubit/detail_cubit.dart`
  - `lib/features/home/presentation/cubit/home_cubit.dart`

### Principios aplicados (SOLID)

- S (Single Responsibility):
  - Casos de uso dedicados por accion, por ejemplo `sign_out_use_case.dart` o `watch_auth_state_use_case.dart`.
  - Adaptador de conectividad enfocado solo en verificar internet real: `connectivity_network_status_adapter.dart`.

- O (Open/Closed):
  - Se pueden agregar nuevas estrategias de login implementando `AuthSignInStrategy` sin romper consumidores existentes.

- L (Liskov Substitution):
  - Implementaciones de repositorio sustituyen contratos de dominio (`AuthRepository`, `ArticleDetailRepository`) manteniendo el comportamiento esperado.

- I (Interface Segregation):
  - Contratos y casos de uso pequenos y orientados a operaciones concretas, evitando APIs gigantes en presentation.

- D (Dependency Inversion):
  - `presentation` depende de `usecases` y contratos de `domain`, no de SDKs concretos.
  - La infraestructura (`FirebaseAuthService`, adapters) se inyecta via DI.

Referencia interna:

- Guia de arquitectura y convenciones: `docs/architecture_guidelines.md`

## Estrategia offline

La app usa una estrategia `online-first` con fallback local para mantener continuidad cuando no hay internet.

### Componentes clave

- Puerto de conectividad: `lib/core/network/network_status.dart`
- Adapter de conectividad: `lib/core/network/connectivity_network_status_adapter.dart`
- Servicio global de estado online/offline: `lib/core/services/connectivity_status_service.dart`
- Cache Home (Drift): `lib/features/home/data/datasources/home_cache_database.dart`
- Cache Detail (Drift): `lib/features/detail/data/datasources/article_detail_cache_database.dart`

### Por que Drift es la mejor opcion en este proyecto

Drift es la mejor opcion para `wiki_space` por el tipo de datos y el flujo offline que se requiere:

- Consultas estructuradas y filtradas: en Home se filtra por idioma, query y paginacion (`getCachedArticles`), algo mas robusto que un key-value plano.
- Upsert y operaciones por lote: se usa `insertAllOnConflictUpdate` e `insertOnConflictUpdate` para mantener cache consistente sin duplicados.
- Transacciones atomicas: `cacheArticles` usa `transaction` para evitar estados intermedios al limpiar y reinsertar datos.
- Persistencia local confiable y tipada: esquema versionado (`schemaVersion`) y modelos tipados reducen errores de mapeo.
- Escalabilidad: permite agregar TTL, limpieza y migraciones futuras sin reescribir la capa de datos.

### Flujo de almacenamiento de cache

Home:

1. `SpaceRepositoryImpl.getSpaceArticles(...)` verifica conectividad real con `NetworkStatus`.
2. Si hay internet, consulta remoto en `SpaceRemoteDataSource.fetchSpaceArticles(...)`.
3. Persiste respuesta en Drift con `_localDataSource.cacheArticles(...)`.
4. `HomeCacheDatabase.cacheArticles(...)`:
   - opcionalmente limpia cache previa por idioma cuando corresponde,
   - inserta en lote con `insertAllOnConflictUpdate`,
   - marca `updatedAt` para ordenar por recencia.

Detail:

1. `ArticleDetailRepositoryImpl.getArticleDetail(...)` verifica conectividad.
2. Si hay internet, obtiene detalle remoto y lo guarda con `_localDataSource.cacheDetail(...)`.
3. `ArticleDetailCacheDatabase.cacheDetail(...)` aplica `insertOnConflictUpdate` con `cachedAt`.

### Flujo de recuperacion de cache

Home:

1. Si no hay internet o falla la llamada remota, el repositorio consulta `_localDataSource.getCachedArticles(...)`.
2. `HomeCacheDatabase.getCachedArticles(...)` filtra por idioma/query y pagina (`limit/offset`), ordenado por `updatedAt`.
3. Si hay elementos, retorna `SpaceArticlesResult` con `isOfflineMode: true` e `isFromCache: true`.
4. Si no hay elementos, lanza `OfflineNoCachedDataException` (`offline-no-cache`).

Detail:

1. Si no hay internet o falla remoto, consulta `_localDataSource.getCachedDetail(articleId, languageCode)`.
2. Si existe cache, retorna `SpaceArticleDetail` desde Drift.
3. Si no existe, lanza `OfflineNoCachedDetailException` (`detail-offline-no-cache`).

### Resultado en experiencia de usuario

- Con red: datos remotos y cache refrescada.
- Sin red con cache: continuidad funcional con banner offline.
- Sin red y sin cache: mensaje claro de ausencia de datos y opcion de reintento al reconectar.

## Flujo de autenticacion

La autenticacion se modela con un flujo por capas: UI -> Cubit -> UseCase -> Repository -> Firebase.

### Secuencia principal (login email)

1. `LoginScreen` valida formulario y llama `AuthCubit.signInWithEmail(...)`.
2. `AuthCubit` emite `loading` y ejecuta `AuthUseCases.signInWithEmailAndPassword(...)`.
3. El caso de uso delega en `AuthRepository`.
4. `FirebaseAuthService` aplica estrategia (`EmailPasswordSignInStrategy`) y autentica contra Firebase.
5. Si el login es exitoso, persiste sesion local (`auth_uid`, `auth_token`) y el cubit emite `success`.
6. `AuthSessionCubit` escucha `watchAuthState()` y actualiza el usuario global.
7. `AppRouter` reevalua `redirect` y envia al usuario a `home`.

### Manejo de errores

- `FirebaseAuthException` se normaliza a `AuthException` con `code` estable en `FirebaseAuthService`.
- `AuthCubit` convierte errores a `errorCode` para UI.
- `LoginScreen` traduce `errorCode` a mensajes localizados con `AppLocalizations`.

### Inicio de app y sesion persistida

- `SplashScreen`/`AuthGate` valida `hasPersistedSession()`.
- Si hay sesion valida, se evita pedir login nuevamente.
- El stream `watchAuthState()` mantiene sincronizado el estado de sesion.

### Proteccion de rutas y redireccion

La proteccion de rutas se aplica en `AppRouter` con `GoRouter.redirect`:

- Si el usuario no esta autenticado y navega a una ruta protegida, se redirige a `AppRoutes.login`.
- Si el usuario ya esta autenticado e intenta abrir `login` o `register`, se redirige a `AppRoutes.home`.
- Solo `splash`, `login` y `register` son rutas libres sin sesion.

Ademas, el router se refresca automaticamente cuando cambia la autenticacion:

- `AuthRefreshListenable` escucha `watchAuthState()` y dispara `notifyListeners()`.
- Esto fuerza a GoRouter a reevaluar `redirect` en tiempo real.

En el arranque, `SplashScreen` resuelve `hasPersistedSession()` y redirige con `context.go(...)` a `home` o `login` segun el resultado.

### Como se almacena la sesion

El almacenamiento de sesion se realiza en `FirebaseAuthService` con dos mecanismos complementarios:

- Sesion nativa de Firebase: `FirebaseAuth.currentUser` y `authStateChanges()`.
- Persistencia local adicional en `FlutterSecureStorage`:
  - `auth_uid`
  - `auth_token`

Flujo de persistencia:

1. Login exitoso (`email` o `google`) ejecuta `_persistSession(uid)`.
2. Se obtiene token con `getIdToken()` y se guarda en secure storage.
3. Se guarda tambien `uid` para validacion rapida de sesion persistida.

Flujo de recuperacion:

1. `hasPersistedSession()` revisa primero `FirebaseAuth.currentUser`.
2. Si existe usuario activo, sincroniza storage local y retorna `true`.
3. Si no existe usuario en memoria, valida si hay `auth_uid` en secure storage.

Flujo de cierre:

- `signOut()` limpia sesion en Google/Firebase y elimina `auth_uid` y `auth_token` de secure storage.

### Proveedores sociales

- Google: implementado via estrategia `GoogleSignInStrategy`.
- Facebook: actualmente no implementado en backend (`facebook-not-implemented`) y la UI muestra mensaje controlado.

```mermaid
sequenceDiagram
	participant UI as LoginScreen
	participant C as AuthCubit
	participant U as AuthUseCases
	participant R as AuthRepository
	participant F as FirebaseAuthService
	participant S as AuthSessionCubit
	participant G as GoRouter

	UI->>C: signInWithEmail(email, password)
	C->>C: emit(loading)
	C->>U: signInWithEmailAndPassword()
	U->>R: signInWithEmailAndPassword()
	R->>F: execute strategy
	F-->>R: success / AuthException
	alt success
		R-->>U: ok
		U-->>C: ok
		C->>C: emit(success)
		S->>S: update user from watchAuthState()
		G->>G: redirect to /home
	else failure
		U-->>C: throw AuthException
		C->>C: emit(failure, errorCode)
		UI->>UI: show localized SnackBar
	end
```

## Decisiones tecnicas relevantes

### Matriz de decisiones

| Decision                                         | Alternativas evaluadas                                                                                                      | Motivo final                                                                                                  |
| ------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| API remota: Wikipedia API + `Dio`                | APIs publicas de astronomia con cobertura mas limitada en multiidioma (por ejemplo NASA APOD, NASA Image and Video Library) | Rapida salida a produccion, alto volumen de contenido espacial, soporte `es/en`, bajo costo operativo inicial |
| Persistencia local: Drift                        | Isar, `shared_preferences`, key-value puro                                                                                  | Consultas por idioma/query/paginacion, upsert por lote, transacciones y tipado fuerte                         |
| Gestor de estado: Cubit/BLoC                     | `setState` global, Provider simple, Riverpod/Redux                                                                          | Flujo asincrono claro, estados predecibles, alta testabilidad y baja complejidad de adopcion en el equipo     |
| Conectividad: puerto + adapter (`NetworkStatus`) | Uso directo de `connectivity_plus` en UI                                                                                    | Evita acoplamiento con plugin y falsos positivos al validar internet real con probe HTTP                      |
| Auth extensible con Strategy                     | Condicionales `if/else` por proveedor en un solo servicio                                                                   | Escalabilidad para nuevos proveedores sin romper flujo principal                                              |
| DI con GetIt por feature                         | Instanciacion manual en widgets, service locator global sin modulos                                                         | Composicion explicita, reemplazo facil en pruebas y control de ciclo de vida                                  |

### 1) Eleccion del API remoto (Wikipedia API via Dio)

Decision:
Usar Wikipedia API como fuente principal de contenido para Home y Detail, consumida con `Dio`.

Donde se aplica:

- `lib/features/home/data/datasources/space_remote_data_source_impl.dart`
- `lib/features/detail/data/datasources/article_detail_remote_data_source_impl.dart`
- `lib/core/config/app_env.dart` (`wikipediaApiEndpoint(...)`, timeouts)

Justificacion tecnica:

- Cobertura tematica alta para astronomia/espacio sin mantener backend propio en esta etapa.
- Soporte natural de internacionalizacion por subdominio (`es`/`en`) alineado con la app bilingue.
- Endpoints y parametros flexibles para busqueda y detalle (`generator=search`, `prop=extracts|pageimages|info`).
- Integracion HTTP robusta con `Dio` para timeout, control de errores y futuras extensiones (interceptors, retry, logging).
- Configuracion externalizada con `.env`, evitando hardcode de endpoint y permitiendo evolucion sin tocar logica de negocio.

Trade-offs asumidos:

- Dependencia de disponibilidad y cambios de terceros.
- Variabilidad en calidad/relevancia de resultados.

Mitigacion actual:

- Fallback a cache local cuando no hay conectividad o falla remoto.
- Normalizacion de idioma y manejo de errores en repositorios/cubits.

### 2) Base de datos local para persistencia offline (Drift)

Decision:
Usar Drift como capa de persistencia local para cache estructurada de Home y Detail.

Donde se aplica:

- `lib/features/home/data/datasources/home_cache_database.dart`
- `lib/features/detail/data/datasources/article_detail_cache_database.dart`
- tablas generadas desde `cached_space_articles.dart` y `cached_article_details.dart`

Justificacion tecnica:

- Datos con estructura relacional ligera (idioma, articulo, timestamps) y consultas filtradas por query/paginacion.
- Necesidad de upsert eficiente para refrescar contenido sin duplicados (`insertAllOnConflictUpdate`, `insertOnConflictUpdate`).
- Soporte de transacciones atomicas para consistencia de cache (`transaction` en Home).
- Tipado fuerte y versionado de esquema (`schemaVersion`) para reducir errores y habilitar migraciones futuras.
- Buen equilibrio entre simplicidad de implementacion y escalabilidad frente a un almacenamiento key-value.

Por que no solo key-value:

- La app requiere filtros por texto, idioma, orden por fecha y paginacion; en key-value estas operaciones son mas costosas y manuales.

### 3) Gestor de estado (Cubit/BLoC)

Decision:
Adoptar Cubit para flujos asincronos principales (auth, home, detail, settings/session global).

Donde se aplica:

- `lib/features/auth/presentation/cubit/auth_cubit.dart`
- `lib/features/auth/presentation/cubit/auth_session_cubit.dart`
- `lib/features/home/presentation/cubit/home_cubit.dart`
- `lib/features/detail/presentation/cubit/detail_cubit.dart`
- `lib/core/settings/cubit/app_settings_cubit.dart`

Justificacion tecnica:

- Modelo de estado explicito para UI (`idle/loading/success/failure`) con transiciones predecibles.
- Centraliza reglas de negocio de presentacion (mapeo de errores, retry, estado offline) y simplifica widgets.
- Mejor testabilidad con pruebas de secuencia de estados (`bloc_test`).
- Menor friccion de adopcion comparado con patrones mas complejos, manteniendo buena separacion de responsabilidades.

### 4) Clean Architecture por feature

Decision:
Separar `data`, `domain`, `presentation` y `di` por feature.

Justificacion tecnica:

- Reduce acoplamiento entre UI e infraestructura.
- Facilita reemplazar implementaciones concretas sin impactar casos de uso ni pantallas.
- Permite evolucion incremental por modulo (auth, home, detail, profile).

### 5) Patrones complementarios clave

Strategy (auth):

- Contrato: `lib/features/auth/data/strategies/auth_sign_in_strategy.dart`
- Valor: habilita extensibilidad de proveedores sin romper el repositorio principal.

Adapter (offline):

- Puerto: `lib/core/network/network_status.dart`
- Implementacion: `lib/core/network/connectivity_network_status_adapter.dart`
- Valor: desacopla la app del plugin y valida internet real, no solo tipo de red.

Repository + UseCase:

- Contratos en `domain`, implementaciones en `data`, orquestacion en `usecases`.
- Valor: aplica inversion de dependencias y deja la UI orientada a casos de uso.

### 6) DI, i18n y decisiones operativas

DI con GetIt:

- Registro en `lib/core/di/service_locator.dart` y `lib/features/*/di/*.dart`.
- Valor: composicion explicita, facil reemplazo en pruebas y ciclo de vida controlado.

i18n obligatoria:

- Mensajes visibles desde `AppLocalizations` (ES/EN).
- Valor: consistencia de UX y menor deuda tecnica de textos hardcodeados.

Facebook temporalmente no implementado:

- Se retorna error controlado (`facebook-not-implemented`) y UI muestra feedback claro.
- Valor: evita fallos ambiguos mientras se completa integracion real.

## Documentacion de pruebas

Actualmente se implemento una base de pruebas enfocada en autenticacion cubriendo 3 niveles: cubit, caso de uso y widget.

Pruebas implementadas:

- Cubit:
  - `test/features/auth/presentation/cubit/auth_cubit_test.dart`
  - Cobertura: secuencia de estados (`loading/success/failure`) y mapeo de errores (`invalid-credential`, `google-config-error`).

- Caso de uso:
  - `test/features/auth/domain/usecases/sign_in_with_email_and_password_use_case_test.dart`
  - Cobertura: delegacion al repositorio y propagacion de `AuthException`.

- Widget:
  - `test/features/auth/presentation/widgets/themed_auth_field_test.dart`
  - Cobertura: validacion de formulario y comportamiento visual (`obscureText`, `suffixIcon`).

Comandos utiles:

```bash
flutter test
flutter test test/features/auth/presentation/cubit/auth_cubit_test.dart
flutter test test/features/auth/domain/usecases/sign_in_with_email_and_password_use_case_test.dart
flutter test test/features/auth/presentation/widgets/themed_auth_field_test.dart
```

Referencia detallada:

- `test/README.md`

## Mejoras futuras

### Busqueda

- Optimizar relevancia de resultados con ranking por coincidencia en titulo, descripcion y popularidad.
- Agregar sugerencias en tiempo real (autocomplete) con historial local de busquedas.
- Implementar filtros avanzados (categoria, idioma, fecha de actualizacion, tipo de contenido).
- Incorporar correccion ortografica y tolerancia a errores tipograficos.
- Medir analytics de busqueda (queries sin resultados, CTR de resultados, tiempo hasta click) para mejorar iterativamente.

### Recursos de astronomia y espacio

- Integrar fuentes externas confiables (por ejemplo NASA APOD, NASA Image and Video Library, ESA, observatorios publicos).
- Crear un agregador de contenido por tema (planetas, misiones, telescopios, cosmologia) con normalizacion de metadatos.
- Habilitar fichas enriquecidas con imagen, fuente, fecha y enlace al recurso original.
- Definir estrategia de cache y fallback offline para estos recursos externos.
- Agregar versionado de conectores para facilitar mantenimiento cuando cambie un API externo.

### Favoritos y personalizacion

- Implementar seleccion de articulos favoritos con persistencia local y opcion de sincronizacion por usuario autenticado.
- Permitir colecciones personalizadas (por ejemplo: "Quiero leer", "Misiones favoritas", "Astronomia basica").
- Agregar opcion de descargar favoritos para lectura offline priorizada.
- Incluir ordenamiento y busqueda dentro de favoritos.
- Exponer acciones rapidas en UI: guardar/quitar favorito desde Home y Detail.

### Autenticacion

- Implementar proveedor Facebook end-to-end (UI + data + estrategia real) y retirar fallback `not-implemented`.
- Agregar pruebas de flujo de registro y cierre de sesion.
- Agregar pruebas de redireccion por auth en router.

### Offline y datos

- Definir politica de expiracion (TTL) de cache para Home y Detail.
- Incorporar limpieza de cache antigua por fecha/tamano.
- Agregar telemetria para medir tasa de hits de cache vs remoto.

### Arquitectura y calidad

- Completar extraccion de `profile` a capas `domain/data` con casos de uso dedicados.
- Incrementar cobertura de pruebas para `home` y `detail` (repositorios + cubits).

### Experiencia de usuario

- Mejorar feedback de reconexion (retry automatico configurable por pantalla).
- Fortalecer accesibilidad (semantics, contraste y navegacion por teclado).
- Continuar refinamiento de mensajes localizados ES/EN y documentacion funcional.
