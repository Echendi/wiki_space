import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// Vista de error con accion de reintento para Home.
class HomeErrorView extends StatelessWidget {
  const HomeErrorView({
    super.key,
    required this.isDark,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final bool isDark;
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.travel_explore_rounded,
            size: 40,
            color: isDark ? AppPalette.onDarkMuted : AppPalette.onPrimary,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd(isDark),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: onRetry,
            child: Text(retryLabel),
          ),
        ],
      ),
    );
  }
}
