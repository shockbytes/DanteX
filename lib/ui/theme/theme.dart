import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData lightThemeData() {
    return ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: Colors.white,
      fontFamily: GoogleFonts.nunito().fontFamily,
    );
  }

  static ThemeData darkThemeData() {
    return lightThemeData().copyWith(
      brightness: Brightness.dark,
    );
  }
}
