import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Tarjeta de metrica simple para datos de articulo.
class DetailMetricCard extends StatelessWidget {
  const DetailMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.sizeOf(context).width - 52) / 2;

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: (isDark ? AppPalette.surfaceDark : AppPalette.surfaceLight)
              .withValues(alpha: isDark ? 0.82 : 0.94),
          border: Border.all(
            color: AppPalette.accent.withValues(alpha: 0.22),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: AppPalette.star),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption(isDark),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMd(isDark).copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppPalette.onDark : AppPalette.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
