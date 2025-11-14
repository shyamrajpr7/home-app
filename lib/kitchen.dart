// KITCHEN PAGE
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({super.key});

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  bool _light1On = false;
  bool _light2On = false;
  bool _fridgeOn = false;
  bool _ovenOn = false;
  bool _fanOn = false;

  double _light1Intensity = 50;
  double _light2Intensity = 50;
  double _fanSpeed = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kitchen"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Stack(
        children: [
          // ✅ Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("images/kitchen.jpeg"),
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
                // 🔆 Light 1
                _buildControlCard(
                  title: "Light 1",
                  icon: Icon(
                    _light1On ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: _light1On ? Colors.yellow.shade800 : Colors.grey,
                    size: 36,
                  ),
                  isOn: _light1On,
                  onChanged: (val) {
                    setState(() => _light1On = val);
                    _showSnack(
                      _light1On
                          ? "💡 Kitchen Light 1 ON"
                          : "💡 Kitchen Light 1 OFF",
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

                //  Light 2
                _buildControlCard(
                  title: "Light 2",
                  icon: Icon(
                    _light2On ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: _light2On ? Colors.yellow.shade800 : Colors.grey,
                    size: 36,
                  ),
                  isOn: _light2On,
                  onChanged: (val) {
                    setState(() => _light2On = val);
                    _showSnack(
                      _light2On
                          ? "💡 Kitchen Light 2 ON"
                          : "💡 Kitchen Light 2 OFF",
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
                //  Fan
                _buildControlCard(
                  title: "Fan",
                  icon: FaIcon(
                    FontAwesomeIcons.fan,
                    color: _fanOn ? Colors.blue.shade700 : Colors.grey,
                    size: 36,
                  ),
                  isOn: _fanOn,
                  onChanged: (val) {
                    setState(() => _fanOn = val);
                    _showSnack(_fanOn ? "🌀 Fan ON" : "🌀 Fan OFF");
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
                const SizedBox(height: 16),

                //  Fridge
                _buildControlCard(
                  title: "Fridge",
                  icon: Icon(
                    Icons.kitchen,
                    color: _fridgeOn ? Colors.blue.shade700 : Colors.grey,
                    size: 36,
                  ),
                  isOn: _fridgeOn,
                  onChanged: (val) {
                    setState(() => _fridgeOn = val);
                    _showSnack(_fridgeOn ? "🧊 Fridge ON" : "🧊 Fridge OFF");
                  },
                  activeColors: [Colors.cyan.shade200, Colors.cyan.shade400],
                ),
                const SizedBox(height: 16),

                //  Oven
                _buildControlCard(
                  title: "Oven",
                  icon: Icon(
                    Icons.local_fire_department,
                    color: _ovenOn ? Colors.red.shade700 : Colors.grey,
                    size: 36,
                  ),
                  isOn: _ovenOn,
                  onChanged: (val) {
                    setState(() => _ovenOn = val);
                    _showSnack(_ovenOn ? "🔥 Oven ON" : "🔥 Oven OFF");
                  },
                  activeColors: [Colors.red.shade200, Colors.red.shade400],
                ),
                const SizedBox(height: 16),
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
