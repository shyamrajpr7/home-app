// DININGROOM PAGE with Professional Background + Rotary Controls
import 'package:flutter/material.dart';
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
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
            child: Column(
              children: [
                // 🔆 Light 1
                _buildControlCard(
                  title: "Light 1",
                  subtitle: "Chandelier",
                  icon: Icons.lightbulb_rounded,
                  accent: const Color(0xFFFFB300),
                  isOn: _light1On,
                  slider: _light1On
                      ? _buildRotarySlider(
                          initial: _light1Intensity,
                          min: 0,
                          max: 100,
                          unit: "%",
                          color: const Color(0xFFFFB300),
                          onChanged: (val) =>
                              setState(() => _light1Intensity = val),
                        )
                      : null,
                  onChanged: (value) {
                    setState(() => _light1On = value);
                    _showSnackBar(
                      _light1On ? "💡 Light 1 ON" : "💡 Light 1 OFF",
                    );
                  },
                ),
                const SizedBox(height: 16),

                // 🔆 Light 2
                _buildControlCard(
                  title: "Light 2",
                  subtitle: "Wall sconces",
                  icon: Icons.lightbulb_rounded,
                  accent: const Color(0xFFFFB300),
                  isOn: _light2On,
                  slider: _light2On
                      ? _buildRotarySlider(
                          initial: _light2Intensity,
                          min: 0,
                          max: 100,
                          unit: "%",
                          color: const Color(0xFFFFB300),
                          onChanged: (val) =>
                              setState(() => _light2Intensity = val),
                        )
                      : null,
                  onChanged: (value) {
                    setState(() => _light2On = value);
                    _showSnackBar(
                      _light2On ? "💡 Light 2 ON" : "💡 Light 2 OFF",
                    );
                  },
                ),
                const SizedBox(height: 16),

                // 🔆 Light 3
                _buildControlCard(
                  title: "Light 3",
                  subtitle: "Table spotlight",
                  icon: Icons.lightbulb_rounded,
                  accent: const Color(0xFFFFB300),
                  isOn: _light3On,
                  slider: _light3On
                      ? _buildRotarySlider(
                          initial: _light3Intensity,
                          min: 0,
                          max: 100,
                          unit: "%",
                          color: const Color(0xFFFFB300),
                          onChanged: (val) =>
                              setState(() => _light3Intensity = val),
                        )
                      : null,
                  onChanged: (value) {
                    setState(() => _light3On = value);
                    _showSnackBar(
                      _light3On ? "💡 Light 3 ON" : "💡 Light 3 OFF",
                    );
                  },
                ),
                const SizedBox(height: 16),

                // 🌀 Fan
                _buildControlCard(
                  title: "Fan",
                  subtitle: "Ceiling fan",
                  icon: Icons.mode_fan_off_rounded,
                  accent: const Color(0xFF1E88E5),
                  isOn: _fanOn,
                  slider: _fanOn
                      ? _buildRotarySlider(
                          initial: _fanSpeed,
                          min: 0,
                          max: 5,
                          unit: "Lv",
                          color: const Color(0xFF1E88E5),
                          onChanged: (val) => setState(() => _fanSpeed = val),
                        )
                      : null,
                  onChanged: (value) {
                    setState(() => _fanOn = value);
                    _showSnackBar(_fanOn ? "🌀 Fan ON" : "🌀 Fan OFF");
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
    required String subtitle,
    required IconData icon,
    required Color accent,
    required bool isOn,
    required Function(bool) onChanged,
    Widget? slider,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isOn
                ? accent.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isOn
              ? accent.withValues(alpha: 0.4)
              : Colors.black.withValues(alpha: 0.04),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isOn
                        ? accent.withValues(alpha: 0.15)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isOn
                          ? accent.withValues(alpha: 0.35)
                          : Colors.transparent,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isOn ? accent : Colors.grey.shade400,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isOn ? Colors.black87 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isOn
                                  ? const Color(0xFF4CAF50)
                                  : Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              subtitle,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: isOn
                                    ? Colors.black54
                                    : Colors.grey.shade500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isOn,
                  activeThumbColor: Colors.white,
                  activeTrackColor: accent,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey.shade300,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
          if (slider != null)
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: slider,
            ),
        ],
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
        size: 130,
        customColors: CustomSliderColors(
          progressBarColor: color,
          shadowColor: color.withValues(alpha: 0.35),
          dotColor: color,
          trackColor: Colors.grey.shade300,
        ),
        infoProperties: InfoProperties(
          mainLabelStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
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
