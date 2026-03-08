import 'package:flutter/material.dart';

/// Paleta centralizada de colores de la aplicacion.
///
/// Define colores semanticos reutilizables para mantener consistencia visual
/// entre light/dark mode y componentes de UI.
class AppPalette {
  static const Color primary = Color(0xFF55D6BE);
  static const Color secondary = Color(0xFF2B8BCF);
  static const Color accent = Color(0xFF79D7C5);

  static const Color onPrimary = Color(0xFF06223C);
  static const Color onDark = Color(0xFFEAF5FF);
  static const Color onDarkMuted = Color(0xFFCDE2F6);
  static const Color onDarkSubtle = Color(0xFFA4C2E4);

  static const Color appBarDark = Color(0xFF08142A);
  static const Color appBarLight = Color(0xFFE9F3FF);

  static const Color backgroundDark = Color(0xFF08142A);
  static const Color backgroundLight = Color(0xFFF4F9FF);

  static const Color surfaceDark = Color(0xFF0E1F36);
  static const Color surfaceDarkAlt = Color(0xFF102A47);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceLightAlt = Color(0xFFE5F1FF);
  static const Color borderMuted = Color(0x4D7BD4C7);

  static const Color error = Color(0xFFD4495B);
  static const Color star = Color.fromARGB(255, 0, 207, 169);

  static const Color googleBadgeBackground = Color(0xFFFFE2CC);
  static const Color googleBadgeForeground = Color(0xFF8F3A00);
  static const Color facebookBadgeBackground = Color(0xFFD2E3FF);
  static const Color facebookBadgeForeground = Color(0xFF0B48B8);

  static const List<Color> homeDarkGradient = <Color>[
    Color(0xFF09172D),
    Color(0xFF10375A),
  ];

  static const List<Color> homeLightGradient = <Color>[
    Color(0xFFEBF6FF),
    Color(0xFFD9ECFF),
  ];
}
