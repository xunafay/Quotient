import 'package:flutter/material.dart';

enum AppThemeMode {
  sytem,
  light,
  dark,
  amoled,
}

extension AppThemeModeExtension on AppThemeMode {
  String get themeName {
    switch (this) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.amoled:
        return 'Amoled';
      default:
        return 'System';
    }
  }

  ThemeMode get themeMode {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.amoled:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
