import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF10B981);
  static const Color accentColor = Color(0xFF10B981);

  // Light Theme Colors
  static const Color lightBackgroundColor = Color(0xFFF8FAFC);
  static const Color lightCardColor = Colors.white;
  static const Color lightTextColor = Color(0xFF1E293B);
  static const Color lightTextSecondaryColor = Color(0xFF64748B);

  // Dark Theme Colors
  static const Color darkBackgroundColor = Color(0xFF111827);
  static const Color darkCardColor = Color(0xFF1F2937);
  static const Color darkTextColor = Color(0xFFF8FAFC);
  static const Color darkTextSecondaryColor = Color(0xFF94A3B8);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        surface: lightBackgroundColor,
        onPrimary: Colors.white,
        onSurface: lightTextColor,
      ),
      scaffoldBackgroundColor: lightBackgroundColor,
      cardTheme: CardThemeData(
        color: lightCardColor,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.inter(
              color: lightTextColor,
              fontWeight: FontWeight.bold,
            ),
            displayMedium: GoogleFonts.inter(
              color: lightTextColor,
              fontWeight: FontWeight.bold,
            ),
            displaySmall: GoogleFonts.inter(
              color: lightTextColor,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: GoogleFonts.inter(
              color: lightTextColor,
              fontWeight: FontWeight.w700,
            ),
            titleLarge: GoogleFonts.inter(
              color: lightTextColor,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: GoogleFonts.inter(color: lightTextColor),
            bodyMedium: GoogleFonts.inter(color: lightTextSecondaryColor),
          ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackgroundColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: lightTextColor),
        titleTextStyle: TextStyle(
          color: lightTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightCardColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightTextSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        secondary: accentColor,
        surface: darkCardColor,
        onPrimary: Colors.white,
        onSurface: darkTextColor,
      ),
      scaffoldBackgroundColor: darkBackgroundColor,
      cardTheme: CardThemeData(
        color: darkCardColor,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.inter(
              color: darkTextColor,
              fontWeight: FontWeight.bold,
            ),
            displayMedium: GoogleFonts.inter(
              color: darkTextColor,
              fontWeight: FontWeight.bold,
            ),
            displaySmall: GoogleFonts.inter(
              color: darkTextColor,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: GoogleFonts.inter(
              color: darkTextColor,
              fontWeight: FontWeight.w700,
            ),
            titleLarge: GoogleFonts.inter(
              color: darkTextColor,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: GoogleFonts.inter(color: darkTextColor),
            bodyMedium: GoogleFonts.inter(color: darkTextSecondaryColor),
          ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackgroundColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: darkTextColor),
        titleTextStyle: TextStyle(
          color: darkTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkCardColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkTextSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
