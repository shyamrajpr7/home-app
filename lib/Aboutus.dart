/////////////////////////
// Extra Pages
/////////////////////////
library;
//ABOUT APP
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        title: const Text(
          "Home Automation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF1C1C2E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── HERO BANNER ─────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF4A90D9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      size: 44,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "SMART HOME",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Control your lights, fans, AC, CCTV and more from "
                    "anywhere at any time. Enjoy a seamless smart living "
                    "experience!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── FEATURE CHIPS ───────────
            const Text(
              "WHAT'S INCLUDED",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.6,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.lightbulb_rounded,
                    label: "Lighting",
                    color: Color(0xFFFFB300),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.air_rounded,
                    label: "Climate",
                    color: Color(0xFF00ACC1),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _FeatureCard(
                    icon: Icons.videocam_rounded,
                    label: "CCTV",
                    color: Color(0xFF5C6BC0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── MAKERS ──────────────────
            const Text(
              "MEET THE MAKERS",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.6,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 12),
            _MakerCard(
              name: "Shyam Raj",
              role: "Developer",
              email: "shyamraj.p.r777@gmail.com",
              imageUrl: "images/Untitled106_20250821114107.jpg",
              color: const Color(0xFF6C63FF),
            ),
            const SizedBox(height: 12),
            _MakerCard(
              name: "Binoy",
              role: "Developer",
              email: "binoy@example.com",
              imageUrl: "images/WhatsApp Image 2025-08-28 at 12.07.22.jpeg",
              color: const Color(0xFF26A69A),
            ),
            const SizedBox(height: 12),
            _MakerCard(
              name: "Athira",
              role: "UI/UX Designer",
              email: "athira@example.com",
              imageUrl: "images/WhatsApp Image 2025-08-28 at 12.05.34.jpeg",
              color: const Color(0xFFAB47BC),
            ),
            const SizedBox(height: 12),
            _MakerCard(
              name: "Ardra",
              role: "UI/UX Designer",
              email: "Ardra@example.com",
              imageUrl: "images/WhatsApp Image 2025-08-28 at 12.06.29.jpeg",
              color: const Color(0xFFFF7043),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C2E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Maker Card widget
class _MakerCard extends StatelessWidget {
  final String name;
  final String role;
  final String email;
  final String imageUrl;
  final Color color;

  const _MakerCard({
    required this.name,
    required this.role,
    required this.email,
    required this.imageUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundImage: AssetImage(imageUrl),
              radius: 30,
              backgroundColor: const Color(0xFF2A2A44),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        role,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: Colors.white38,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        email,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}