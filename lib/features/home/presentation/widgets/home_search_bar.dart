import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/generated/app_localizations.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onSearchTap,
    required this.isDark,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSearchTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textColor = isDark ? AppPalette.onDark : AppPalette.onPrimary;
    final hintColor = textColor.withValues(alpha: isDark ? 0.72 : 0.6);
    final iconColor = textColor.withValues(alpha: isDark ? 0.9 : 0.75);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: (isDark ? AppPalette.surfaceDarkAlt : AppPalette.surfaceLight)
            .withValues(alpha: isDark ? 0.74 : 0.9),
        border: Border.all(
          color: AppPalette.accent.withValues(alpha: 0.24),
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: isDark ? AppPalette.star : AppPalette.primary,
        decoration: InputDecoration(
          hintText: l10n.homeSearchHint,
          hintStyle: TextStyle(color: hintColor),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: iconColor,
          ),
          suffixIcon: IconButton(
            tooltip: l10n.homeSearchAction,
            onPressed: onSearchTap,
            icon: Icon(
              Icons.arrow_forward_rounded,
              color: iconColor,
            ),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}
