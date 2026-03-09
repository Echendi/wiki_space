import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'l10n/generated/app_localizations.dart';

import 'core/config/app_env.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/settings/cubit/app_settings_cubit.dart';
import 'core/settings/cubit/app_settings_state.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/usecases/auth_use_cases.dart';
import 'features/auth/presentation/cubit/auth_session_cubit.dart';
import 'firebase_options.dart';

/// Punto de entrada de la aplicacion.
///
/// Inicializa entorno, Firebase y dependencias antes de montar la UI raiz.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  AppEnv.firebaseProjectId;

  await _initializeFirebase();
  await setupDependencies();

  runApp(const MainApp());
}

/// Inicializa Firebase cuando la plataforma esta configurada.
///
/// En plataformas sin configuracion, se ignora el error para no bloquear
/// ejecuciones de desarrollo local.
Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on UnsupportedError {
    // Permite ejecutar en plataformas no configuradas sin bloquear el arranque.
  }
}

/// Widget raiz de la aplicacion.
class MainApp extends StatefulWidget {
  /// Crea la aplicacion principal.
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

/// Estado de [MainApp] que construye providers globales y `MaterialApp`.
class _MainAppState extends State<MainApp> {
  /// Gestiona preferencias globales de tema e idioma.
  late final AppSettingsCubit _settingsCubit;

  /// Mantiene sesion de autenticacion activa para toda la app.
  late final AuthSessionCubit _authSessionCubit;

  /// Encapsula configuracion de rutas y redirecciones.
  late final AppRouter _appRouter;

  /// Inicializa cubits globales y router al arrancar la app.
  @override
  void initState() {
    super.initState();
    final authUseCases = serviceLocator<AuthUseCases>();
    _settingsCubit = AppSettingsCubit();
    _authSessionCubit = AuthSessionCubit(authUseCases);
    _appRouter = AppRouter(
      authUseCases: authUseCases,
    );
    _settingsCubit.loadSavedPreferences();
  }

  /// Libera recursos globales al desmontar la app raiz.
  @override
  void dispose() {
    _authSessionCubit.close();
    _settingsCubit.close();
    _appRouter.dispose();
    super.dispose();
  }

  /// Construye la app con providers globales y configuracion de tema/locale.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingsCubit>.value(value: _settingsCubit),
        BlocProvider<AuthSessionCubit>.value(value: _authSessionCubit),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, settingsState) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            locale: settingsState.locale,
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: settingsState.themeMode,
            routerConfig: _appRouter.router,
          );
        },
      ),
    );
  }
}
