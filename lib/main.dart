import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'settings.dart';
import 'homepage.dart';
// import 'loginpage.dart'; // TODO: uncomment when login is needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _accent = Color(0xFF6C63FF);
  static const _secondary = Color(0xFF4A90D9);

  ThemeData _baseTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _accent,
        brightness: brightness,
        primary: _accent,
        secondary: _secondary,
      ),
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF0F0F1A) : const Color(0xFFF2F4F8),

      // ── TYPOGRAPHY ──────────────────
      textTheme: Typography.material2021().black.apply(
        bodyColor: isDark ? Colors.white : const Color(0xFF1A1A2E),
        displayColor: isDark ? Colors.white : const Color(0xFF1A1A2E),
      ),

      // ── APP BAR ─────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? const Color(0xFF1C1C2E)
            : const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // ── CARDS ───────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? const Color(0xFF1C1C2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        clipBehavior: Clip.antiAlias,
      ),

      // ── BUTTONS ─────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── INPUTS ──────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),

      // ── SWITCHES ────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? _accent
              : Colors.grey.shade300,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),

      // ── SNACK BARS ──────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeNotifier,
      builder: (context, _) {
        return MaterialApp(
          title: 'Smart Home',
          debugShowCheckedModeBanner: false,
          themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
          theme: _baseTheme(Brightness.light),
          darkTheme: _baseTheme(Brightness.dark),

          // home: const LoginPage(), // TODO: uncomment when login is needed
          home: const homePage(),
        );
      },
    );
  }
}