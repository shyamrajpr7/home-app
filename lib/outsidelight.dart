// OUTSIDE LIGHTS PAGE with Professional Background
import 'package:flutter/material.dart';

class OutsideLightsPage extends StatefulWidget {
  const OutsideLightsPage({super.key});

  @override
  State<OutsideLightsPage> createState() => _OutsideLightsPageState();
}

class _OutsideLightsPageState extends State<OutsideLightsPage> {
  bool _gateLightOn = false;
  bool _gardenLightOn = false;
  bool _garageLightOn = false;
  bool _balconyLightOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Outside Lights"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/outside.avif"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Controls
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildControlCard(
                  title: "Gate Light",
                  icon: Icon(
                    _gateLightOn ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: _gateLightOn ? Colors.yellow.shade800 : Colors.grey,
                    size: 36,
                  ),
                  isOn: _gateLightOn,
                  onChanged: (val) {
                    setState(() => _gateLightOn = val);
                    _showSnack(
                      _gateLightOn ? "💡 Gate Light ON" : "💡 Gate Light OFF",
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildControlCard(
                  title: "Garden Light",
                  icon: Icon(
                    _gardenLightOn ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: _gardenLightOn
                        ? Colors.yellow.shade800
                        : Colors.grey,
                    size: 36,
                  ),
                  isOn: _gardenLightOn,
                  onChanged: (val) {
                    setState(() => _gardenLightOn = val);
                    _showSnack(
                      _gardenLightOn
                          ? "💡 Garden Light ON"
                          : "💡 Garden Light OFF",
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildControlCard(
                  title: "Garage Light",
                  icon: Icon(
                    _garageLightOn ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: _garageLightOn
                        ? Colors.yellow.shade800
                        : Colors.grey,
                    size: 36,
                  ),
                  isOn: _garageLightOn,
                  onChanged: (val) {
                    setState(() => _garageLightOn = val);
                    _showSnack(
                      _garageLightOn
                          ? "💡 Garage Light ON"
                          : "💡 Garage Light OFF",
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildControlCard(
                  title: "Balcony Light",
                  icon: Icon(
                    _balconyLightOn ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: _balconyLightOn
                        ? Colors.yellow.shade800
                        : Colors.grey,
                    size: 36,
                  ),
                  isOn: _balconyLightOn,
                  onChanged: (val) {
                    setState(() => _balconyLightOn = val);
                    _showSnack(
                      _balconyLightOn
                          ? "💡 Balcony Light ON"
                          : "💡 Balcony Light OFF",
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable Control Card
  Widget _buildControlCard({
    required String title,
    required Widget icon,
    required bool isOn,
    required Function(bool) onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 12,
      shadowColor: Colors.black.withOpacity(0.5),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isOn
                ? [Colors.yellow.shade200, Colors.orange.shade300]
                : [Colors.grey.shade200, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon,
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isOn ? Colors.black87 : Colors.black54,
                  ),
                ),
              ],
            ),
            Switch(
              value: isOn,
              activeColor: Colors.deepPurple,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  /// Snackbar helper
  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
