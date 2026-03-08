import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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
  static const _minimumSplashDuration = Duration(milliseconds: 4000);
  static const _splashAssetPath = 'assets/animations/splash_animation.json';

  late final Future<bool> _sessionFuture = _resolveSession();
  late final Future<LottieComposition> _lottieCompositionFuture =
      AssetLottie(_splashAssetPath).load();
  bool _didRedirect = false;

  Future<bool> _resolveSession() async {
    final results = await Future.wait<bool>([
      widget.authService.hasPersistedSession(),
      Future<bool>.delayed(_minimumSplashDuration, () => false),
    ]);
    return results.first;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: FutureBuilder<bool>(
        future: _sessionFuture,
        builder: (context, snapshot) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final isDone = snapshot.connectionState == ConnectionState.done;

          if (isDone) {
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
          }

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? const [Color(0xFF0C1226), Color(0xFF070B16)]
                    : const [Color(0xFFEAF1FF), Color(0xFFF8FBFF)],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final animationHeight = constraints.maxHeight * 0.8;

                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: animationHeight,
                        child: FutureBuilder<LottieComposition>(
                          future: _lottieCompositionFuture,
                          builder: (context, compositionSnapshot) {
                            if (compositionSnapshot.connectionState !=
                                ConnectionState.done) {
                              return const SizedBox.expand();
                            }

                            final composition = compositionSnapshot.data;
                            if (composition == null) {
                              return const SizedBox.expand();
                            }

                            return Align(
                              alignment: Alignment.topCenter,
                              child: Lottie(
                                composition: composition,
                                fit: BoxFit.contain,
                                frameRate: FrameRate.max,
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: FutureBuilder<LottieComposition>(
                            future: _lottieCompositionFuture,
                            builder: (context, compositionSnapshot) {
                              if (compositionSnapshot.connectionState !=
                                  ConnectionState.done) {
                                return const SizedBox.shrink();
                              }

                              return Text(
                                l10n.loadingLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
