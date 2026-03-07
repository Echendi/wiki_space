import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/global_top_bar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/data/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
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

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Future<PackageInfo> _packageInfoFuture;
  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfo.fromPlatform();
    _selectedThemeMode = widget.themeMode;
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.themeMode != widget.themeMode &&
        widget.themeMode != _selectedThemeMode) {
      _selectedThemeMode = widget.themeMode;
    }
  }

  void _handleThemeModeChanged(ThemeMode selectedMode) {
    if (selectedMode == _selectedThemeMode) {
      return;
    }

    setState(() {
      _selectedThemeMode = selectedMode;
    });
    widget.onThemeModeChanged(selectedMode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final primaryTextColor = colorScheme.onSurface;
    final secondaryTextColor = colorScheme.onSurfaceVariant;
    final cardColor = isDark
      ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.9)
      : colorScheme.surface;
    final cardBorderColor = isDark
      ? AppPalette.borderMuted.withValues(alpha: 0.6)
      : AppPalette.borderMuted.withValues(alpha: 0.32);
    final user = widget.authService.currentUser;
    final providerIds = user?.providerData
            .map((provider) => provider.providerId)
            .where((id) => id.trim().isNotEmpty)
            .toSet()
            .toList() ??
        const <String>[];

    return Scaffold(
      appBar: GlobalTopBar(
        locale: widget.locale,
        themeMode: _selectedThemeMode,
        onLocaleChanged: widget.onLocaleChanged,
        onThemeModeChanged: _handleThemeModeChanged,
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
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              l10n.profileTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: primaryTextColor,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              color: cardColor,
              surfaceTintColor: Colors.transparent,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: cardBorderColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.themeLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: primaryTextColor,
                          ),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<ThemeMode>(
                      segments: [
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text(l10n.themeSystemLabel),
                          icon: const Icon(Icons.brightness_auto_rounded),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text(l10n.themeLightLabel),
                          icon: const Icon(Icons.light_mode_rounded),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text(l10n.themeDarkLabel),
                          icon: const Icon(Icons.dark_mode_rounded),
                        ),
                      ],
                      selected: {_selectedThemeMode},
                      onSelectionChanged: (selection) {
                        final selectedMode =
                            selection.isEmpty ? null : selection.first;
                        if (selectedMode != null) {
                          _handleThemeModeChanged(selectedMode);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: cardColor,
              surfaceTintColor: Colors.transparent,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: cardBorderColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.profileTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: primaryTextColor,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      label: l10n.profileDisplayNameLabel,
                      value: user?.displayName,
                      fallback: l10n.profileNotAvailable,
                      labelColor: secondaryTextColor,
                      valueColor: primaryTextColor,
                    ),
                    _InfoRow(
                      label: l10n.profileEmailLabel,
                      value: user?.email,
                      fallback: l10n.profileNotAvailable,
                      labelColor: secondaryTextColor,
                      valueColor: primaryTextColor,
                    ),
                    _InfoRow(
                      label: l10n.profilePhoneLabel,
                      value: user?.phoneNumber,
                      fallback: l10n.profileNotAvailable,
                      labelColor: secondaryTextColor,
                      valueColor: primaryTextColor,
                    ),
                    _InfoRow(
                      label: l10n.profileUidLabel,
                      value: user?.uid,
                      fallback: l10n.profileNotAvailable,
                      labelColor: secondaryTextColor,
                      valueColor: primaryTextColor,
                    ),
                    _InfoRow(
                      label: l10n.profileProvidersLabel,
                      value:
                          providerIds.isEmpty ? null : providerIds.join(', '),
                      fallback: l10n.profileNotAvailable,
                      labelColor: secondaryTextColor,
                      valueColor: primaryTextColor,
                    ),
                    _InfoRow(
                      label: l10n.profileEmailVerifiedLabel,
                      value: user == null
                          ? null
                          : (user.emailVerified
                                ? l10n.profileYesValue
                                : l10n.profileNoValue),
                      fallback: l10n.profileNotAvailable,
                      labelColor: secondaryTextColor,
                      valueColor: primaryTextColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: cardColor,
              surfaceTintColor: Colors.transparent,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: cardBorderColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.profileVersionLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: primaryTextColor,
                          ),
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<PackageInfo>(
                      future: _packageInfoFuture,
                      builder: (context, snapshot) {
                        final info = snapshot.data;
                        final versionText = info == null
                            ? l10n.profileNotAvailable
                            : '${info.version} (${info.buildNumber})';

                        return _InfoRow(
                          label: l10n.profileVersionLabel,
                          value: versionText,
                          fallback: l10n.profileNotAvailable,
                          labelColor: secondaryTextColor,
                          valueColor: primaryTextColor,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.tonalIcon(
              onPressed: () async {
                await widget.authService.signOut();
                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(l10n.signOutSuccess)),
                  );
              },
              icon: const Icon(Icons.logout_rounded),
              label: Text(l10n.signOutButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.fallback,
    required this.labelColor,
    required this.valueColor,
  });

  final String label;
  final String? value;
  final String fallback;
  final Color labelColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final displayValue =
        (value == null || value!.trim().isEmpty) ? fallback : value!.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            TextSpan(
              text: displayValue,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: valueColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
