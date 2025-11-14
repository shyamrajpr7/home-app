import 'package:flutter/material.dart';

class CCTVPage extends StatelessWidget {
  const CCTVPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text(
          "CCTV Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 feeds per row
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 4, // Number of cameras
          itemBuilder: (context, index) {
            return CCTVFeedTile(cameraName: "Camera ${index + 1}");
          },
        ),
      ),
    );
  }
}

class CCTVFeedTile extends StatelessWidget {
  final String cameraName;

  const CCTVFeedTile({super.key, required this.cameraName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Open full screen CCTV feed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CCTVFullScreen(cameraName: cameraName),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Fake video feed background (replace with actual camera stream later)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Icon(
                      Icons.videocam,
                      size: 60,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),

            // Camera name label
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  cameraName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CCTVFullScreen extends StatelessWidget {
  final String cameraName;

  const CCTVFullScreen({super.key, required this.cameraName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(cameraName), backgroundColor: Colors.black),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey.shade800,
          child: const Center(
            child: Icon(Icons.videocam, size: 120, color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
