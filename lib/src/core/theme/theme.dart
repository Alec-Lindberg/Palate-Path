import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Base Colors ---
const Color _primarySeed = Color(0xFF3F6B5B); // deep green
const Color _secondary = Color(0xFF9FD6C2);   // mint
const Color _background = Color(0xFFF6FBF8);  // soft off-white

final TextTheme _textTheme = GoogleFonts.latoTextTheme();

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  // Build a Material 3 scheme, then override what we care about.
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primarySeed,
    brightness: Brightness.light,
  ).copyWith(
    primary: _primarySeed,
    secondary: _secondary,
    surface: Colors.white,
  ),

  scaffoldBackgroundColor: _background,

  textTheme: _textTheme,

  appBarTheme: AppBarTheme(
    backgroundColor: _primarySeed,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: _textTheme.titleLarge?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),

cardTheme: CardThemeData(
  elevation: 1,
  color: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: Colors.grey, width: 0.5),
  ),
),



  chipTheme: ChipThemeData(
    backgroundColor: _secondary.withOpacity(0.35),
    labelStyle: const TextStyle(
      color: _primarySeed,
      fontWeight: FontWeight.w600,
    ),
    side: BorderSide.none,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _primarySeed,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _primarySeed,
    ),
  ),
);

