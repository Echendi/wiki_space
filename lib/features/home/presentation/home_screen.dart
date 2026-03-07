import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/global_top_bar.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/data/auth_service.dart';
import '../../auth/presentation/widgets/space_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.authService,
    required this.locale,
    required this.themeMode,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final AuthService authService;
  final Locale locale;
  final ThemeMode themeMode;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  Future<void> _signOut(BuildContext context, AppLocalizations l10n) async {
    await authService.signOut();
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.signOutSuccess)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final email = authService.currentUser?.email ?? l10n.genericUser;

    return Scaffold(
      appBar: GlobalTopBar(
        locale: locale,
        themeMode: themeMode,
        onLocaleChanged: onLocaleChanged,
        onThemeModeChanged: onThemeModeChanged,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? AppPalette.homeDarkGradient
                : AppPalette.homeLightGradient,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SpaceLogo(size: 80),
                    FilledButton.tonalIcon(
                      onPressed: () => _signOut(context, l10n),
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
                const SizedBox(height: 24),
                Text(
                  l10n.homeWelcome(email),
                  style: AppTextStyles.screenTitle(isDark),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.homeSubtitle,
                  style: AppTextStyles.subtitle(isDark),
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: GridView.count(
                    crossAxisCount:
                        MediaQuery.sizeOf(context).width > 780 ? 3 : 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    children: const [
                      _InfoCard(
                        titleKey: _InfoCardKey.navigationTitle,
                        bodyKey: _InfoCardKey.navigationBody,
                        icon: Icons.rocket_launch_rounded,
                      ),
                      _InfoCard(
                        titleKey: _InfoCardKey.securityTitle,
                        bodyKey: _InfoCardKey.securityBody,
                        icon: Icons.shield_moon_rounded,
                      ),
                      _InfoCard(
                        titleKey: _InfoCardKey.sessionTitle,
                        bodyKey: _InfoCardKey.sessionBody,
                        icon: Icons.lock_clock_rounded,
                      ),
                      _InfoCard(
                        titleKey: _InfoCardKey.statusTitle,
                        bodyKey: _InfoCardKey.statusBody,
                        icon: Icons.hub_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.titleKey,
    required this.bodyKey,
    required this.icon,
  });

  final _InfoCardKey titleKey;
  final _InfoCardKey bodyKey;
  final IconData icon;

  String _resolveKey(AppLocalizations l10n, _InfoCardKey key) {
    return switch (key) {
      _InfoCardKey.navigationTitle => l10n.cardNavigationTitle,
      _InfoCardKey.navigationBody => l10n.cardNavigationBody,
      _InfoCardKey.securityTitle => l10n.cardSecurityTitle,
      _InfoCardKey.securityBody => l10n.cardSecurityBody,
      _InfoCardKey.sessionTitle => l10n.cardSessionTitle,
      _InfoCardKey.sessionBody => l10n.cardSessionBody,
      _InfoCardKey.statusTitle => l10n.cardStatusTitle,
      _InfoCardKey.statusBody => l10n.cardStatusBody,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: (isDark ? AppPalette.surfaceLight : AppPalette.surfaceLightAlt)
            .withValues(alpha: isDark ? 0.10 : 0.62),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppPalette.accent.withValues(alpha: isDark ? 0.35 : 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppPalette.primary, size: 28),
            const SizedBox(height: 10),
            Text(
              _resolveKey(l10n, titleKey),
              style: AppTextStyles.screenTitle(isDark).copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              _resolveKey(l10n, bodyKey),
              style: AppTextStyles.bodyMd(isDark),
            ),
          ],
        ),
      ),
    );
  }
}

enum _InfoCardKey {
  navigationTitle,
  navigationBody,
  securityTitle,
  securityBody,
  sessionTitle,
  sessionBody,
  statusTitle,
  statusBody,
}
