// DININGROOM PAGE with Professional Background + Rotary Controls
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class DiningRoomPage extends StatefulWidget {
  const DiningRoomPage({super.key});

  @override
  State<DiningRoomPage> createState() => _DiningRoomPageState();
}

class _DiningRoomPageState extends State<DiningRoomPage> {
  bool _light1On = false;
  bool _light2On = false;
  bool _light3On = false;
  bool _fanOn = false;

  double _light1Intensity = 50;
  double _light2Intensity = 50;
  double _light3Intensity = 50;
  double _fanSpeed = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dining Room"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Stack(
        children: [
          // ✅ Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("images/dining.jpeg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // ✅ Controls
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 🔆 Light 1
                _buildControlCard(
                  title: "Light 1",
                  icon: Icon(
                    _light1On ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: _light1On ? Colors.yellow.shade800 : Colors.grey,
                    size: 36,
                  ),
                  isOn: _light1On,
                  onChanged: (value) {
                    setState(() => _light1On = value);
                    _showSnackBar(
                      _light1On ? "💡 Light 1 ON" : "💡 Light 1 OFF",
                    );
                  },
                  activeColors: [
                    Colors.yellow.shade200,
                    Colors.orange.shade300,
                  ],
                ),
                if (_light1On) ...[
                  const SizedBox(height: 12),
                  _buildRotarySlider(
                    initial: _light1Intensity,
                    min: 0,
                    max: 100,
                    unit: "%",
                    color: Colors.yellow.shade800,
                    onChanged: (val) => setState(() => _light1Intensity = val),
                  ),
                ],
                const SizedBox(height: 16),

                // 🔆 Light 2
                _buildControlCard(
                  title: "Light 2",
                  icon: Icon(
                    _light2On ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: _light2On ? Colors.yellow.shade800 : Colors.grey,
                    size: 36,
                  ),
                  isOn: _light2On,
                  onChanged: (value) {
                    setState(() => _light2On = value);
                    _showSnackBar(
                      _light2On ? "💡 Light 2 ON" : "💡 Light 2 OFF",
                    );
                  },
                  activeColors: [
                    Colors.yellow.shade200,
                    Colors.orange.shade300,
                  ],
                ),
                if (_light2On) ...[
                  const SizedBox(height: 12),
                  _buildRotarySlider(
                    initial: _light2Intensity,
                    min: 0,
                    max: 100,
                    unit: "%",
                    color: Colors.yellow.shade800,
                    onChanged: (val) => setState(() => _light2Intensity = val),
                  ),
                ],
                const SizedBox(height: 16),

                // 🔆 Light 3
                _buildControlCard(
                  title: "Light 3",
                  icon: Icon(
                    _light3On ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: _light3On ? Colors.yellow.shade800 : Colors.grey,
                    size: 36,
                  ),
                  isOn: _light3On,
                  onChanged: (value) {
                    setState(() => _light3On = value);
                    _showSnackBar(
                      _light3On ? "💡 Light 3 ON" : "💡 Light 3 OFF",
                    );
                  },
                  activeColors: [
                    Colors.yellow.shade200,
                    Colors.orange.shade300,
                  ],
                ),
                if (_light3On) ...[
                  const SizedBox(height: 12),
                  _buildRotarySlider(
                    initial: _light3Intensity,
                    min: 0,
                    max: 100,
                    unit: "%",
                    color: Colors.yellow.shade800,
                    onChanged: (val) => setState(() => _light3Intensity = val),
                  ),
                ],
                const SizedBox(height: 16),

                // 🌀 Fan
                _buildControlCard(
                  title: "Fan",
                  icon: FaIcon(
                    FontAwesomeIcons.fan,
                    color: _fanOn ? Colors.blue.shade700 : Colors.grey,
                    size: 36,
                  ),
                  isOn: _fanOn,
                  onChanged: (value) {
                    setState(() => _fanOn = value);
                    _showSnackBar(_fanOn ? "🌀 Fan ON" : "🌀 Fan OFF");
                  },
                  activeColors: [Colors.blue.shade200, Colors.blue.shade400],
                ),
                if (_fanOn) ...[
                  const SizedBox(height: 12),
                  _buildRotarySlider(
                    initial: _fanSpeed,
                    min: 0,
                    max: 5,
                    unit: "Lv",
                    color: Colors.blue.shade700,
                    onChanged: (val) => setState(() => _fanSpeed = val),
                  ),
                ],
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
    required List<Color> activeColors,
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
                ? activeColors
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

  /// Reusable Rotary Slider
  Widget _buildRotarySlider({
    required double initial,
    required double min,
    required double max,
    required String unit,
    required Color color,
    required Function(double) onChanged,
  }) {
    return SleekCircularSlider(
      min: min,
      max: max,
      initialValue: initial,
      appearance: CircularSliderAppearance(
        size: 140,
        customColors: CustomSliderColors(
          progressBarColor: color,
          shadowColor: color.withOpacity(0.3),
          trackColor: Colors.grey.shade300,
        ),
        infoProperties: InfoProperties(
          mainLabelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          modifier: (val) => "$unit ${val.toInt()}",
        ),
      ),
      onChange: onChanged,
    );
  }

  /// Snackbar helper
  void _showSnackBar(String message) {
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
