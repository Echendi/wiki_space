import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

class SpaceSceneBackground extends StatelessWidget {
  const SpaceSceneBackground({
    super.key,
    required this.isDark,
    required this.child,
  });

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final gradientColors =
        isDark ? AppPalette.homeDarkGradient : AppPalette.homeLightGradient;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(
            child: _SpaceDecorLayer(isDark: isDark),
          ),
          child,
        ],
      ),
    );
  }
}

class _SpaceDecorLayer extends StatelessWidget {
  const _SpaceDecorLayer({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final glowA = isDark
        ? const Color(0xFF4CC9F0).withValues(alpha: 0.2)
        : const Color(0xFF4CC9F0).withValues(alpha: 0.14);
    final glowB = isDark
        ? const Color(0xFFF72585).withValues(alpha: 0.18)
        : const Color(0xFFFF7BA8).withValues(alpha: 0.12);
    final glowC = isDark
        ? const Color(0xFFF9C74F).withValues(alpha: 0.16)
        : const Color(0xFFF2C14E).withValues(alpha: 0.1);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            _GlowBlob(
              left: -60,
              top: -40,
              size: 220,
              color: glowA,
            ),
            _GlowBlob(
              right: -70,
              top: 160,
              size: 200,
              color: glowB,
            ),
            _GlowBlob(
              left: constraints.maxWidth * 0.2,
              bottom: -80,
              size: 240,
              color: glowC,
            ),
            _Planet(
              left: constraints.maxWidth * 0.68,
              top: 70,
              size: 70,
              colorA: const Color(0xFF43AA8B),
              colorB: const Color(0xFF577590),
              ringColor: isDark
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.36),
            ),
            _Planet(
              left: constraints.maxWidth * 0.06,
              top: 210,
              size: 48,
              colorA: const Color(0xFFF9844A),
              colorB: const Color(0xFFF9C74F),
            ),
            _Planet(
              left: constraints.maxWidth * 0.82,
              bottom: 120,
              size: 40,
              colorA: const Color(0xFF9B5DE5),
              colorB: const Color(0xFF4CC9F0),
            ),
            _StarField(isDark: isDark),
          ],
        );
      },
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.size,
    required this.color,
  });

  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _Planet extends StatelessWidget {
  const _Planet({
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.size,
    required this.colorA,
    required this.colorB,
    this.ringColor,
  });

  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double size;
  final Color colorA;
  final Color colorB;
  final Color? ringColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (ringColor != null)
              Transform.rotate(
                angle: -0.2,
                child: Container(
                  width: size * 1.5,
                  height: size * 0.35,
                  decoration: BoxDecoration(
                    border: Border.all(color: ringColor!, width: 2),
                    borderRadius: BorderRadius.circular(size),
                  ),
                ),
              ),
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorA, colorB],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorA.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StarField extends StatelessWidget {
  const _StarField({required this.isDark});

  final bool isDark;

  static const List<_StarSpec> _stars = [
    _StarSpec(0.07, 0.09, 2.0),
    _StarSpec(0.14, 0.18, 1.6),
    _StarSpec(0.23, 0.12, 2.4),
    _StarSpec(0.31, 0.07, 1.4),
    _StarSpec(0.4, 0.2, 2.2),
    _StarSpec(0.52, 0.1, 1.5),
    _StarSpec(0.61, 0.18, 1.8),
    _StarSpec(0.72, 0.08, 2.1),
    _StarSpec(0.85, 0.16, 1.7),
    _StarSpec(0.92, 0.1, 2.3),
    _StarSpec(0.08, 0.33, 1.5),
    _StarSpec(0.19, 0.39, 2.1),
    _StarSpec(0.28, 0.31, 1.4),
    _StarSpec(0.36, 0.44, 1.9),
    _StarSpec(0.45, 0.36, 1.3),
    _StarSpec(0.58, 0.41, 2.0),
    _StarSpec(0.66, 0.34, 1.5),
    _StarSpec(0.78, 0.42, 1.8),
    _StarSpec(0.89, 0.36, 1.2),
    _StarSpec(0.93, 0.48, 2.0),
    _StarSpec(0.05, 0.62, 1.7),
    _StarSpec(0.16, 0.7, 2.2),
    _StarSpec(0.24, 0.56, 1.5),
    _StarSpec(0.35, 0.64, 2.1),
    _StarSpec(0.49, 0.58, 1.3),
    _StarSpec(0.6, 0.7, 1.9),
    _StarSpec(0.73, 0.61, 1.4),
    _StarSpec(0.82, 0.69, 2.3),
    _StarSpec(0.9, 0.57, 1.6),
    _StarSpec(0.95, 0.72, 1.9),
    _StarSpec(0.11, 0.84, 1.8),
    _StarSpec(0.22, 0.9, 1.3),
    _StarSpec(0.34, 0.8, 2.1),
    _StarSpec(0.47, 0.88, 1.4),
    _StarSpec(0.62, 0.83, 2.2),
    _StarSpec(0.75, 0.9, 1.6),
    _StarSpec(0.87, 0.82, 1.9),
  ];

  @override
  Widget build(BuildContext context) {
    final starColor = isDark
        ? Colors.white.withValues(alpha: 0.9)
        : const Color(0xFF7A93B0).withValues(alpha: 0.62);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: _stars
              .map(
                (star) => Positioned(
                  left: constraints.maxWidth * star.dx,
                  top: constraints.maxHeight * star.dy,
                  child: Container(
                    width: star.size,
                    height: star.size,
                    decoration: BoxDecoration(
                      color: starColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _StarSpec {
  const _StarSpec(this.dx, this.dy, this.size);

  final double dx;
  final double dy;
  final double size;
}
