import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

class GlobalTopBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalTopBar({
    super.key,
    required this.locale,
    required this.themeMode,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final Locale locale;
  final ThemeMode themeMode;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppBar(
      title: Text(l10n.appTitle),
      actions: [
        IconButton(
          tooltip: _themeTooltip(l10n),
          onPressed: () {
            final nextMode =
                themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            onThemeModeChanged(nextMode);
          },
          icon: Icon(
            themeMode == ThemeMode.dark
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
          ),
        ),
        PopupMenuButton<Locale>(
          tooltip: l10n.languageLabel,
          initialValue: locale,
          onSelected: onLocaleChanged,
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: const Locale('es'),
                child: Text(l10n.spanishOption),
              ),
              PopupMenuItem(
                value: const Locale('en'),
                child: Text(l10n.englishOption),
              ),
            ];
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.language_rounded),
                const SizedBox(width: 6),
                Text(locale.languageCode.toUpperCase()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _themeTooltip(AppLocalizations l10n) {
    return themeMode == ThemeMode.dark
        ? l10n.themeDarkLabel
        : l10n.themeLightLabel;
  }
}
