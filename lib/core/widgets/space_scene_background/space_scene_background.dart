import 'package:flutter/material.dart';

import '../../theme/app_palette.dart';

part 'space_scene_decor_parts.dart';

/// Fondo visual reutilizable con ambientacion espacial.
///
/// Dibuja un gradiente base y una capa decorativa (glows, planetas y estrellas)
/// por detras del contenido principal.
class SpaceSceneBackground extends StatelessWidget {
  const SpaceSceneBackground({
    super.key,
    required this.isDark,
    required this.child,
  });

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final gradientColors =
        isDark ? AppPalette.homeDarkGradient : AppPalette.homeLightGradient;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(
            child: _SpaceDecorLayer(isDark: isDark),
          ),
          child,
        ],
      ),
    );
  }
}
