import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Contenedor con transicion para cambios de rama en `StatefulNavigationShell`.
///
/// Anima la pantalla activa con fade + slide para suavizar el cambio entre tabs.
class AnimatedBranchContainer extends StatelessWidget {
  const AnimatedBranchContainer({
    super.key,
    required this.navigationShell,
    required this.children,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final activeChild = KeyedSubtree(
      key: ValueKey<int>(navigationShell.currentIndex),
      child: children[navigationShell.currentIndex],
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.03, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
      child: activeChild,
    );
  }
}
