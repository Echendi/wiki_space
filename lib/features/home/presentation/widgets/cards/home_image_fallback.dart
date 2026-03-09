import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../auth/presentation/widgets/space_logo.dart';

/// Placeholder visual para tarjetas sin imagen valida.
class HomeImageFallback extends StatelessWidget {
  const HomeImageFallback({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppPalette.surfaceDarkAlt : AppPalette.surfaceLightAlt,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SpaceLogo(size: 54, showWordmark: false),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.caption(isDark)),
        ],
      ),
    );
  }
}
