import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import 'planet_logo_painter.dart';

/// Logo ilustrado de la app para la experiencia de autenticacion.
class SpaceLogo extends StatelessWidget {
  const SpaceLogo({
    super.key,
    this.size = 112,
    this.showWordmark = true,
  });

  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size.square(size),
          painter: PlanetLogoPainter(isDark: isDark),
        ),
        if (showWordmark) ...[
          const SizedBox(height: 10),
          Text(
            'WIKI SPACE',
            style: AppTextStyles.logo(isDark),
          ),
        ],
      ],
    );
  }
}
