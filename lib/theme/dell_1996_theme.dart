import 'package:flutter/material.dart';

/// Dell 1996 Design Language
/// Inspired by Dell.com's catalog-era enterprise web design
class Dell1996Colors {
  // Brand Colors
  static const Color primary = Color(0xFFE91D2A); // Dell Red
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color canvas = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF000000);
  static const Color frameInk = Color(0xFF000000);
  static const Color yellowSticker = Color(0xFFFCC20F);
  static const Color purpleStripe = Color(0xFF6A26A4);
  static const Color link = Color(0xFF0000EE); // Classic Mosaic blue

  // Ribbon-card tint family (one per product line)
  static const Color tintOlive = Color(0xFF8E8A25);
  static const Color tintSage = Color(0xFFB3BD95);
  static const Color tintSalmon = Color(0xFFD77A7A);
  static const Color tintPeach = Color(0xFFE6915D);
  static const Color tintLime = Color(0xFFC0D4A7);
  static const Color tintSky = Color(0xFF9AB6C8);
  static const Color tintSteel = Color(0xFFA5B8C0);
  static const Color tintPeriwinkle = Color(0xFF8C9AE0);
}

class Dell1996Typography {
  // Display - Arial Black
  static const TextStyle display = TextStyle(
    fontFamily: 'Arial',
    fontSize: 36,
    fontWeight: FontWeight.w900,
    height: 1.0,
    letterSpacing: 0,
    color: Dell1996Colors.ink,
  );

  // Heading 1
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Arial',
    fontSize: 24,
    fontWeight: FontWeight.w900,
    height: 1.05,
    letterSpacing: 0,
    color: Dell1996Colors.ink,
  );

  // Heading 2
  static const TextStyle heading2 = TextStyle(
    fontFamily: 'Helvetica',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0,
    color: Dell1996Colors.ink,
  );

  // Heading 3
  static const TextStyle heading3 = TextStyle(
    fontFamily: 'Helvetica',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0,
    color: Dell1996Colors.ink,
  );

  // Body - Times New Roman
  static const TextStyle body = TextStyle(
    fontFamily: 'Times New Roman',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
    color: Dell1996Colors.ink,
  );

  // Body Small
  static const TextStyle bodySm = TextStyle(
    fontFamily: 'Times New Roman',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
    color: Dell1996Colors.ink,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontFamily: 'Times New Roman',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.35,
    letterSpacing: 0,
    color: Dell1996Colors.ink,
  );

  // Button
  static const TextStyle button = TextStyle(
    fontFamily: 'Helvetica',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: 0,
    color: Dell1996Colors.ink,
  );

  // Link
  static const TextStyle link = TextStyle(
    fontFamily: 'Times New Roman',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
    color: Dell1996Colors.link,
    decoration: TextDecoration.underline,
  );

  // UI Label
  static const TextStyle uiLabel = TextStyle(
    fontFamily: 'Helvetica',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: 0,
    color: Dell1996Colors.ink,
  );
}

class Dell1996Spacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double s = 6;
  static const double sm = 8;
  static const double m = 10;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double sectionSm = 32;
  static const double section = 40;
  static const double sectionLg = 48;
}

/// Dell 1996 Theme Configuration
ThemeData dell1996Theme() {
  return ThemeData(
    useMaterial3: false, // Use classic Material Design
    
    // Color Scheme
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Dell1996Colors.primary,
      onPrimary: Dell1996Colors.onPrimary,
      secondary: Dell1996Colors.yellowSticker,
      onSecondary: Dell1996Colors.ink,
      error: Dell1996Colors.primary,
      onError: Dell1996Colors.onPrimary,
      surface: Dell1996Colors.surface,
      onSurface: Dell1996Colors.ink,
    ),

    scaffoldBackgroundColor: Dell1996Colors.canvas,
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Dell1996Colors.frameInk,
      foregroundColor: Dell1996Colors.canvas,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Helvetica',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Dell1996Colors.canvas,
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: Dell1996Typography.display,
      displayMedium: Dell1996Typography.heading1,
      displaySmall: Dell1996Typography.heading2,
      headlineMedium: Dell1996Typography.heading3,
      bodyLarge: Dell1996Typography.body,
      bodyMedium: Dell1996Typography.bodySm,
      bodySmall: Dell1996Typography.caption,
      labelLarge: Dell1996Typography.button,
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Dell1996Colors.frameInk,
        foregroundColor: Dell1996Colors.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // No radius - sharp corners
          side: BorderSide(color: Dell1996Colors.frameInk, width: 1),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dell1996Spacing.lg,
          vertical: Dell1996Spacing.s,
        ),
        textStyle: Dell1996Typography.button,
        elevation: 0,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Dell1996Colors.canvas,
        foregroundColor: Dell1996Colors.ink,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Dell1996Colors.frameInk, width: 1),
        ),
        side: const BorderSide(color: Dell1996Colors.frameInk, width: 1),
        padding: const EdgeInsets.symmetric(
          horizontal: Dell1996Spacing.lg,
          vertical: Dell1996Spacing.s,
        ),
        textStyle: Dell1996Typography.button,
        elevation: 0,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Dell1996Colors.canvas,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Dell1996Colors.frameInk, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Dell1996Colors.frameInk, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Dell1996Colors.frameInk, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Dell1996Spacing.s,
        vertical: Dell1996Spacing.xs,
      ),
      hintStyle: Dell1996Typography.body,
    ),

    // Card Theme
    cardTheme: const CardThemeData(
      color: Dell1996Colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Dell1996Colors.frameInk, width: 1),
      ),
      elevation: 0,
      margin: EdgeInsets.all(Dell1996Spacing.sm),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Dell1996Colors.canvas,
      selectedItemColor: Dell1996Colors.primary,
      unselectedItemColor: Dell1996Colors.ink,
      type: BottomNavigationBarType.fixed,
      elevation: 1,
      selectedLabelStyle: Dell1996Typography.uiLabel,
      unselectedLabelStyle: Dell1996Typography.uiLabel,
    ),
  );
}
