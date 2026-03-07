import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/widgets/space_logo.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.isDark,
    required this.onSignOut,
  });

  final bool isDark;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SpaceLogo(size: 72),
            FilledButton.tonalIcon(
              onPressed: onSignOut,
              style: FilledButton.styleFrom(
                backgroundColor: isDark
                    ? AppPalette.surfaceDarkAlt
                    : AppPalette.surfaceLightAlt,
                foregroundColor:
                    isDark ? AppPalette.onDark : AppPalette.onPrimary,
              ),
              icon: const Icon(Icons.logout_rounded),
              label: Text(l10n.signOutButton),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          l10n.homeSpaceFeedTitle,
          style: AppTextStyles.screenTitle(isDark).copyWith(fontSize: 22),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.homeSpaceFeedSubtitle,
          style: AppTextStyles.bodyMd(isDark),
        ),
      ],
    );
  }
}
