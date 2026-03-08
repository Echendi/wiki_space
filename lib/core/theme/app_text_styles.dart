import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_palette.dart';

/// Catalogo de estilos tipograficos reutilizables.
///
/// Centraliza fuentes, pesos y colores para evitar duplicacion en widgets
/// y conservar consistencia de branding.
class AppTextStyles {
  /// Aplica la tipografia base global del tema.
  static TextTheme baseTextTheme(TextTheme textTheme) {
    return GoogleFonts.spaceGroteskTextTheme(textTheme);
  }

  /// Estilo del logo/wordmark.
  static TextStyle logo(bool isDark) {
    return GoogleFonts.orbitron(
      color: isDark ? AppPalette.star : AppPalette.onPrimary,
      letterSpacing: 2.2,
      fontWeight: FontWeight.w700,
      fontSize: 18,
    );
  }

  /// Titulo principal de pantalla.
  static TextStyle screenTitle(bool isDark) {
    return GoogleFonts.orbitron(
      color: isDark ? AppPalette.onDark : AppPalette.onPrimary,
      fontSize: 24,
      fontWeight: FontWeight.w700,
    );
  }

  /// Subtitulos y texto de apoyo destacado.
  static TextStyle subtitle(bool isDark) {
    return GoogleFonts.spaceGrotesk(
      color: isDark
          ? AppPalette.onDarkMuted
          : AppPalette.onPrimary.withValues(alpha: 0.78),
      fontSize: 16,
    );
  }

  /// Texto base para cuerpo de contenido.
  static TextStyle bodyMd(bool isDark) {
    return GoogleFonts.spaceGrotesk(
      color: isDark
          ? AppPalette.onDarkMuted
          : AppPalette.onPrimary.withValues(alpha: 0.75),
      height: 1.25,
    );
  }

  /// Texto secundario pequeno para anotaciones.
  static TextStyle caption(bool isDark) {
    return GoogleFonts.spaceGrotesk(
      color: isDark
          ? AppPalette.onDarkSubtle
          : AppPalette.onPrimary.withValues(alpha: 0.65),
      fontSize: 12.5,
    );
  }

  /// Etiqueta superior/auxiliar de baja jerarquia.
  static TextStyle overline(bool isDark) {
    return GoogleFonts.spaceGrotesk(
      color: isDark
          ? AppPalette.onDarkSubtle
          : AppPalette.onPrimary.withValues(alpha: 0.62),
      fontSize: 12,
    );
  }

  /// Estilo de texto para botones comunes.
  static TextStyle buttonLabel(bool isDark) {
    return GoogleFonts.spaceGrotesk(
      color: isDark ? AppPalette.onDark : AppPalette.onPrimary,
      fontWeight: FontWeight.w700,
      fontSize: 15,
    );
  }

  /// Glifo tipografico para insignias sociales.
  static TextStyle socialBadgeGlyph(Color color) {
    return GoogleFonts.orbitron(
      color: color,
      fontWeight: FontWeight.w700,
      fontSize: 14,
    );
  }

  /// Estilo del call-to-action primario.
  static TextStyle primaryCta() {
    return GoogleFonts.spaceGrotesk(
      fontWeight: FontWeight.w700,
      fontSize: 16,
    );
  }

  /// Estilo de texto para campos de formulario.
  static TextStyle inputText(bool isDark) {
    return GoogleFonts.spaceGrotesk(
      color: isDark ? AppPalette.onDark : AppPalette.onPrimary,
      fontWeight: FontWeight.w500,
    );
  }

  /// Estilo de etiqueta para campos de formulario.
  static TextStyle inputLabel(bool isDark) {
    return GoogleFonts.spaceGrotesk(
      color: isDark
          ? AppPalette.onDarkMuted
          : AppPalette.onPrimary.withValues(alpha: 0.72),
    );
  }

  /// Estilo base para mensajes de error.
  static TextStyle errorStyle() {
    return GoogleFonts.spaceGrotesk();
  }
}
