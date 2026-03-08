import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import 'auth_starfield_painter.dart';

/// Fondo animado reutilizable para pantallas de autenticacion.
class AuthSpaceBackground extends StatefulWidget {
  const AuthSpaceBackground({super.key});

  @override
  State<AuthSpaceBackground> createState() => _AuthSpaceBackgroundState();
}

class _AuthSpaceBackgroundState extends State<AuthSpaceBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  isDark
                      ? AppPalette.backgroundDark
                      : AppPalette.backgroundLight,
                  isDark
                      ? AppPalette.surfaceDarkAlt
                      : AppPalette.surfaceLightAlt,
                  _controller.value,
                )!,
                isDark ? AppPalette.surfaceDark : AppPalette.surfaceLight,
                Color.lerp(
                  isDark
                      ? AppPalette.surfaceDarkAlt
                      : AppPalette.surfaceLightAlt,
                  isDark ? AppPalette.secondary : AppPalette.accent,
                  _controller.value,
                )!,
              ],
            ),
          ),
          child: CustomPaint(
            painter: AuthStarfieldPainter(
              seed: 21,
              progress: _controller.value,
              isDark: isDark,
            ),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}
