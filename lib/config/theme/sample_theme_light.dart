import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../fonts.dart';

class ThemeLight {
  final ThemeData themeData = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    fontFamily: Fonts.DEFAULT_FONT,
    appBarTheme: _appBarTheme,
    scaffoldBackgroundColor: Colors.white,
  );

  static final AppBarTheme _appBarTheme = AppBarTheme(
    color: Colors.white,
    elevation: 1,
    textTheme: TextTheme(
      title: GoogleFonts.nunito(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
