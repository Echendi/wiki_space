import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Boton de proveedor social con icono cuadrado y tooltip accesible.
class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    super.key,
    required this.semanticLabel,
    required this.iconAssetPath,
    required this.onPressed,
  });

  final String semanticLabel;
  final String iconAssetPath;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: semanticLabel,
      child: SizedBox(
        height: 48,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: AppPalette.accent.withValues(alpha: 0.35),
            ),
            backgroundColor: (isDark
                    ? AppPalette.surfaceDarkAlt
                    : AppPalette.surfaceLightAlt)
                .withValues(alpha: isDark ? 0.72 : 0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                iconAssetPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
