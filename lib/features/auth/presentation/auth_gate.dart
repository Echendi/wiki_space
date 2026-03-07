import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/global_top_bar.dart';
import '../../home/presentation/home_screen.dart';
import '../data/auth_service.dart';
import 'login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({
    super.key,
    required this.authService,
    required this.locale,
    required this.themeMode,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final AuthService authService;
  final Locale locale;
  final ThemeMode themeMode;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<bool> _sessionCheck =
      widget.authService.hasPersistedSession();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _sessionCheck,
      builder: (context, sessionSnapshot) {
        if (sessionSnapshot.connectionState != ConnectionState.done) {
          return _AuthLoadingScreen(
            locale: widget.locale,
            themeMode: widget.themeMode,
            onLocaleChanged: widget.onLocaleChanged,
            onThemeModeChanged: widget.onThemeModeChanged,
          );
        }

        return StreamBuilder<User?>(
          stream: widget.authService.authStateChanges,
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return _AuthLoadingScreen(
                locale: widget.locale,
                themeMode: widget.themeMode,
                onLocaleChanged: widget.onLocaleChanged,
                onThemeModeChanged: widget.onThemeModeChanged,
              );
            }

            final user = authSnapshot.data;
            if (user == null) {
              return LoginScreen(
                authService: widget.authService,
                locale: widget.locale,
                themeMode: widget.themeMode,
                onLocaleChanged: widget.onLocaleChanged,
                onThemeModeChanged: widget.onThemeModeChanged,
              );
            }

            return HomeScreen(
              authService: widget.authService,
              locale: widget.locale,
              themeMode: widget.themeMode,
              onLocaleChanged: widget.onLocaleChanged,
              onThemeModeChanged: widget.onThemeModeChanged,
            );
          },
        );
      },
    );
  }
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen({
    required this.locale,
    required this.themeMode,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final Locale locale;
  final ThemeMode themeMode;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalTopBar(
        locale: locale,
        themeMode: themeMode,
        onLocaleChanged: onLocaleChanged,
        onThemeModeChanged: onThemeModeChanged,
      ),
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
