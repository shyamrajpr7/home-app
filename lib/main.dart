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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeNotifier,
      builder: (context, _) {
        return MaterialApp(
          title: 'Smart Home',
          debugShowCheckedModeBanner: false,
          themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,

          // ── LIGHT THEME ──────────────
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: const Color(0xFF6C63FF),
            scaffoldBackgroundColor: const Color(0xFFF2F4F8),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
          ),

          // ── DARK THEME ───────────────
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: const Color(0xFF6C63FF),
            scaffoldBackgroundColor: const Color(0xFF0F0F1A),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1C1C2E),
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
          ),

          // home: const LoginPage(), // TODO: uncomment when login is needed
          home: const homePage(),
        );
      },
    );
  }
}