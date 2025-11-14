// BEDROOM2 PAGE
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Bedroom2Page extends StatefulWidget {
  const Bedroom2Page({super.key});

  @override
  State<Bedroom2Page> createState() => _Bedroom2PageState();
}

class _Bedroom2PageState extends State<Bedroom2Page> {
  bool _lightOn = false;
  bool _fanOn = false;
  bool _acOn = false;

  double _lightIntensity = 50; // Light %
  double _fanSpeed = 2; // Fan speed (0–5)
  double _acTemp = 24; // AC Temperature (16–30)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bedroom 2"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("images/bedroom2.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          //  Foreground Controls
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 🔆 Light Control
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
                ),

                if (_lightOn) ...[
                  const SizedBox(height: 12),
                  SleekCircularSlider(
                    min: 0,
                    max: 100,
                    initialValue: _lightIntensity,
                    appearance: CircularSliderAppearance(
                      size: 140,
                      customColors: CustomSliderColors(
                        progressBarColor: Colors.yellow.shade800,
                        shadowColor: Colors.orange.shade200,
                        trackColor: Colors.grey.shade300,
                      ),
                      infoProperties: InfoProperties(
                        mainLabelStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        modifier: (val) => "${val.toInt()}%",
                      ),
                    ),
                    onChange: (val) {
                      setState(() => _lightIntensity = val);
                    },
                  ),
                ],

                const SizedBox(height: 16),

                //  Fan Control
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
                ),

                if (_fanOn) ...[
                  const SizedBox(height: 12),
                  SleekCircularSlider(
                    min: 0,
                    max: 5,
                    initialValue: _fanSpeed,
                    appearance: CircularSliderAppearance(
                      size: 140,
                      customColors: CustomSliderColors(
                        progressBarColor: Colors.blue.shade700,
                        shadowColor: Colors.blue.shade200,
                        trackColor: Colors.grey.shade300,
                      ),
                      infoProperties: InfoProperties(
                        mainLabelStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        modifier: (val) => "Lv ${val.toInt()}",
                      ),
                    ),
                    onChange: (val) {
                      setState(() => _fanSpeed = val);
                    },
                  ),
                ],

                const SizedBox(height: 16),

                // AC Control
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
                ),

                if (_acOn) ...[
                  const SizedBox(height: 12),
                  SleekCircularSlider(
                    min: 16,
                    max: 30,
                    initialValue: _acTemp,
                    appearance: CircularSliderAppearance(
                      size: 140,
                      customColors: CustomSliderColors(
                        progressBarColor: Colors.cyan.shade700,
                        shadowColor: Colors.cyan.shade200,
                        trackColor: Colors.grey.shade300,
                      ),
                      infoProperties: InfoProperties(
                        mainLabelStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        modifier: (val) => "${val.toInt()}°C",
                      ),
                    ),
                    onChange: (val) {
                      setState(() => _acTemp = val);
                    },
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
