// BEDROOM2 PAGE
import 'package:flutter/material.dart';
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
        title: const Text(
          "Bedroom 2",
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
              colors: [Color(0xFF00897B), Color(0xFF4DB6AC)],
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
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("images/bedroom2.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.35),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          //  Foreground Controls
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
            child: Column(
              children: [
                // ── Quick Actions ──
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.bolt_rounded,
                            color: Color(0xFFFFD54F),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Quick Actions",
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
                              color: _countDevicesOn() > 0
                                  ? const Color(0xFF4DB6AC).withValues(alpha: 0.25)
                                  : Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _countDevicesOn() > 0
                                    ? const Color(0xFF4DB6AC).withValues(alpha: 0.6)
                                    : Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _countDevicesOn() > 0
                                        ? const Color(0xFF80CBC4)
                                        : Colors.white38,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${_countDevicesOn()}/3 Active",
                                  style: TextStyle(
                                    color: _countDevicesOn() > 0
                                        ? const Color(0xFFB2DFDB)
                                        : Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickButton(
                              label: "All On",
                              icon: Icons.power_settings_new_rounded,
                              color: const Color(0xFF4CAF50),
                              onTap: () {
                                setState(() {
                                  _lightOn = true;
                                  _fanOn = true;
                                  _acOn = true;
                                });
                                _showSnackBar("All devices turned ON");
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildQuickButton(
                              label: "Sleep",
                              icon: Icons.nightlight_round_rounded,
                              color: const Color(0xFF80CBC4),
                              onTap: () {
                                setState(() {
                                  _lightOn = false;
                                  _fanOn = true;
                                  _fanSpeed = 2;
                                  _acOn = true;
                                  _acTemp = 25;
                                });
                                _showSnackBar("Sleep Mode activated 🌙");
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildQuickButton(
                              label: "All Off",
                              icon: Icons.power_off_rounded,
                              color: const Color(0xFFEF5350),
                              onTap: () {
                                setState(() {
                                  _lightOn = false;
                                  _fanOn = false;
                                  _acOn = false;
                                });
                                _showSnackBar("All devices turned OFF");
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 🔆 Light Control
                _buildControlCard(
                  title: "Light",
                  subtitle: "Bedside lamp",
                  icon: Icons.lightbulb_rounded,
                  accent: const Color(0xFFFFB300),
                  isOn: _lightOn,
                  slider: _lightOn
                      ? SleekCircularSlider(
                          min: 0,
                          max: 100,
                          initialValue: _lightIntensity,
                          appearance: CircularSliderAppearance(
                            size: 130,
                            customColors: CustomSliderColors(
                              progressBarColor: const Color(0xFFFFB300),
                              shadowColor: const Color(0xFFFFB300)
                                  .withValues(alpha: 0.35),
                              dotColor: const Color(0xFFFFB300),
                              trackColor: Colors.grey.shade300,
                            ),
                            infoProperties: InfoProperties(
                              mainLabelStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              modifier: (val) => "${val.toInt()}%",
                            ),
                          ),
                          onChange: (val) {
                            setState(() => _lightIntensity = val);
                          },
                        )
                      : null,
                  onChanged: (value) {
                    setState(() => _lightOn = value);
                    _showSnackBar(
                      _lightOn ? "💡 Light turned ON" : "💡 Light turned OFF",
                    );
                  },
                ),

                const SizedBox(height: 16),

                //  Fan Control
                _buildControlCard(
                  title: "Fan",
                  subtitle: "Air circulator",
                  icon: Icons.mode_fan_off_rounded,
                  accent: const Color(0xFF1E88E5),
                  isOn: _fanOn,
                  slider: _fanOn
                      ? SleekCircularSlider(
                          min: 0,
                          max: 5,
                          initialValue: _fanSpeed,
                          appearance: CircularSliderAppearance(
                            size: 130,
                            customColors: CustomSliderColors(
                              progressBarColor: const Color(0xFF1E88E5),
                              shadowColor: const Color(0xFF1E88E5)
                                  .withValues(alpha: 0.35),
                              dotColor: const Color(0xFF1E88E5),
                              trackColor: Colors.grey.shade300,
                            ),
                            infoProperties: InfoProperties(
                              mainLabelStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              modifier: (val) => "Lv ${val.toInt()}",
                            ),
                          ),
                          onChange: (val) {
                            setState(() => _fanSpeed = val);
                          },
                        )
                      : null,
                  onChanged: (value) {
                    setState(() => _fanOn = value);
                    _showSnackBar(
                      _fanOn ? "🌀 Fan turned ON" : "🌀 Fan turned OFF",
                    );
                  },
                ),

                const SizedBox(height: 16),

                // AC Control
                _buildControlCard(
                  title: "Air Conditioner",
                  subtitle: "Climate control",
                  icon: Icons.ac_unit_rounded,
                  accent: const Color(0xFF00ACC1),
                  isOn: _acOn,
                  slider: _acOn
                      ? SleekCircularSlider(
                          min: 16,
                          max: 30,
                          initialValue: _acTemp,
                          appearance: CircularSliderAppearance(
                            size: 130,
                            customColors: CustomSliderColors(
                              progressBarColor: const Color(0xFF00ACC1),
                              shadowColor: const Color(0xFF00ACC1)
                                  .withValues(alpha: 0.35),
                              dotColor: const Color(0xFF00ACC1),
                              trackColor: Colors.grey.shade300,
                            ),
                            infoProperties: InfoProperties(
                              mainLabelStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              modifier: (val) => "${val.toInt()}°C",
                            ),
                          ),
                          onChange: (val) {
                            setState(() => _acTemp = val);
                          },
                        )
                      : null,
                  onChanged: (value) {
                    setState(() => _acOn = value);
                    _showSnackBar(
                      _acOn ? "❄️ AC turned ON" : "❄️ AC turned OFF",
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

  /// Active devices counter
  int _countDevicesOn() {
    int count = 0;
    if (_lightOn) count++;
    if (_fanOn) count++;
    if (_acOn) count++;
    return count;
  }

  /// Quick Action Button helper
  Widget _buildQuickButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.45),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
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

