import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/usecases/auth_use_cases.dart';
import '../../features/auth/presentation/pages.dart';
import '../../features/detail/presentation/pages.dart';
import '../../features/home/presentation/pages/pages.dart';
import '../../features/profile/presentation/pages.dart';
import 'listenables/auth_refresh_listenable.dart';
import 'transitions/animated_branch_container.dart';
import 'app_routes.dart';
import 'shell/main_shell_scaffold.dart';

/// Configura la navegacion principal de la app.
///
/// Responsabilidades:
/// - Definir rutas y transiciones.
/// - Aplicar redirecciones segun estado de autenticacion.
/// - Mantener sincronizado GoRouter cuando cambia la sesion.
class AppRouter {
  AppRouter({
    required this.authUseCases,
  }) : _authRefresh = AuthRefreshListenable(authUseCases.watchAuthState()) {
    router = GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: _authRefresh,
      redirect: (context, state) {
        final path = state.matchedLocation;
        final isLoggedIn = authUseCases.getCurrentUser() != null;

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
            authUseCases: authUseCases,
          ),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        StatefulShellRoute(
          builder: (context, state, navigationShell) => MainShellScaffold(
            navigationShell: navigationShell,
          ),
          navigatorContainerBuilder: (context, navigationShell, children) {
            return AnimatedBranchContainer(
              navigationShell: navigationShell,
              children: children,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.profail,
                  builder: (context, state) => const ProfileScreen(),
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

  final AuthUseCases authUseCases;
  final AuthRefreshListenable _authRefresh;

  /// Instancia de router utilizada por `MaterialApp.router`.
  late final GoRouter router;

  /// Libera los recursos internos asociados al refresco por auth.
  void dispose() {
    _authRefresh.dispose();
  }
}
