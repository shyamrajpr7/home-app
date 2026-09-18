// HOME PAGE
import 'package:flutter/material.dart';
import 'package:my_app/forgotpassword.dart';
import 'Aboutus.dart';
import 'profile.dart';
import 'settings.dart';
import 'bedroom1.dart';
import 'bedroom2.dart';
import 'dining.dart';
import 'kitchen.dart';
import 'outsidelight.dart';
import 'livingroom.dart';
import 'cctv.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => homePageState();
}

class homePageState extends State<homePage> {
  void _onMenuSelected(int value) {
    if (value == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (value == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } else if (value == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      );
    } else if (value == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "SMART HOME",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 3.0,
                color: Colors.white,
              ),
            ),
            Text(
              "Control Panel",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.5,
                color: Colors.white60,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<int>(
            onSelected: _onMenuSelected,
            icon: const Icon(Icons.menu_rounded),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.home, color: Colors.blue),
                      SizedBox(width: 10),
                      Text("Home"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.green),
                      SizedBox(width: 10),
                      Text("Profile"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: Colors.deepPurple),
                      SizedBox(width: 10),
                      Text("Settings"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 10),
                      Text("Logout"),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/home.jpeg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color(0x660F0F1A),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 16,
                            color: Color(0xFFFFD54F),
                          ),
                          SizedBox(width: 7),
                          Text(
                            "12 devices online",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // ── Greeting + Temperature ──
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "What would you like to control?",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.thermostat_rounded,
                            size: 18,
                            color: Color(0xFFFF8A65),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "27°C",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.02,
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    _RoomTile(
                      title: "Living Room",
                      icon: Icons.weekend_rounded,
                      page: LivingRoomPage(),
                      colors: [Color(0xFF6C63FF), Color(0xFF4A90D9)],
                    ),
                    _RoomTile(
                      title: "Bedroom 1",
                      icon: Icons.bed_rounded,
                      page: Bedroom1Page(),
                      colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                    ),
                    _RoomTile(
                      title: "Bedroom 2",
                      icon: Icons.bedroom_parent_rounded,
                      page: Bedroom2Page(),
                      colors: [Color(0xFF00897B), Color(0xFF4DB6AC)],
                    ),
                    _RoomTile(
                      title: "Dining Room",
                      icon: Icons.table_bar_rounded,
                      page: DiningRoomPage(),
                      colors: [Color(0xFFFF8F00), Color(0xFFFFB300)],
                    ),
                    _RoomTile(
                      title: "Kitchen",
                      icon: Icons.kitchen_rounded,
                      page: KitchenPage(),
                      colors: [Color(0xFFE53935), Color(0xFFFF7043)],
                    ),
                    _RoomTile(
                      title: "Outside Lights",
                      icon: Icons.light_mode_rounded,
                      page: OutsideLightsPage(),
                      colors: [Color(0xFF0288D1), Color(0xFF00BCD4)],
                    ),
                    _RoomTile(
                      title: "CCTV",
                      icon: Icons.videocam_rounded,
                      page: CCTVPage(),
                      colors: [Color(0xFF37474F), Color(0xFF546E7A)],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoomTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget page;
  final List<Color> colors;

  const _RoomTile({
    required this.title,
    required this.icon,
    required this.page,
    required this.colors,
  });

  @override
  State<_RoomTile> createState() => _RoomTileState();
}

class _RoomTileState extends State<_RoomTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.page),
        );
      },
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: widget.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.colors.first.withValues(alpha: 0.45),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.2,
            ),
          ),
          child: Stack(
            children: [
              // Decorative highlight blob
              Positioned(
                top: -24,
                right: -24,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -20,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.45),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.15),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Open",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
