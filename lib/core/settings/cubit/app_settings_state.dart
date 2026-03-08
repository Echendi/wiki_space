import 'package:flutter/material.dart';

/// Estado inmutable de configuracion global de la app.
///
/// Contiene preferencias de interfaz compartidas:
/// - `locale`: idioma actual.
/// - `themeMode`: modo de tema actual.
class AppSettingsState {
  const AppSettingsState({
    required this.locale,
    required this.themeMode,
  });

  final Locale locale;
  final ThemeMode themeMode;

  /// Crea una nueva instancia de estado con cambios parciales.
  AppSettingsState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return AppSettingsState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
