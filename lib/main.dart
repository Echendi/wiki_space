import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'l10n/generated/app_localizations.dart';

import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/settings/cubit/app_settings_cubit.dart';
import 'core/settings/cubit/app_settings_state.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/usecases/auth_use_cases.dart';
import 'features/auth/presentation/cubit/auth_session_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebase();
  await setupDependencies();

  runApp(const MainApp());
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on UnsupportedError {
    // Permite ejecutar en plataformas no configuradas sin bloquear el arranque.
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AppSettingsCubit _settingsCubit;
  late final AuthSessionCubit _authSessionCubit;
  late final AppRouter _appRouter;

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

  @override
  void dispose() {
    _authSessionCubit.close();
    _settingsCubit.close();
    _appRouter.dispose();
    super.dispose();
  }

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
