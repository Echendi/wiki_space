import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/global_top_bar.dart';
import '../../../../core/widgets/space_scene_background.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/domain/usecases/auth_use_cases.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.authUseCases,
    required this.locale,
    required this.themeMode,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final AuthUseCases authUseCases;
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

  String? _formatLastConnection(BuildContext context, DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }

    final local = dateTime.toLocal();
    final material = MaterialLocalizations.of(context);
    final dateText = material.formatShortDate(local);
    final timeText = material.formatTimeOfDay(
      TimeOfDay.fromDateTime(local),
    );
    return '$dateText $timeText';
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
    final user = widget.authUseCases.getCurrentUser();
    final providerIds = user?.providerIds.toSet().toList() ?? const <String>[];

    return Scaffold(
      appBar: GlobalTopBar(
        locale: widget.locale,
        themeMode: _selectedThemeMode,
        onLocaleChanged: widget.onLocaleChanged,
        onThemeModeChanged: _handleThemeModeChanged,
      ),
      body: SpaceSceneBackground(
        isDark: isDark,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            20 +
                MediaQuery.of(context).padding.bottom +
                kBottomNavigationBarHeight,
          ),
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
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<ThemeMode>(
                        expandedInsets: EdgeInsets.zero,
                        showSelectedIcon: false,
                        segments: [
                          ButtonSegment(
                            value: ThemeMode.system,
                            label: _ThemeSegmentLabel(
                              icon: Icons.brightness_auto_rounded,
                              text: l10n.themeSystemLabel,
                              selected: _selectedThemeMode == ThemeMode.system,
                            ),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            label: _ThemeSegmentLabel(
                              icon: Icons.light_mode_rounded,
                              text: l10n.themeLightLabel,
                              selected: _selectedThemeMode == ThemeMode.light,
                            ),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            label: _ThemeSegmentLabel(
                              icon: Icons.dark_mode_rounded,
                              text: l10n.themeDarkLabel,
                              selected: _selectedThemeMode == ThemeMode.dark,
                            ),
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
                      label: l10n.profileLastConnectionLabel,
                      value: _formatLastConnection(
                        context,
                        user?.lastSignInAt,
                      ),
                      fallback: l10n.profileNotAvailable,
                      labelColor: secondaryTextColor,
                      valueColor: primaryTextColor,
                    ),
                    _InfoRow(
                      label: l10n.profileUidLabel,
                      value: user?.id,
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
                    const SizedBox(height: 5),
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
              onPressed: () => _confirmAndSignOut(context),
              icon: const Icon(Icons.logout_rounded),
              label: Text(l10n.signOutButton),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAndSignOut(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final dialogTheme = Theme.of(dialogContext);
        final colorScheme = dialogTheme.colorScheme;

        return AlertDialog(
          title: Text(
            l10n.signOutConfirmTitle,
            style: dialogTheme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            l10n.signOutConfirmMessage,
            style: dialogTheme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancelAction),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.signOutButton),
            ),
          ],
        );
      },
    );

    if (shouldSignOut != true) {
      return;
    }

    await widget.authUseCases.signOut();
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(l10n.signOutSuccess)),
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

class _ThemeSegmentLabel extends StatelessWidget {
  const _ThemeSegmentLabel({
    required this.icon,
    required this.text,
    required this.selected,
  });

  final IconData icon;
  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(selected ? Icons.check_rounded : icon, size: 18),
        const SizedBox(height: 4),
        Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }
}
