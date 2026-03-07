import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_palette.dart';

class AppTextStyles {
  static TextTheme baseTextTheme(TextTheme textTheme) {
    return GoogleFonts.spaceGroteskTextTheme(textTheme);
  }

  static TextStyle logo(bool isDark) {
    return GoogleFonts.orbitron(
      color: isDark ? AppPalette.star : AppPalette.onPrimary,
      letterSpacing: 2.2,
      fontWeight: FontWeight.w700,
      fontSize: 18,
    );
  }

  static TextStyle screenTitle(bool isDark) {
    return GoogleFonts.orbitron(
      color: isDark ? AppPalette.onDark : AppPalette.onPrimary,
      fontSize: 24,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle subtitle(bool isDark) {
    return GoogleFonts.spaceGrotesk(
      color: isDark
          ? AppPalette.onDarkMuted
          : AppPalette.onPrimary.withValues(alpha: 0.78),
      fontSize: 16,
    );
  }

  static TextStyle bodyMd(bool isDark) {
    return GoogleFonts.spaceGrotesk(
      color: isDark
          ? AppPalette.onDarkMuted
          : AppPalette.onPrimary.withValues(alpha: 0.75),
      height: 1.25,
    );
  }

  static TextStyle caption(bool isDark) {
    return GoogleFonts.spaceGrotesk(
      color: isDark
          ? AppPalette.onDarkSubtle
          : AppPalette.onPrimary.withValues(alpha: 0.65),
      fontSize: 12.5,
    );
  }

  static TextStyle overline(bool isDark) {
    return GoogleFonts.spaceGrotesk(
      color: isDark
          ? AppPalette.onDarkSubtle
          : AppPalette.onPrimary.withValues(alpha: 0.62),
      fontSize: 12,
    );
  }

  static TextStyle buttonLabel(bool isDark) {
    return GoogleFonts.spaceGrotesk(
      color: isDark ? AppPalette.onDark : AppPalette.onPrimary,
      fontWeight: FontWeight.w700,
      fontSize: 15,
    );
  }

  static TextStyle socialBadgeGlyph(Color color) {
    return GoogleFonts.orbitron(
      color: color,
      fontWeight: FontWeight.w700,
      fontSize: 14,
    );
  }

  static TextStyle primaryCta() {
    return GoogleFonts.spaceGrotesk(
      fontWeight: FontWeight.w700,
      fontSize: 16,
    );
  }

  static TextStyle inputText(bool isDark) {
    return GoogleFonts.spaceGrotesk(
      color: isDark ? AppPalette.onDark : AppPalette.onPrimary,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle inputLabel(bool isDark) {
    return GoogleFonts.spaceGrotesk(
      color: isDark
          ? AppPalette.onDarkMuted
          : AppPalette.onPrimary.withValues(alpha: 0.72),
    );
  }

  static TextStyle errorStyle() {
    return GoogleFonts.spaceGrotesk();
  }
}
