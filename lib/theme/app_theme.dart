// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Call AppTheme.light() from MaterialApp.theme
  static ThemeData light() {
    final base = ThemeData.light();

    return base.copyWith(
      // scaffold background (you wanted white)
      scaffoldBackgroundColor: Colors.white,

      // Use Inter for the whole app's TextTheme
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),

      // AppBar theme example — keeps your appbar white + black text/icons
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),

      // You can also set primary/secondary colors as needed
      colorScheme: base.colorScheme.copyWith(
        primary: Colors.blue,
      ),
    );
  }
}
