import 'package:flutter/material.dart';

import 'app_palette.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData light() {
    return _build(Brightness.light);
  }

  static ThemeData dark() {
    return _build(Brightness.dark);
  }

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppPalette.primary,
      brightness: brightness,
      primary: AppPalette.primary,
      secondary: AppPalette.secondary,
      error: AppPalette.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDark ? AppPalette.backgroundDark : AppPalette.backgroundLight,
      textTheme: AppTextStyles.baseTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor:
            isDark ? AppPalette.appBarDark : AppPalette.appBarLight,
        foregroundColor: isDark ? AppPalette.onDark : AppPalette.onPrimary,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppPalette.surfaceDarkAlt.withValues(alpha: 0.82)
            : AppPalette.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
