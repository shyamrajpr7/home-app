// BEDROOM1 PAGE with Background Image + Rotating Controls
import 'package:flutter/material.dart';
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
          // Background Image
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

          // Foreground (Cards)
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
            child: Column(
              children: [
                // Light
                _buildControlCard(
                  title: "Light",
                  subtitle: "Ceiling lamp",
                  icon: Icons.lightbulb_rounded,
                  accent: const Color(0xFFFFB300),
                  isOn: _lightOn,
                  onChanged: (value) {
                    setState(() => _lightOn = value);
                    _showSnackBar(
                      _lightOn ? "💡 Light turned ON" : "💡 Light turned OFF",
                    );
                  },
                  extraWidget: _lightOn
                      ? _buildCircularSlider(
                          min: 0,
                          max: 100,
                          value: _lightIntensity,
                          label: "Intensity",
                          unit: "%",
                          color: const Color(0xFFFFB300),
                          onChange: (val) =>
                              setState(() => _lightIntensity = val),
                        )
                      : null,
                ),
                const SizedBox(height: 16),

                // Fan
                _buildControlCard(
                  title: "Fan",
                  subtitle: "Ceiling fan",
                  icon: Icons.mode_fan_off_rounded,
                  accent: const Color(0xFF1E88E5),
                  isOn: _fanOn,
                  onChanged: (value) {
                    setState(() => _fanOn = value);
                    _showSnackBar(
                      _fanOn ? "🌀 Fan turned ON" : "🌀 Fan turned OFF",
                    );
                  },
                  extraWidget: _fanOn
                      ? _buildCircularSlider(
                          min: 0,
                          max: 5,
                          value: _fanSpeed,
                          label: "Speed",
                          unit: "lvl",
                          color: const Color(0xFF1E88E5),
                          onChange: (val) => setState(() => _fanSpeed = val),
                        )
                      : null,
                ),
                const SizedBox(height: 16),

                // AC
                _buildControlCard(
                  title: "Air Conditioner",
                  subtitle: "Cooling & heating",
                  icon: Icons.ac_unit_rounded,
                  accent: const Color(0xFF00ACC1),
                  isOn: _acOn,
                  onChanged: (value) {
                    setState(() => _acOn = value);
                    _showSnackBar(
                      _acOn ? "❄️ AC turned ON" : "❄️ AC turned OFF",
                    );
                  },
                  extraWidget: _acOn
                      ? _buildCircularSlider(
                          min: 16,
                          max: 30,
                          value: _acTemp,
                          label: "Temp",
                          unit: "°C",
                          color: const Color(0xFF00ACC1),
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
    required String subtitle,
    required IconData icon,
    required Color accent,
    required bool isOn,
    required Function(bool) onChanged,
    Widget? extraWidget,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
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
                // Icon badge
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
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: isOn
                                  ? Colors.black54
                                  : Colors.grey.shade500,
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
          if (extraWidget != null) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: extraWidget,
            ),
          ],
        ],
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
    required Color color,
    required Function(double) onChange,
  }) {
    return SleekCircularSlider(
      min: min,
      max: max,
      initialValue: value,
      appearance: CircularSliderAppearance(
        size: 130,
        customWidths: CustomSliderWidths(progressBarWidth: 12, trackWidth: 6),
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
          modifier: (val) => "${val.toInt()} $unit",
          topLabelText: label,
          topLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
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
