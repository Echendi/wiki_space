import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'l10n/generated/app_localizations.dart';

import 'core/di/service_locator.dart';
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
  Locale _currentLocale = const Locale('es');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _currentLocale,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);

          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.helloWorld,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${l10n.languageLabel}: '),
                      DropdownButton<Locale>(
                        value: _currentLocale,
                        onChanged: (newLocale) {
                          if (newLocale == null) {
                            return;
                          }
                          setState(() {
                            _currentLocale = newLocale;
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            value: const Locale('es'),
                            child: Text(l10n.spanishOption),
                          ),
                          DropdownMenuItem(
                            value: const Locale('en'),
                            child: Text(l10n.englishOption),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
