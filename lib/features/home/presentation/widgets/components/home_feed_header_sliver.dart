import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';

/// Encabezado del bloque de feed dentro del `CustomScrollView` de Home.
class HomeFeedHeaderSliver extends StatelessWidget {
  /// Crea un titulo de seccion en formato sliver.
  const HomeFeedHeaderSliver({
    super.key,
    required this.isDark,
    required this.title,
  });

  final bool isDark;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppPalette.onDark : AppPalette.onPrimary;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: isDark ? AppPalette.secondary : AppPalette.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
