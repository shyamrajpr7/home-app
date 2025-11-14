//HOME PAGE
import 'package:flutter/material.dart';
import 'Aboutus.dart';
import 'profile.dart';
import 'settings.dart';
import 'main.dart';
import 'bedroom1.dart';
import 'bedroom2.dart';
import 'dining.dart';
import 'kitchen.dart';
import 'outsidelight.dart';
import 'livingroom.dart';
import 'cctv.dart'; // ✅ new CCTV page

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SMART HOME"),
        actions: [
          PopupMenuButton<int>(
            onSelected: _onMenuSelected,
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
                image: AssetImage("images/home.avif"), // <-- your background
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground content
          Center(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildRoomButton(
                  "Living Room",
                  Icons.weekend,
                  const LivingRoomPage(),
                ),
                _buildRoomButton("Bedroom 1", Icons.bed, const Bedroom1Page()),
                _buildRoomButton(
                  "Bedroom 2",
                  Icons.bed_outlined,
                  const Bedroom2Page(),
                ),
                _buildRoomButton(
                  "Dining Room",
                  Icons.table_bar,
                  const DiningRoomPage(),
                ),
                _buildRoomButton("Kitchen", Icons.kitchen, const KitchenPage()),
                _buildRoomButton(
                  "Outside Lights",
                  Icons.lightbulb,
                  const OutsideLightsPage(),
                ),

                // ✅ New CCTV widget
                _buildRoomButton("CCTV", Icons.videocam, const CCTVPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomButton(String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        width: 150,
        height: 150,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.25),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 42,
              color: const Color.fromARGB(255, 243, 243, 246),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 4,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
