import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/password_rule.dart';

/// Checklist visual para mostrar reglas de contrasena en vivo.
class PasswordChecks extends StatelessWidget {
  const PasswordChecks({
    super.key,
    required this.controller,
    required this.isDark,
    required this.rulesBuilder,
  });

  final TextEditingController controller;
  final bool isDark;
  final List<PasswordRule> Function(String password) rulesBuilder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final rules = rulesBuilder(value.text);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final rule in rules)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      rule.passed
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 16,
                      color: rule.passed
                          ? Colors.green
                          : (isDark
                              ? AppPalette.onDarkMuted
                              : AppPalette.onPrimary.withValues(alpha: 0.6)),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        rule.label,
                        style: AppTextStyles.caption(isDark),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
