import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpaceLogo extends StatelessWidget {
  const SpaceLogo({super.key, this.size = 112});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size.square(size),
          painter: _PlanetLogoPainter(),
        ),
        const SizedBox(height: 10),
        Text(
          'WIKI SPACE',
          style: GoogleFonts.orbitron(
            color: const Color(0xFFE8F4FF),
            letterSpacing: 2.2,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class _PlanetLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF55D6BE).withValues(alpha: 0.45),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, glowPaint);

    final planetPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4CE0C2), Color(0xFF2B8BCF)],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.62));

    canvas.drawCircle(center, radius * 0.62, planetPaint);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..color = const Color(0xFFF5F8FF).withValues(alpha: 0.88);

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
      ..color = const Color(0xFF0E3256).withValues(alpha: 0.2);
    canvas.drawCircle(center.translate(-radius * 0.15, -radius * 0.15),
        radius * 0.11, craterPaint);
    canvas.drawCircle(center.translate(radius * 0.18, radius * 0.06),
        radius * 0.08, craterPaint);

    final starPaint = Paint()..color = const Color(0xFFE8F4FF);
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
