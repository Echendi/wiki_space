import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/widgets/space_logo.dart';

/// Placeholder visual cuando no existe imagen valida del articulo.
class DetailImageFallback extends StatelessWidget {
  const DetailImageFallback({
    super.key,
    required this.isDark,
    required this.label,
  });

  final bool isDark;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? AppPalette.surfaceDarkAlt : AppPalette.surfaceLightAlt,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SpaceLogo(size: 64, showWordmark: false),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.caption(isDark)),
        ],
      ),
    );
  }
}
