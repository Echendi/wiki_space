import 'package:flutter/material.dart';

import '../di/service_locator.dart';
import '../services/connectivity_status_service.dart';
import '../../features/auth/presentation/widgets/space_logo.dart';
import '../../l10n/generated/app_localizations.dart';

class GlobalTopBar extends StatefulWidget implements PreferredSizeWidget {
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
  State<GlobalTopBar> createState() => _GlobalTopBarState();
}

class _GlobalTopBarState extends State<GlobalTopBar> {
  late ThemeMode _currentThemeMode;
  late String _currentLanguageCode;
  late final ConnectivityStatusService _connectivityStatusService;

  @override
  void initState() {
    super.initState();
    _currentThemeMode = widget.themeMode;
    _currentLanguageCode = widget.locale.languageCode;
    _connectivityStatusService = serviceLocator<ConnectivityStatusService>();
  }

  @override
  void didUpdateWidget(covariant GlobalTopBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.themeMode != widget.themeMode &&
        widget.themeMode != _currentThemeMode) {
      _currentThemeMode = widget.themeMode;
    }

    if (oldWidget.locale.languageCode != widget.locale.languageCode &&
        widget.locale.languageCode != _currentLanguageCode) {
      _currentLanguageCode = widget.locale.languageCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appBarForeground = Theme.of(context).appBarTheme.foregroundColor ??
        Theme.of(context).colorScheme.onSurface;
    final effectiveLocale = Localizations.localeOf(context);
    if (_currentLanguageCode != effectiveLocale.languageCode) {
      _currentLanguageCode = effectiveLocale.languageCode;
    }

    return AppBar(
      leading: widget.showBackButton
          ? IconButton(
              onPressed: widget.onBackPressed ??
                  () => Navigator.of(context).maybePop(),
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
        ValueListenableBuilder<bool>(
          valueListenable: _connectivityStatusService.isOnline,
          builder: (context, isOnline, _) {
            if (isOnline) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      l10n.offlineStatusLabel,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        IconButton(
          tooltip: _themeTooltip(l10n, _currentThemeMode),
          onPressed: () {
            final nextMode = _nextThemeMode(_currentThemeMode);
            setState(() {
              _currentThemeMode = nextMode;
            });
            widget.onThemeModeChanged(nextMode);
          },
          icon: Icon(_themeIcon(_currentThemeMode)),
        ),
        Tooltip(
          message: _languageTooltip(l10n, _currentLanguageCode),
          child: TextButton.icon(
            onPressed: () {
              final nextLocale = _nextLocale(_currentLanguageCode);
              setState(() {
                _currentLanguageCode = nextLocale.languageCode;
              });
              widget.onLocaleChanged(nextLocale);
            },
            icon: Text(
              _languageFlag(_currentLanguageCode),
              style: const TextStyle(fontSize: 16),
            ),
            label: Text(
              _currentLanguageCode.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: appBarForeground,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: appBarForeground,
              minimumSize: const Size(0, 40),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  ThemeMode _nextThemeMode(ThemeMode currentThemeMode) {
    return switch (currentThemeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
  }

  IconData _themeIcon(ThemeMode currentThemeMode) {
    return switch (currentThemeMode) {
      ThemeMode.system => Icons.brightness_auto_rounded,
      ThemeMode.light => Icons.light_mode_rounded,
      ThemeMode.dark => Icons.dark_mode_rounded,
    };
  }

  String _themeTooltip(AppLocalizations l10n, ThemeMode currentThemeMode) {
    return switch (currentThemeMode) {
      ThemeMode.system => l10n.themeSystemLabel,
      ThemeMode.light => l10n.themeLightLabel,
      ThemeMode.dark => l10n.themeDarkLabel,
    };
  }

  Locale _nextLocale(String currentLanguageCode) {
    return currentLanguageCode == 'es'
        ? const Locale('en')
        : const Locale('es');
  }

  String _languageFlag(String languageCode) {
    return languageCode == 'es' ? '🇨🇴' : '🇺🇸';
  }

  String _languageTooltip(AppLocalizations l10n, String languageCode) {
    return languageCode == 'es' ? l10n.spanishOption : l10n.englishOption;
  }
}
