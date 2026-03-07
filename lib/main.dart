import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/generated/app_localizations.dart';

import 'core/di/service_locator.dart';
import 'features/auth/data/auth_service.dart';
import 'features/auth/presentation/auth_gate.dart';
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
  Locale _currentLocale = const Locale('es');

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
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await _getSharedPreferencesSafe();
    if (prefs == null) {
      return;
    }

    final savedLanguageCode = prefs.getString(_localeLanguageCodeKey);
    final supportedSavedLanguageCode =
        (savedLanguageCode == 'es' || savedLanguageCode == 'en')
            ? savedLanguageCode
            : null;

    if (supportedSavedLanguageCode == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _currentLocale = Locale(supportedSavedLanguageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _currentLocale,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF55D6BE),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.spaceGroteskTextTheme(),
      ),
      home: AuthGate(authService: serviceLocator<AuthService>()),
    );
  }
}
