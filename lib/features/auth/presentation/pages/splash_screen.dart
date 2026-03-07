import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/global_top_bar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/auth_service.dart';
import '../../../../core/router/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
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
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Future<bool> _sessionFuture =
      widget.authService.hasPersistedSession();
  bool _didRedirect = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: GlobalTopBar(
        locale: widget.locale,
        themeMode: widget.themeMode,
        onLocaleChanged: widget.onLocaleChanged,
        onThemeModeChanged: widget.onThemeModeChanged,
      ),
      body: FutureBuilder<bool>(
        future: _sessionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          final isAuthenticated = snapshot.data == true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            if (_didRedirect) {
              return;
            }
            _didRedirect = true;
            context.go(isAuthenticated ? AppRoutes.home : AppRoutes.login);
          });

          return Center(
            child: Text(
              l10n.loadingLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        },
      ),
    );
  }
}
