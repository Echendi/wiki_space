import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';

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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected
              ? Colors.transparent
              : (isDark ? AppPalette.surfaceDark : AppPalette.surfaceLight)
                  .withValues(alpha: 0.28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutBack,
              scale: selected ? 1.08 : 1,
              child: Icon(
                icon,
                color: selected
                    ? AppPalette.onPrimary
                    : (isDark ? AppPalette.onDarkMuted : AppPalette.onPrimary),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.buttonLabel(isDark).copyWith(
                  color: selected
                      ? AppPalette.onPrimary
                      : (isDark
                          ? AppPalette.onDarkMuted
                          : AppPalette.onPrimary),
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: selected ? 0.2 : 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
