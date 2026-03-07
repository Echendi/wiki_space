import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                l10n.homeSpaceFeedTitle,
                style: AppTextStyles.screenTitle(isDark).copyWith(fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.auto_awesome_rounded,
              color: isDark ? AppPalette.secondary : AppPalette.primary,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          l10n.homeSpaceFeedSubtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMd(isDark).copyWith(fontSize: 13),
        ),
      ],
    );
  }
}
