import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryRed = Color(0xFFDC2626);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color cardBackground = Color(0xFF1E293B);
  static const Color borderColor = Color(0xFF334155);
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: MaterialColor(0xFFDC2626, {
        50: Color(0xFFFEF2F2),
        100: Color(0xFFFEE2E2),
        200: Color(0xFFFECACA),
        300: Color(0xFFFCA5A5),
        400: Color(0xFFF87171),
        500: Color(0xFFEF4444),
        600: Color(0xFFDC2626),
        700: Color(0xFFB91C1C),
        800: Color(0xFF991B1B),
        900: Color(0xFF7F1D1D),
      }),
      scaffoldBackgroundColor: darkBackground,
      cardColor: cardBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E293B),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF374151),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryRed),
        ),
      ),
    );
  }
}
