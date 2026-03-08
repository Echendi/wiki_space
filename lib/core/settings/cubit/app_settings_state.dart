import 'package:flutter/material.dart';

class AppSettingsState {
  const AppSettingsState({
    required this.locale,
    required this.themeMode,
  });

  final Locale locale;
  final ThemeMode themeMode;

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
