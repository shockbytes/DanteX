import 'package:dantex/theme/dante_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData lightThemeData() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.white,
    );

    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: GoogleFonts.nunito().fontFamily,
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        DanteColors(
          forLaterColor: Colors.green,
          readingColor: Colors.blue,
          readColor: Colors.orange,
          wishlistColor: Colors.purple,
        ),
      ],
    );
  }

  static ThemeData darkThemeData() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.white,
      brightness: Brightness.dark,
    );

    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: GoogleFonts.nunito().fontFamily,
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        DanteColors(
          forLaterColor: Colors.green,
          readingColor: Colors.blue,
          readColor: Colors.orange,
          wishlistColor: Colors.purple,
        ),
      ],
    );
  }
}
