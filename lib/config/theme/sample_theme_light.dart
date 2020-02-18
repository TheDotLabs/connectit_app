import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../fonts.dart';
import 'material_color.dart';

class ThemeLight {
  static final ThemeData themeData = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    fontFamily: Fonts.DEFAULT_FONT,
    appBarTheme: _appBarTheme,
    scaffoldBackgroundColor: Colors.white,
    bottomAppBarTheme: BottomAppBarTheme(
      color: Colors.white,
    ),
    backgroundColor: Colors.white,
    bottomAppBarColor: Colors.white,
  );

  static final MaterialColor _primarySwatch = hexColor2MaterialColor(0xFF31B2DF);
  static final Color _primaryColor = Color(0xFF31B2DF);
  static final Color _primaryColorDark = Color(0xFF005486);
  static final Color _hintColor = Color(0xffaaaaaa);
  static final Color _unselectedWidgetColor = Color(0xffcccccc);
  static final Color _scaffoldBackgroundColor = Colors.white;

  static final AppBarTheme _appBarTheme = AppBarTheme(
    color: Colors.white,
    elevation: 1,
    brightness: Brightness.light,
    textTheme: TextTheme(
      title: GoogleFonts.nunito(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
