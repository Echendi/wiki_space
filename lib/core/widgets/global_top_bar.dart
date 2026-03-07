import 'package:flutter/material.dart';

import '../../features/auth/presentation/widgets/space_logo.dart';
import '../../l10n/generated/app_localizations.dart';

class GlobalTopBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalTopBar({
    super.key,
    required this.locale,
    required this.themeMode,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
    this.showBackButton = false,
    this.onBackPressed,
  });

  final Locale locale;
  final ThemeMode themeMode;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final effectiveLocale = Localizations.localeOf(context);
    final currentThemeMode = Theme.of(context).brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;

    return AppBar(
      leading: showBackButton
          ? IconButton(
              onPressed:
                  onBackPressed ?? () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded),
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SpaceLogo(size: 20, showWordmark: false),
          const SizedBox(width: 8),
          Flexible(child: Text(l10n.appTitle)),
        ],
      ),
      actions: [
        IconButton(
          tooltip: _themeTooltip(l10n, currentThemeMode),
          onPressed: () {
            final nextMode = currentThemeMode == ThemeMode.dark
                ? ThemeMode.light
                : ThemeMode.dark;
            onThemeModeChanged(nextMode);
          },
          icon: Icon(
            currentThemeMode == ThemeMode.dark
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
          ),
        ),
        PopupMenuButton<Locale>(
          tooltip: l10n.languageLabel,
          initialValue: effectiveLocale,
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
                Text(effectiveLocale.languageCode.toUpperCase()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _themeTooltip(AppLocalizations l10n, ThemeMode currentThemeMode) {
    return currentThemeMode == ThemeMode.dark
        ? l10n.themeDarkLabel
        : l10n.themeLightLabel;
  }
}
