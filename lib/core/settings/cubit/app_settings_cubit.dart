import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings_state.dart';

/// Gestiona la configuracion global de interfaz (idioma y tema).
///
/// Responsabilidades:
/// - Cargar preferencias persistidas al inicio.
/// - Emitir cambios de estado para refrescar UI global.
/// - Persistir cambios en `SharedPreferences`.
class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit()
      : super(
          const AppSettingsState(
            locale: Locale('es'),
            themeMode: ThemeMode.system,
          ),
        );

  static const String localeLanguageCodeKey = 'preferred_locale_language_code';
  static const String themeModeKey = 'preferred_theme_mode';

  /// Carga el idioma y modo de tema guardados localmente.
  ///
  /// Si no hay datos validos, mantiene los valores actuales del estado.
  Future<void> loadSavedPreferences() async {
    final prefs = await _getSharedPreferencesSafe();
    if (prefs == null) {
      return;
    }

    final savedLanguageCode = prefs.getString(localeLanguageCodeKey);
    final savedThemeMode = prefs.getString(themeModeKey);

    final supportedSavedLanguageCode =
        (savedLanguageCode == 'es' || savedLanguageCode == 'en')
            ? savedLanguageCode
            : null;

    final resolvedThemeMode = switch (savedThemeMode) {
      'system' => ThemeMode.system,
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    emit(
      state.copyWith(
        locale: supportedSavedLanguageCode == null
            ? state.locale
            : Locale(supportedSavedLanguageCode),
        themeMode: resolvedThemeMode,
      ),
    );
  }

  /// Actualiza el idioma actual y lo persiste si hay cambio real.
  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode == state.locale.languageCode) {
      return;
    }

    emit(state.copyWith(locale: locale));

    final prefs = await _getSharedPreferencesSafe();
    await prefs?.setString(localeLanguageCodeKey, locale.languageCode);
  }

  /// Actualiza el modo de tema actual y lo persiste si hay cambio real.
  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (themeMode == state.themeMode) {
      return;
    }

    emit(state.copyWith(themeMode: themeMode));

    final prefs = await _getSharedPreferencesSafe();
    final encodedThemeMode = switch (themeMode) {
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
    };

    await prefs?.setString(themeModeKey, encodedThemeMode);
  }

  /// Obtiene `SharedPreferences` de forma segura para entornos sin plugin.
  Future<SharedPreferences?> _getSharedPreferencesSafe() async {
    try {
      return await SharedPreferences.getInstance();
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }
}
