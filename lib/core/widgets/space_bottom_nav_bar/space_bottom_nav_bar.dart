import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_palette.dart';
import '../../theme/app_text_styles.dart';

part 'nav_item.dart';

/// Barra de navegacion inferior con estilo espacial y animaciones.
///
/// Muestra dos destinos principales (Home/Profile) y resalta el seleccionado
/// con un indicador animado.
class SpaceBottomNavBar extends StatelessWidget {
  const SpaceBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.homeLabel,
    required this.profileLabel,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final String homeLabel;
  final String profileLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final indicatorAlign =
        currentIndex == 0 ? const Alignment(-1, 0) : const Alignment(1, 0);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          AppPalette.surfaceDarkAlt.withValues(alpha: 0.62),
                          AppPalette.surfaceDark.withValues(alpha: 0.82),
                        ]
                      : [
                          AppPalette.surfaceLightAlt.withValues(alpha: 0.74),
                          AppPalette.surfaceLight.withValues(alpha: 0.89),
                        ],
                ),
                border: Border.fromBorderSide(
                  BorderSide(
                    color: AppPalette.accent
                        .withValues(alpha: isDark ? 0.18 : 0.12),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.primary
                        .withValues(alpha: isDark ? 0.22 : 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final indicatorWidth = (constraints.maxWidth / 2) - 12;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutQuint,
                        alignment: indicatorAlign,
                        child: Container(
                          width: indicatorWidth,
                          height: 56,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppPalette.primary,
                                AppPalette.secondary
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppPalette.primary.withValues(alpha: 0.32),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _NavItem(
                              icon: Icons.home_rounded,
                              label: homeLabel,
                              selected: currentIndex == 0,
                              onTap: () => onTap(0),
                              isDark: isDark,
                            ),
                          ),
                          Expanded(
                            child: _NavItem(
                              icon: Icons.person_rounded,
                              label: profileLabel,
                              selected: currentIndex == 1,
                              onTap: () => onTap(1),
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
