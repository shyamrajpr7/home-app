// SETTINGS PAGE
import 'package:flutter/material.dart';
import 'profile.dart';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  bool notifications = true;
  bool wifiControl = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const SizedBox(height: 10),

          // Profile Settings
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: const Text("Account"),
            subtitle: const Text("Update profile information"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Profile Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          const Divider(),

          // Dark Mode
          SwitchListTile(
            value: darkMode,
            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    darkMode ? "Dark Mode Enabled" : "Dark Mode Disabled",
                  ),
                ),
              );
            },
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode, color: Colors.deepPurple),
          ),

          // Notifications
          SwitchListTile(
            value: notifications,
            onChanged: (value) {
              setState(() {
                notifications = value;
              });
            },
            title: const Text("Notifications"),
            secondary: const Icon(Icons.notifications, color: Colors.orange),
          ),

          // WiFi Control
          SwitchListTile(
            value: wifiControl,
            onChanged: (value) {
              setState(() {
                wifiControl = value;
              });
            },
            title: const Text("WiFi Control"),
            secondary: const Icon(Icons.wifi, color: Colors.green),
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              ); // go back to previous page
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Logged Out")));
            },
          ),
        ],
      ),
    );
  }
}