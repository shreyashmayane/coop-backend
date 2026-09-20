import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized app theme — dark, premium, indigo/teal palette.
class AppTheme {
  AppTheme._();

  // ─── Brand Colours ────────────────────────────────────────────────────────
  static const Color primary      = Color(0xFF6C63FF); // vibrant indigo
  static const Color primaryDark  = Color(0xFF4B44CC);
  static const Color accent       = Color(0xFF00D4AA); // teal accent
  static const Color background   = Color(0xFF0F0F1A); // near-black
  static const Color surface      = Color(0xFF1A1A2E); // dark card surface
  static const Color surfaceLight = Color(0xFF252540); // lighter surface
  static const Color onBackground = Color(0xFFE8E8F0);
  static const Color onSurface    = Color(0xFFB0B0C8);
  static const Color error        = Color(0xFFFF5C6E);
  static const Color success      = Color(0xFF4CAF82);
  static const Color warning      = Color(0xFFFFB347);
  static const Color divider      = Color(0xFF2A2A45);

  // ─── Service Category Colours ─────────────────────────────────────────────
  static const List<Color> categoryColors = [
    Color(0xFF6C63FF),
    Color(0xFF00D4AA),
    Color(0xFFFF6B6B),
    Color(0xFFFFB347),
    Color(0xFF4FC3F7),
    Color(0xFFBA68C8),
    Color(0xFF81C784),
    Color(0xFFFF8A65),
  ];

  // ─── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9C63FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00D4AA), Color(0xFF00A896)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── Radii ────────────────────────────────────────────────────────────────
  static const double radiusSm  = 8.0;
  static const double radiusMd  = 12.0;
  static const double radiusLg  = 20.0;
  static const double radiusXl  = 28.0;

  // ─── Spacing ──────────────────────────────────────────────────────────────
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  // ─── Shadows ──────────────────────────────────────────────────────────────
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.35),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> primaryShadow = [
    BoxShadow(
      color: primary.withOpacity(0.4),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // ─── ThemeData ────────────────────────────────────────────────────────────
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: surface,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: onBackground,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(
          color: onBackground, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.poppins(
          color: onBackground, fontSize: 26, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.poppins(
          color: onBackground, fontSize: 20, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.poppins(
          color: onBackground, fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(
          color: onBackground, fontSize: 16, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.poppins(
          color: onBackground, fontSize: 15),
        bodyMedium: GoogleFonts.poppins(
          color: onSurface, fontSize: 13),
        labelLarge: GoogleFonts.poppins(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: onBackground),
        titleTextStyle: GoogleFonts.poppins(
          color: onBackground, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: error),
        ),
        labelStyle: GoogleFonts.poppins(color: onSurface, fontSize: 14),
        hintStyle: GoogleFonts.poppins(color: onSurface, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceLight,
        labelStyle: GoogleFonts.poppins(color: onBackground, fontSize: 12),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: const DividerThemeData(color: divider, space: 1),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: onSurface,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceLight,
        contentTextStyle: GoogleFonts.poppins(color: onBackground),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
