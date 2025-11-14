// BEDROOM1 PAGE with Background Image + Rotating Controls
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Bedroom1Page extends StatefulWidget {
  const Bedroom1Page({super.key});

  @override
  State<Bedroom1Page> createState() => _Bedroom1PageState();
}

class _Bedroom1PageState extends State<Bedroom1Page> {
  bool _lightOn = false;
  bool _fanOn = false;
  bool _acOn = false;

  double _lightIntensity = 50; // %
  double _fanSpeed = 2; // Level 0–5
  double _acTemp = 24; // °C

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bedroom 1"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Stack(
        children: [
          // ✅ Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bedroom1.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // ✅ Foreground (Cards)
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Light
                _buildControlCard(
                  title: "Light",
                  icon: Icon(
                    _lightOn ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: _lightOn ? Colors.yellow.shade800 : Colors.grey,
                    size: 36,
                  ),
                  isOn: _lightOn,
                  onChanged: (value) {
                    setState(() => _lightOn = value);
                    _showSnackBar(
                      _lightOn ? "💡 Light turned ON" : "💡 Light turned OFF",
                    );
                  },
                  activeColors: [
                    Colors.yellow.shade200,
                    Colors.orange.shade300,
                  ],
                  extraWidget: _lightOn
                      ? _buildCircularSlider(
                          min: 0,
                          max: 100,
                          value: _lightIntensity,
                          label: "Intensity",
                          unit: "%",
                          onChange: (val) =>
                              setState(() => _lightIntensity = val),
                        )
                      : null,
                ),
                const SizedBox(height: 16),

                // Fan
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
                    _showSnackBar(
                      _fanOn ? "🌀 Fan turned ON" : "🌀 Fan turned OFF",
                    );
                  },
                  activeColors: [Colors.blue.shade200, Colors.blue.shade400],
                  extraWidget: _fanOn
                      ? _buildCircularSlider(
                          min: 0,
                          max: 5,
                          value: _fanSpeed,
                          label: "Speed",
                          unit: "lvl",
                          onChange: (val) => setState(() => _fanSpeed = val),
                        )
                      : null,
                ),
                const SizedBox(height: 16),

                // AC
                _buildControlCard(
                  title: "Air Conditioner",
                  icon: Icon(
                    _acOn ? Icons.ac_unit : Icons.ac_unit_outlined,
                    color: _acOn ? Colors.cyan.shade700 : Colors.grey,
                    size: 36,
                  ),
                  isOn: _acOn,
                  onChanged: (value) {
                    setState(() => _acOn = value);
                    _showSnackBar(
                      _acOn ? "❄️ AC turned ON" : "❄️ AC turned OFF",
                    );
                  },
                  activeColors: [Colors.cyan.shade200, Colors.cyan.shade400],
                  extraWidget: _acOn
                      ? _buildCircularSlider(
                          min: 16,
                          max: 30,
                          value: _acTemp,
                          label: "Temp",
                          unit: "°C",
                          onChange: (val) => setState(() => _acTemp = val),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable Control Card with optional extraWidget
  Widget _buildControlCard({
    required String title,
    required Widget icon,
    required bool isOn,
    required Function(bool) onChanged,
    required List<Color> activeColors,
    Widget? extraWidget,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 12,
      shadowColor: Colors.black.withOpacity(0.5),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          children: [
            Row(
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
            if (extraWidget != null) ...[
              const SizedBox(height: 12),
              extraWidget,
            ],
          ],
        ),
      ),
    );
  }

  /// Sleek Circular Slider Builder
  Widget _buildCircularSlider({
    required double min,
    required double max,
    required double value,
    required String label,
    required String unit,
    required Function(double) onChange,
  }) {
    return SleekCircularSlider(
      min: min,
      max: max,
      initialValue: value,
      appearance: CircularSliderAppearance(
        size: 120,
        customWidths: CustomSliderWidths(progressBarWidth: 12, trackWidth: 6),
        customColors: CustomSliderColors(
          progressBarColor: Colors.deepPurple,
          dotColor: Colors.deepPurpleAccent,
          trackColor: Colors.grey.shade300,
        ),
        infoProperties: InfoProperties(
          mainLabelStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          modifier: (val) => "${val.toInt()} $unit",
          topLabelText: label,
          topLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onChange: onChange,
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



