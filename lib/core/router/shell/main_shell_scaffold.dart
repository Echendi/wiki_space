import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/space_bottom_nav_bar/space_bottom_nav_bar.dart';

/// Scaffold principal para rutas dentro del `StatefulShellRoute`.
///
/// Centraliza:
/// - Navegacion por tabs (home/profile).
/// - Comportamiento de doble back para salir de la app.
/// - Integracion del `SpaceBottomNavBar`.
class MainShellScaffold extends StatefulWidget {
  const MainShellScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<MainShellScaffold> createState() => _MainShellScaffoldState();
}

class _MainShellScaffoldState extends State<MainShellScaffold> {
  static const Duration _exitGap = Duration(seconds: 2);
  DateTime? _lastBackPressedAt;

  /// Requiere dos pulsaciones de back dentro de [_exitGap] para salir.
  void _handleBackPressed(BuildContext context) {
    final now = DateTime.now();
    final canExit = _lastBackPressedAt != null &&
        now.difference(_lastBackPressedAt!) <= _exitGap;

    if (canExit) {
      SystemNavigator.pop();
      return;
    }

    _lastBackPressedAt = now;

    final message = AppLocalizations.of(context).backPressExitHint;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: _exitGap,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _handleBackPressed(context);
      },
      child: Scaffold(
        extendBody: true,
        body: widget.navigationShell,
        bottomNavigationBar: SpaceBottomNavBar(
          currentIndex: widget.navigationShell.currentIndex,
          onTap: (index) {
            widget.navigationShell.goBranch(
              index,
              initialLocation: index == widget.navigationShell.currentIndex,
            );
          },
          homeLabel: l10n.navHome,
          profileLabel: l10n.navProfile,
        ),
      ),
    );
  }
}
