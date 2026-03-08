import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import 'space_logo.dart';

/// Cabecera estandar para formularios de login y registro.
class AuthFormHeader extends StatelessWidget {
  const AuthFormHeader({
    super.key,
    required this.title,
    required this.isDark,
    this.subtitle,
    this.compact = false,
  });

  final String title;
  final String? subtitle;
  final bool isDark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SpaceLogo(),
        SizedBox(height: compact ? 10 : 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.screenTitle(isDark),
        ),
        if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
          SizedBox(height: compact ? 6 : 8),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle(isDark).copyWith(fontSize: 15),
          ),
        ],
      ],
    );
  }
}
