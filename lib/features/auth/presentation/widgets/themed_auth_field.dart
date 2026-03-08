import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Campo de formulario de autenticacion con estilo consistente.
class ThemedAuthField extends StatelessWidget {
  const ThemedAuthField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    required this.isCompact,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.onFieldSubmitted,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?) validator;
  final bool isCompact;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: AppTextStyles.inputText(isDark),
      decoration: InputDecoration(
        isDense: isCompact,
        contentPadding: EdgeInsets.symmetric(
          vertical: isCompact ? 12 : 16,
          horizontal: isCompact ? 12 : 14,
        ),
        labelText: label,
        labelStyle: AppTextStyles.inputLabel(isDark),
        prefixIcon: Icon(
          icon,
          color: AppPalette.accent,
          size: isCompact ? 20 : 24,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor:
            (isDark ? AppPalette.surfaceDarkAlt : AppPalette.surfaceLight)
                .withValues(alpha: isDark ? 0.82 : 1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        errorStyle: AppTextStyles.errorStyle(),
      ),
    );
  }
}
