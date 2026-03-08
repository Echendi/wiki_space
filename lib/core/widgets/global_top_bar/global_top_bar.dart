import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/service_locator.dart';
import '../../settings/cubit/app_settings_cubit.dart';
import '../../services/connectivity_status_service.dart';
import '../../../features/auth/presentation/widgets/space_logo.dart';
import '../../../l10n/generated/app_localizations.dart';

part 'selection_tile.dart';

/// AppBar global reutilizable de la aplicacion.
///
/// Responsabilidades:
/// - Mostrar branding (logo + titulo).
/// - Exponer controles globales de tema e idioma.
/// - Mostrar estado offline en tiempo real.
class GlobalTopBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalTopBar({
    super.key,
    this.showBackButton = false,
    this.onBackPressed,
  });

  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsState = context.watch<AppSettingsCubit>().state;
    final currentThemeMode = settingsState.themeMode;
    final currentLanguageCode = settingsState.locale.languageCode;
    final settingsCubit = context.read<AppSettingsCubit>();
    final connectivityStatusService =
        serviceLocator<ConnectivityStatusService>();
    final appBarForeground = Theme.of(context).appBarTheme.foregroundColor ??
        Theme.of(context).colorScheme.onSurface;

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
        ValueListenableBuilder<bool>(
          valueListenable: connectivityStatusService.isOnline,
          builder: (context, isOnline, _) {
            if (isOnline) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
          tooltip: _themeTooltip(l10n, currentThemeMode),
          onPressed: () {
            final nextMode = _nextThemeMode(currentThemeMode);
            settingsCubit.setThemeMode(nextMode);
          },
          icon: Icon(_themeIcon(currentThemeMode)),
        ),
        Tooltip(
          message: _languageTooltip(l10n, currentLanguageCode),
          child: TextButton.icon(
            onPressed: () => _showLanguagePickerSheet(context),
            icon: Text(
              _languageFlag(currentLanguageCode),
              style: const TextStyle(fontSize: 16),
            ),
            label: Text(
              currentLanguageCode.toUpperCase(),
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

  Future<void> _showLanguagePickerSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final settingsCubit = context.read<AppSettingsCubit>();
    final currentLanguageCode = settingsCubit.state.locale.languageCode;
    final selectedLocale = await showModalBottomSheet<Locale>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  l10n.languageLabel,
                  style: Theme.of(sheetContext)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              _SelectionTile(
                label: '${_languageFlag('es')} ${l10n.spanishOption}',
                selected: currentLanguageCode == 'es',
                onTap: () => Navigator.of(sheetContext).pop(const Locale('es')),
              ),
              _SelectionTile(
                label: '${_languageFlag('en')} ${l10n.englishOption}',
                selected: currentLanguageCode == 'en',
                onTap: () => Navigator.of(sheetContext).pop(const Locale('en')),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (selectedLocale == null ||
        selectedLocale.languageCode == currentLanguageCode) {
      return;
    }

    await settingsCubit.setLocale(selectedLocale);
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

  String _languageFlag(String languageCode) {
    return languageCode == 'es' ? '🇨🇴' : '🇺🇸';
  }

  String _languageTooltip(AppLocalizations l10n, String languageCode) {
    return languageCode == 'es' ? l10n.spanishOption : l10n.englishOption;
  }
}
