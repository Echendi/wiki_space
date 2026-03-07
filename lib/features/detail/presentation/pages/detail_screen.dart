import 'package:flutter/material.dart';

import '../../../../core/widgets/global_top_bar.dart';
import '../../../../l10n/generated/app_localizations.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.articleId,
    required this.locale,
    required this.themeMode,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final String articleId;
  final Locale locale;
  final ThemeMode themeMode;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: GlobalTopBar(
        locale: locale,
        themeMode: themeMode,
        onLocaleChanged: onLocaleChanged,
        onThemeModeChanged: onThemeModeChanged,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.detailTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text('${l10n.articleIdLabel}: $articleId'),
          ],
        ),
      ),
    );
  }
}
