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
        title: const Text(
          "Dining Room",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF8F00), Color(0xFFFFB300)],
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
                image: const AssetImage("images/dining.jpeg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.35),
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
                // ── Lights Summary & Ambience Scenes ──
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.restaurant_rounded,
                            color: Color(0xFFFFD54F),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Dining Ambience",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _countLightsOn() > 0
                                  ? const Color(0xFFFF8F00).withValues(alpha: 0.28)
                                  : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _countLightsOn() > 0
                                    ? const Color(0xFFFF8F00).withValues(alpha: 0.6)
                                    : Colors.white24,
                              ),
                            ),
                            child: Text(
                              "${_countLightsOn()}/3 Lights • Fan ${_fanOn ? 'ON' : 'OFF'}",
                              style: TextStyle(
                                color: _countLightsOn() > 0
                                    ? const Color(0xFFFFE082)
                                    : Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSceneButton(
                              label: "Dinner",
                              icon: Icons.wine_bar_rounded,
                              color: const Color(0xFFFF8F00),
                              onTap: () {
                                setState(() {
                                  _light1On = true;
                                  _light1Intensity = 45;
                                  _light2On = true;
                                  _light2Intensity = 65;
                                  _light3On = false;
                                  _fanOn = true;
                                  _fanSpeed = 2;
                                });
                                _showSnackBar("Dinner Ambience set 🍷");
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildSceneButton(
                              label: "Cozy",
                              icon: Icons.local_cafe_rounded,
                              color: const Color(0xFFFFB300),
                              onTap: () {
                                setState(() {
                                  _light1On = true;
                                  _light1Intensity = 30;
                                  _light2On = true;
                                  _light2Intensity = 30;
                                  _light3On = true;
                                  _light3Intensity = 30;
                                  _fanOn = false;
                                });
                                _showSnackBar("Cozy Ambient Mode activated ☕");
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildSceneButton(
                              label: "Bright",
                              icon: Icons.wb_sunny_rounded,
                              color: const Color(0xFF66BB6A),
                              onTap: () {
                                setState(() {
                                  _light1On = true;
                                  _light1Intensity = 90;
                                  _light2On = true;
                                  _light2Intensity = 90;
                                  _light3On = true;
                                  _light3Intensity = 90;
                                  _fanOn = true;
                                  _fanSpeed = 3;
                                });
                                _showSnackBar("Bright Mode enabled ☀️");
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildSceneButton(
                              label: "All Off",
                              icon: Icons.power_off_rounded,
                              color: const Color(0xFFEF5350),
                              onTap: () {
                                setState(() {
                                  _light1On = false;
                                  _light2On = false;
                                  _light3On = false;
                                  _fanOn = false;
                                });
                                _showSnackBar("All dining devices turned OFF");
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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

  int _countLightsOn() {
    return [_light1On, _light2On, _light3On].where((on) => on).length;
  }

  /// Scene preset action button
  Widget _buildSceneButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.45),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
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

