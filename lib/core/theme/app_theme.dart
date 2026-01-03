import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2962FF); // Deep Blue
  static const Color secondaryColor = Color(0xFF00BFA5); // Teal Accent
  static const Color backgroundColorLight = Color(0xFFF5F7FA);
  static const Color surfaceColorLight = Colors.white;
  static const Color backgroundColorDark = Color(0xFF121212);
  static const Color surfaceColorDark = Color(0xFF1E1E1E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColorLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        surface: surfaceColorLight,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColorLight,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      // cardTheme: CardTheme(
      //   color: surfaceColorLight,
      //   elevation: 2,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // ),
    );
  }

  static ThemeData get sepiaTheme {
    const sepiaBackground = Color(0xFFF4ECD8);
    const sepiaSurface = Color(0xFFFFFDF5);
    const sepiaPrimary = Color(0xFF8D6E63); // Brownish

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: sepiaPrimary,
      scaffoldBackgroundColor: sepiaBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: sepiaPrimary,
        brightness: Brightness.light,
        surface: sepiaSurface,
        background: sepiaBackground, // Explicit background
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: Colors.brown[900],
        displayColor: Colors.brown[900],
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: sepiaSurface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.brown),
        titleTextStyle: TextStyle(
          color: Colors.brown,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColorDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        surface: surfaceColorDark,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColorDark,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      // cardTheme: CardTheme(
      //   color: surfaceColorDark,
      //   elevation: 2,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // ),
    );
  }
}
