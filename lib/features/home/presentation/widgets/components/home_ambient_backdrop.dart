import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';

/// Decoracion ambiental suave para la cabecera de Home.
class HomeAmbientBackdrop extends StatelessWidget {
  /// Crea el fondo ambiental para el header de Home.
  const HomeAmbientBackdrop({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  /// Construye una orbita radial usada como brillo decorativo.
  Widget _buildGlowOrb({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withValues(alpha: 0.04),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? AppPalette.secondary : AppPalette.primary;
    final accentAlt = isDark ? AppPalette.primary : AppPalette.accent;

    return Stack(
      children: [
        Positioned(
          top: -22,
          left: -28,
          child: _buildGlowOrb(
            size: 140,
            color: accent.withValues(alpha: isDark ? 0.12 : 0.1),
          ),
        ),
        Positioned(
          top: 64,
          right: -18,
          child: _buildGlowOrb(
            size: 112,
            color: accentAlt.withValues(alpha: isDark ? 0.1 : 0.08),
          ),
        ),
      ],
    );
  }
}
