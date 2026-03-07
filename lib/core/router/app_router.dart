import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/auth_service.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/detail/presentation/detail_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter({
    required this.authService,
    required this.locale,
    required this.themeMode,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  }) : _authRefresh = _AuthRefreshListenable(authService.authStateChanges) {
    router = GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: _authRefresh,
      redirect: (context, state) {
        final path = state.matchedLocation;
        final isLoggedIn = authService.currentUser != null;

        final isAuthFree = path == AppRoutes.splash ||
            path == AppRoutes.login ||
            path == AppRoutes.register;

        if (!isLoggedIn && !isAuthFree) {
          return AppRoutes.login;
        }

        if (isLoggedIn &&
            (path == AppRoutes.login || path == AppRoutes.register)) {
          return AppRoutes.home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => SplashScreen(
            authService: authService,
            locale: locale(),
            themeMode: themeMode(),
            onLocaleChanged: onLocaleChanged,
            onThemeModeChanged: onThemeModeChanged,
          ),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => LoginScreen(
            authService: authService,
            locale: locale(),
            themeMode: themeMode(),
            onLocaleChanged: onLocaleChanged,
            onThemeModeChanged: onThemeModeChanged,
          ),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => RegisterScreen(
            authService: authService,
            locale: locale(),
            themeMode: themeMode(),
            onLocaleChanged: onLocaleChanged,
            onThemeModeChanged: onThemeModeChanged,
          ),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => HomeScreen(
            authService: authService,
            locale: locale(),
            themeMode: themeMode(),
            onLocaleChanged: onLocaleChanged,
            onThemeModeChanged: onThemeModeChanged,
          ),
        ),
        GoRoute(
          path: AppRoutes.detail,
          builder: (context, state) => DetailScreen(
            articleId: state.uri.queryParameters['id'] ?? 'unknown',
            locale: locale(),
            themeMode: themeMode(),
            onLocaleChanged: onLocaleChanged,
            onThemeModeChanged: onThemeModeChanged,
          ),
        ),
        GoRoute(
          path: AppRoutes.profail,
          builder: (context, state) => ProfileScreen(
            authService: authService,
            locale: locale(),
            themeMode: themeMode(),
            onLocaleChanged: onLocaleChanged,
            onThemeModeChanged: onThemeModeChanged,
          ),
        ),
      ],
    );
  }

  final AuthService authService;
  final Locale Function() locale;
  final ThemeMode Function() themeMode;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final _AuthRefreshListenable _authRefresh;

  late final GoRouter router;

  void dispose() {
    _authRefresh.dispose();
  }
}

class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
