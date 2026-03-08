import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Tarjeta de texto con el resumen extendido del articulo.
class DetailSummaryCard extends StatelessWidget {
  const DetailSummaryCard({
    super.key,
    required this.summary,
    required this.isDark,
  });

  final String summary;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: (isDark ? AppPalette.surfaceDarkAlt : AppPalette.surfaceLight)
            .withValues(alpha: isDark ? 0.82 : 0.94),
        border: Border.all(
          color: AppPalette.accent.withValues(alpha: 0.24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Text(summary, style: AppTextStyles.bodyMd(isDark)),
      ),
    );
  }
}
