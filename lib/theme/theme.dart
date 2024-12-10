import 'package:dantex/theme/dante_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData lightThemeData() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),
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
        DanteColors.lightTheme(),
      ],
      listTileTheme: const ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
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
        DanteColors.darkTheme(),
      ],
      listTileTheme: const ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
