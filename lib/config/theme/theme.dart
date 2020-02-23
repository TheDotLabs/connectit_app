import 'package:connectit_app/config/fonts.dart';

/// This file defines the themes to be used in rest of the app.
/// Any user defined theme must always return the type [ThemeData]

import 'package:flutter/material.dart'
    show Brightness, ChangeNotifier, Colors, ThemeData;

import 'sample_theme_dark.dart';

enum ThemeType { LIGHT, DARK }

/// Theme Provider
class ThemeModel extends ChangeNotifier {
  get lightTheme => ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        fontFamily: Fonts.DEFAULT_FONT,
        scaffoldBackgroundColor: Colors.white,
      );

  get darkTheme => ThemeDark().themeData;

/*
  toggleTheme() {
    switch (_themeType) {
      case ThemeType.LIGHT:
        {
          _currentTheme = ThemeLight.themeData;
          _themeType = ThemeType.DARK;
          return notifyListeners();
        }
      case ThemeType.DARK:
        {
          _currentTheme = ThemeDark.themeData;
          _themeType = ThemeType.LIGHT;
          return notifyListeners();
        }
    }
  }
*/
}
