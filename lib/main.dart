import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/generated/app_localizations.dart';

import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_service.dart';
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
  static const _localeLanguageCodeKey = 'preferred_locale_language_code';
  static const _themeModeKey = 'preferred_theme_mode';

  Locale _currentLocale = const Locale('es');
  ThemeMode _themeMode = ThemeMode.system;
  late final AppRouter _appRouter;

  Future<SharedPreferences?> _getSharedPreferencesSafe() async {
    try {
      return await SharedPreferences.getInstance();
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(
      authService: serviceLocator<AuthService>(),
      locale: () => _currentLocale,
      themeMode: () => _themeMode,
      onLocaleChanged: _setLocale,
      onThemeModeChanged: _setThemeMode,
    );
    _loadSavedPreferences();
  }

  @override
  void dispose() {
    _appRouter.dispose();
    super.dispose();
  }

  Future<void> _loadSavedPreferences() async {
    final prefs = await _getSharedPreferencesSafe();
    if (prefs == null) {
      return;
    }

    final savedLanguageCode = prefs.getString(_localeLanguageCodeKey);
    final savedThemeMode = prefs.getString(_themeModeKey);

    final supportedSavedLanguageCode =
        (savedLanguageCode == 'es' || savedLanguageCode == 'en')
            ? savedLanguageCode
            : null;
    final resolvedThemeMode = switch (savedThemeMode) {
      'system' => ThemeMode.system,
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    if (!mounted) {
      return;
    }

    setState(() {
      if (supportedSavedLanguageCode != null) {
        _currentLocale = Locale(supportedSavedLanguageCode);
      }
      _themeMode = resolvedThemeMode;
    });
  }

  Future<void> _setLocale(Locale locale) async {
    if (locale.languageCode == _currentLocale.languageCode) {
      return;
    }

    setState(() {
      _currentLocale = locale;
    });

    final prefs = await _getSharedPreferencesSafe();
    await prefs?.setString(_localeLanguageCodeKey, locale.languageCode);
  }

  Future<void> _setThemeMode(ThemeMode themeMode) async {
    if (themeMode == _themeMode) {
      return;
    }

    setState(() {
      _themeMode = themeMode;
    });

    final prefs = await _getSharedPreferencesSafe();
    final encodedThemeMode = switch (themeMode) {
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
    };

    await prefs?.setString(
      _themeModeKey,
      encodedThemeMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: _currentLocale,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      routerConfig: _appRouter.router,
    );
  }
}
