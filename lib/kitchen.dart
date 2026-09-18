// KITCHEN PAGE
import 'package:flutter/material.dart';
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
        title: const Text(
          "Kitchen",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFFF7043)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
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
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
            child: Column(
              children: [
                // ── Device Stats Summary ──
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.monitor_heart_rounded,
                        color: Color(0xFFFFD54F),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${_countDevicesOn()} of 5 devices ON",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      _buildStatusDot(_light1On),
                      const SizedBox(width: 5),
                      _buildStatusDot(_light2On),
                      const SizedBox(width: 5),
                      _buildStatusDot(_fanOn),
                      const SizedBox(width: 5),
                      _buildStatusDot(_fridgeOn),
                      const SizedBox(width: 5),
                      _buildStatusDot(_ovenOn),
                    ],
                  ),
                ),
                // 🔆 Light 1
                _buildControlCard(
                  title: "Light 1",
                  subtitle: "Main ceiling light",
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
                  onChanged: (val) {
                    setState(() => _light1On = val);
                    _showSnack(
                      _light1On
                          ? "💡 Kitchen Light 1 ON"
                          : "💡 Kitchen Light 1 OFF",
                    );
                  },
                ),
                const SizedBox(height: 16),

                //  Light 2
                _buildControlCard(
                  title: "Light 2",
                  subtitle: "Counter spot lights",
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
                  onChanged: (val) {
                    setState(() => _light2On = val);
                    _showSnack(
                      _light2On
                          ? "💡 Kitchen Light 2 ON"
                          : "💡 Kitchen Light 2 OFF",
                    );
                  },
                ),
                const SizedBox(height: 16),
                //  Fan
                _buildControlCard(
                  title: "Fan",
                  subtitle: "Range hood",
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
                  onChanged: (val) {
                    setState(() => _fanOn = val);
                    _showSnack(_fanOn ? "🌀 Fan ON" : "🌀 Fan OFF");
                  },
                ),
                const SizedBox(height: 16),

                //  Fridge
                _buildControlCard(
                  title: "Fridge",
                  subtitle: "Refrigerator power",
                  icon: Icons.kitchen_rounded,
                  accent: const Color(0xFF26A69A),
                  isOn: _fridgeOn,
                  onChanged: (val) {
                    setState(() => _fridgeOn = val);
                    _showSnack(_fridgeOn ? "🧊 Fridge ON" : "🧊 Fridge OFF");
                  },
                ),
                const SizedBox(height: 16),

                //  Oven
                _buildControlCard(
                  title: "Oven",
                  subtitle: "Built-in oven",
                  icon: Icons.local_fire_department_rounded,
                  accent: const Color(0xFFE53935),
                  isOn: _ovenOn,
                  onChanged: (val) {
                    setState(() => _ovenOn = val);
                    _showSnack(_ovenOn ? "🔥 Oven ON" : "🔥 Oven OFF");
                  },
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

  int _countDevicesOn() {
    return [
      _light1On,
      _light2On,
      _fanOn,
      _fridgeOn,
      _ovenOn,
    ].where((on) => on).length;
  }

  Widget _buildStatusDot(bool isOn) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOn
            ? const Color(0xFF4CAF50)
            : Colors.white.withValues(alpha: 0.22),
        boxShadow: isOn
            ? [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.6),
                  blurRadius: 6,
                ),
              ]
            : null,
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
