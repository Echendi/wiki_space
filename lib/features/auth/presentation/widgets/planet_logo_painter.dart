import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Painter del isotipo planetario usado por [SpaceLogo].
class PlanetLogoPainter extends CustomPainter {
  const PlanetLogoPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppPalette.primary.withValues(alpha: isDark ? 0.45 : 0.28),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, glowPaint);

    final planetPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppPalette.primary, AppPalette.secondary],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.62));

    canvas.drawCircle(center, radius * 0.62, planetPaint);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..color = AppPalette.star.withValues(alpha: isDark ? 0.88 : 0.72);

    final ringRect = Rect.fromCenter(
      center: center.translate(0, 4),
      width: radius * 1.8,
      height: radius * 0.72,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-0.35);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawOval(ringRect, ringPaint);
    canvas.restore();

    final craterPaint = Paint()
      ..color = AppPalette.onPrimary.withValues(alpha: 0.2);
    canvas.drawCircle(center.translate(-radius * 0.15, -radius * 0.15),
        radius * 0.11, craterPaint);
    canvas.drawCircle(center.translate(radius * 0.18, radius * 0.06),
        radius * 0.08, craterPaint);

    final starPaint = Paint()..color = AppPalette.star;
    for (var i = 0; i < 6; i++) {
      final angle = (i / 6) * 2 * math.pi;
      final distance = radius * 0.95;
      final star = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );
      canvas.drawCircle(star, 1.8, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PlanetLogoPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
