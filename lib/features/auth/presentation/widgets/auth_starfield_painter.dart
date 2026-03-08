import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Painter del fondo de estrellas usado en las pantallas auth.
class AuthStarfieldPainter extends CustomPainter {
  const AuthStarfieldPainter({
    required this.seed,
    required this.progress,
    required this.isDark,
  });

  final int seed;
  final double progress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(seed);
    final starPaint = Paint()..color = AppPalette.star;

    for (var i = 0; i < 100; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final twinkle = 0.4 + (rng.nextDouble() * 0.6);
      final animated =
          (0.75 + math.sin((progress * math.pi * 2) + i) * 0.25) * twinkle;
      starPaint.color =
          AppPalette.star.withValues(alpha: animated.clamp(0.2, 1));
      canvas.drawCircle(Offset(x, y), rng.nextDouble() * 1.8 + 0.4, starPaint);
    }

    final nebulaPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          (isDark ? AppPalette.primary : AppPalette.secondary)
              .withValues(alpha: isDark ? 0.25 : 0.17),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.82, size.height * 0.15),
          radius: size.width * 0.36,
        ),
      );

    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.15),
      size.width * 0.36,
      nebulaPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AuthStarfieldPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}
