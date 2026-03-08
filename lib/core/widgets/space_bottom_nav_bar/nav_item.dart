part of 'space_bottom_nav_bar.dart';

/// Item individual de la barra inferior.
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
