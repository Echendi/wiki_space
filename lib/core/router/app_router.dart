import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/space_bottom_nav_bar.dart';
import '../../features/auth/data/auth_service.dart';
import '../../features/auth/presentation/pages.dart';
import '../../features/detail/presentation/pages.dart';
import '../../features/home/presentation/pages/pages.dart';
import '../../features/profile/presentation/pages.dart';
import '../../l10n/generated/app_localizations.dart';
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
        StatefulShellRoute(
          builder: (context, state, navigationShell) => _MainShellScaffold(
            navigationShell: navigationShell,
          ),
          navigatorContainerBuilder: (context, navigationShell, children) {
            return _AnimatedBranchContainer(
              navigationShell: navigationShell,
              children: children,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
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
              ],
            ),
            StatefulShellBranch(
              routes: [
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
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.detail,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: DetailScreen(
              articleId: state.uri.queryParameters['id'] ?? 'unknown',
              locale: locale(),
              themeMode: themeMode(),
              onLocaleChanged: onLocaleChanged,
              onThemeModeChanged: onThemeModeChanged,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              );

              return FadeTransition(
                opacity: curved,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(curved),
                  child: child,
                ),
              );
            },
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

class _MainShellScaffold extends StatefulWidget {
  const _MainShellScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<_MainShellScaffold> createState() => _MainShellScaffoldState();
}

class _MainShellScaffoldState extends State<_MainShellScaffold> {
  static const Duration _exitGap = Duration(seconds: 2);
  DateTime? _lastBackPressedAt;

  void _handleBackPressed(BuildContext context) {
    final now = DateTime.now();
    final canExit = _lastBackPressedAt != null &&
        now.difference(_lastBackPressedAt!) <= _exitGap;

    if (canExit) {
      SystemNavigator.pop();
      return;
    }

    _lastBackPressedAt = now;

    final message = AppLocalizations.of(context).backPressExitHint;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: _exitGap,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _handleBackPressed(context);
      },
      child: Scaffold(
        extendBody: true,
        body: widget.navigationShell,
        bottomNavigationBar: SpaceBottomNavBar(
          currentIndex: widget.navigationShell.currentIndex,
          onTap: (index) {
            widget.navigationShell.goBranch(
              index,
              initialLocation: index == widget.navigationShell.currentIndex,
            );
          },
          homeLabel: l10n.navHome,
          profileLabel: l10n.navProfile,
        ),
      ),
    );
  }
}

class _AnimatedBranchContainer extends StatelessWidget {
  const _AnimatedBranchContainer({
    required this.navigationShell,
    required this.children,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final activeChild = KeyedSubtree(
      key: ValueKey<int>(navigationShell.currentIndex),
      child: children[navigationShell.currentIndex],
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.03, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
      child: activeChild,
    );
  }
}
