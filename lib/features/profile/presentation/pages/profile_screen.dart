import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/global_top_bar/global_top_bar.dart';
import '../../../../core/widgets/space_scene_background/space_scene_background.dart';
import '../../../../core/settings/cubit/app_settings_cubit.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/cubit/auth_session_cubit.dart';
import '../widgets/widgets.dart';

/// Pantalla de perfil con configuracion de tema y datos de sesion.
class ProfileScreen extends StatefulWidget {
  /// Crea la pantalla principal de perfil.
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

/// Estado interno de [ProfileScreen].
class _ProfileScreenState extends State<ProfileScreen> {
  late final Future<PackageInfo> _packageInfoFuture;
  late ThemeMode _selectedThemeMode;

  /// Inicializa carga de metadatos de la app y tema inicial.
  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfo.fromPlatform();
    _selectedThemeMode = ThemeMode.system;
  }

  /// Persiste el modo de tema seleccionado por el usuario.
  Future<void> _handleThemeModeChanged(
    BuildContext context,
    ThemeMode selectedMode,
  ) async {
    if (selectedMode == _selectedThemeMode) {
      return;
    }

    setState(() {
      _selectedThemeMode = selectedMode;
    });
    await context.read<AppSettingsCubit>().setThemeMode(selectedMode);
  }

  /// Formatea fecha/hora de ultimo acceso segun localizacion actual.
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

  /// Construye la UI de perfil y secciones de configuracion.
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
    final user = context.watch<AuthSessionCubit>().state.user;
    final providerIds = user?.providerIds.toSet().toList() ?? const <String>[];
    final appThemeMode = context.watch<AppSettingsCubit>().state.themeMode;
    if (_selectedThemeMode != appThemeMode) {
      _selectedThemeMode = appThemeMode;
    }

    return Scaffold(
      appBar: const GlobalTopBar(),
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
                            label: ProfileThemeSegmentLabel(
                              icon: Icons.brightness_auto_rounded,
                              text: l10n.themeSystemLabel,
                              selected: _selectedThemeMode == ThemeMode.system,
                            ),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            label: ProfileThemeSegmentLabel(
                              icon: Icons.light_mode_rounded,
                              text: l10n.themeLightLabel,
                              selected: _selectedThemeMode == ThemeMode.light,
                            ),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            label: ProfileThemeSegmentLabel(
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
                            _handleThemeModeChanged(context, selectedMode);
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
                    ProfileInfoRow(
                      label: l10n.profileDisplayNameLabel,
                      value: user?.displayName,
                      fallback: l10n.profileNotAvailable,
                      labelColor: secondaryTextColor,
                      valueColor: primaryTextColor,
                    ),
                    ProfileInfoRow(
                      label: l10n.profileEmailLabel,
                      value: user?.email,
                      fallback: l10n.profileNotAvailable,
                      labelColor: secondaryTextColor,
                      valueColor: primaryTextColor,
                    ),
                    ProfileInfoRow(
                      label: l10n.profileLastConnectionLabel,
                      value: _formatLastConnection(
                        context,
                        user?.lastSignInAt,
                      ),
                      fallback: l10n.profileNotAvailable,
                      labelColor: secondaryTextColor,
                      valueColor: primaryTextColor,
                    ),
                    ProfileInfoRow(
                      label: l10n.profileUidLabel,
                      value: user?.id,
                      fallback: l10n.profileNotAvailable,
                      labelColor: secondaryTextColor,
                      valueColor: primaryTextColor,
                    ),
                    ProfileInfoRow(
                      label: l10n.profileProvidersLabel,
                      value:
                          providerIds.isEmpty ? null : providerIds.join(', '),
                      fallback: l10n.profileNotAvailable,
                      labelColor: secondaryTextColor,
                      valueColor: primaryTextColor,
                    ),
                    ProfileInfoRow(
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

                        return ProfileInfoRow(
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

  /// Muestra dialogo de confirmacion y ejecuta cierre de sesion.
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

    if (!context.mounted) {
      return;
    }

    await context.read<AuthSessionCubit>().signOut();
    if (!context.mounted) {
      return;
    }

    final successL10n = AppLocalizations.of(context);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(successL10n.signOutSuccess)),
      );
  }
}
