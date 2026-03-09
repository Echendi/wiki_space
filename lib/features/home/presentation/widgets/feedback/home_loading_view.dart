import 'package:flutter/material.dart';

import '../../../../../core/theme/app_text_styles.dart';

/// Vista de carga principal para estados iniciales de Home.
class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({
    super.key,
    required this.isDark,
    required this.label,
  });

  final bool isDark;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(label, style: AppTextStyles.bodyMd(isDark)),
        ],
      ),
    );
  }
}
