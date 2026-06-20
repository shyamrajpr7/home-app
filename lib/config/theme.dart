import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryBg = Color(0xFF1A1B2F);
  static const Color surfaceColor = Color(0xFF252740);
  static const Color accentTeal = Color(0xFF00E0C7);
  static const Color accentAmber = Color(0xFFFFB648);
  static const Color statusGreen = Color(0xFF4CD964);
  static const Color statusRed = Color(0xFFFF4D4D);
  static const Color textPrimary = Color(0xFFF2F2F7);
  static const Color textSecondary = Color(0xFF9094A6);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryBg,
      colorScheme: const ColorScheme.dark(
        primary: accentTeal,
        secondary: accentAmber,
        surface: surfaceColor,
        error: statusRed,
        onPrimary: Color(0xFF1A1B2F),
        onSecondary: Color(0xFF1A1B2F),
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme.copyWith(
              displayLarge: const TextStyle(color: textPrimary),
              displayMedium: const TextStyle(color: textPrimary),
              displaySmall: const TextStyle(color: textPrimary),
              headlineLarge: const TextStyle(color: textPrimary),
              headlineMedium: const TextStyle(color: textPrimary),
              headlineSmall: const TextStyle(color: textPrimary),
              titleLarge: const TextStyle(color: textPrimary),
              titleMedium: const TextStyle(color: textPrimary),
              titleSmall: const TextStyle(color: textPrimary),
              bodyLarge: const TextStyle(color: textPrimary),
              bodyMedium: const TextStyle(color: textSecondary),
              bodySmall: const TextStyle(color: textSecondary),
              labelLarge: const TextStyle(color: textPrimary),
              labelMedium: const TextStyle(color: textSecondary),
              labelSmall: const TextStyle(color: textSecondary),
            ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentTeal,
          foregroundColor: const Color(0xFF1A1B2F),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: statusRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: statusRed, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
        errorStyle: const TextStyle(color: statusRed),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: accentTeal,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceColor,
        contentTextStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return accentTeal;
          return textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return accentTeal.withAlpha(80);
          return textSecondary.withAlpha(40);
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      colorScheme: const ColorScheme.light(
        primary: accentTeal,
        secondary: accentAmber,
        surface: Colors.white,
        error: statusRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1A1B2F),
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme.copyWith(
              displayLarge: const TextStyle(color: Color(0xFF1A1B2F)),
              displayMedium: const TextStyle(color: Color(0xFF1A1B2F)),
              displaySmall: const TextStyle(color: Color(0xFF1A1B2F)),
              headlineLarge: const TextStyle(color: Color(0xFF1A1B2F)),
              headlineMedium: const TextStyle(color: Color(0xFF1A1B2F)),
              headlineSmall: const TextStyle(color: Color(0xFF1A1B2F)),
              titleLarge: const TextStyle(color: Color(0xFF1A1B2F)),
              titleMedium: const TextStyle(color: Color(0xFF1A1B2F)),
              titleSmall: const TextStyle(color: Color(0xFF1A1B2F)),
              bodyLarge: const TextStyle(color: Color(0xFF1A1B2F)),
              bodyMedium: const TextStyle(color: Color(0xFF6B7280)),
              bodySmall: const TextStyle(color: Color(0xFF6B7280)),
              labelLarge: const TextStyle(color: Color(0xFF1A1B2F)),
              labelMedium: const TextStyle(color: Color(0xFF6B7280)),
              labelSmall: const TextStyle(color: Color(0xFF6B7280)),
            ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentTeal,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0F0F3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: statusRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: statusRed, width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF6B7280)),
        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
        errorStyle: const TextStyle(color: statusRed),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: accentTeal,
        unselectedItemColor: Color(0xFF6B7280),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF1A1B2F)),
        titleTextStyle: TextStyle(
          color: Color(0xFF1A1B2F),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.white,
        contentTextStyle: const TextStyle(color: Color(0xFF1A1B2F)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return accentTeal;
          return const Color(0xFF6B7280);
        }),
        trackColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return accentTeal.withAlpha(80);
          return const Color(0xFF6B7280).withAlpha(40);
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
