import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/auth_provider.dart';
import '../config/theme.dart';
import '../config/constants.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    if (AppConstants.devBypass) {
      final storage = const FlutterSecureStorage();
      final devAuth = await storage.read(key: 'dev_authenticated');
      if (mounted) {
        context.go(devAuth == 'true' ? '/home' : '/onboarding');
      }
      return;
    }

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AppConstants.devBypass) {
      ref.listen(authStateProvider, (prev, next) {
        next.whenData((user) {
          if (user != null) {
            context.go('/home');
          } else {
            context.go('/onboarding');
          }
        });
        next.whenError((error, stack) {
          if (mounted) context.go('/onboarding');
        });
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.primaryBg,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.accentTeal,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentTeal.withAlpha(60),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.home_outlined,
                    color: Color(0xFF1A1B2F),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'HomeAuto',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Smart Living, Simplified',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
