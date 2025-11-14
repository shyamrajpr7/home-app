/////////////////////////
// Extra Pages
/////////////////////////
//ABOUT APP
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Home Automation"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            const Text(
              "SMART HOME",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // App Info Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    Icon(
                      Icons.home_rounded,
                      size: 60,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Welcome to Smart Home App",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Control your lights, fans, AC, CCTV and more "
                      "from anywhere at any time. Enjoy a seamless smart living experience!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Makers Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Meet the Makers",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // Maker Cards
            _MakerCard(
              name: "Shyam Raj",
              role: "Developer",
              email: "shyamraj.p.r777@gmail.com",
              imageUrl: "images/Untitled106_20250821114107.jpg",
            ),
            const SizedBox(height: 15),
            _MakerCard(
              name: "Binoy",
              role: "developer",
              email: "binoy@example.com",
              imageUrl: "images/WhatsApp Image 2025-08-28 at 12.07.22.jpeg",
            ),
            const SizedBox(height: 15),
            _MakerCard(
              name: "Athira",
              role: "UI/UX Designer",
              email: "athira@example.com",
              imageUrl: "images/WhatsApp Image 2025-08-28 at 12.05.34.jpeg",
            ),
            const SizedBox(height: 15),
            _MakerCard(
              name: "Ardra",
              role: "UI/UX Designer",
              email: "Ardra@example.com",
              imageUrl: "images/WhatsApp Image 2025-08-28 at 12.06.29.jpeg",
            ),
          ],
        ),
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

  const _MakerCard({
    required this.name,
    required this.role,
    required this.email,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundImage: AssetImage(imageUrl),
          radius: 30,
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text("$role\n$email"),
        isThreeLine: true,
      ),
    );
  }
}
