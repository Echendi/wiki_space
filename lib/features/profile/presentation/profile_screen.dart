import 'package:flutter/material.dart';

import '../../../core/widgets/global_top_bar.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/data/auth_service.dart';

class ProfileScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = authService.currentUser;

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
              l10n.profileTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
                '${l10n.profileEmailLabel}: ${user?.email ?? l10n.genericUser}'),
            const SizedBox(height: 8),
            Text('${l10n.profileUidLabel}: ${user?.uid ?? '-'}'),
          ],
        ),
      ),
    );
  }
}
