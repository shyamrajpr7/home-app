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
  bool _autoSchedule = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Outside Lights",
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
              colors: [Color(0xFF0288D1), Color(0xFF00BCD4)],
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
                image: AssetImage("images/outside.jpeg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.35),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Outside Lights
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
            child: Column(
              children: [
                // ── Lights On Count & Quick Actions ──
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
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
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD54F).withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.light_mode_rounded,
                              color: Color(0xFFFFD54F),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "${_countLightsOn()} of 4 lights on",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _buildStatusDot(_gateLightOn),
                          const SizedBox(width: 5),
                          _buildStatusDot(_gardenLightOn),
                          const SizedBox(width: 5),
                          _buildStatusDot(_garageLightOn),
                          const SizedBox(width: 5),
                          _buildStatusDot(_balconyLightOn),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _gateLightOn = true;
                                  _gardenLightOn = true;
                                  _garageLightOn = true;
                                  _balconyLightOn = true;
                                });
                                _showSnack("💡 All Outside Lights ON");
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50).withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF4CAF50).withValues(alpha: 0.45),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.power_settings_new_rounded,
                                        size: 15, color: Color(0xFF81C784)),
                                    SizedBox(width: 6),
                                    Text(
                                      "Turn All On",
                                      style: TextStyle(
                                        color: Color(0xFF81C784),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _gateLightOn = false;
                                  _gardenLightOn = false;
                                  _garageLightOn = false;
                                  _balconyLightOn = false;
                                });
                                _showSnack("💡 All Outside Lights OFF");
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.power_off_rounded,
                                        size: 15, color: Color(0xFFE57373)),
                                    SizedBox(width: 6),
                                    Text(
                                      "Turn All Off",
                                      style: TextStyle(
                                        color: Color(0xFFE57373),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Dusk-to-Dawn Smart Schedule Card ──
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _autoSchedule
                          ? const Color(0xFF00BCD4).withValues(alpha: 0.4)
                          : Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _autoSchedule
                              ? const Color(0xFF00BCD4).withValues(alpha: 0.25)
                              : Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _autoSchedule
                              ? Icons.nightlight_round
                              : Icons.schedule_outlined,
                          color: _autoSchedule
                              ? const Color(0xFF80DEEA)
                              : Colors.white70,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Dusk-to-Dawn Auto Schedule",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _autoSchedule
                                  ? "Active • 6:30 PM to 6:00 AM"
                                  : "Disabled • Manual control only",
                              style: TextStyle(
                                color: _autoSchedule
                                    ? const Color(0xFF80DEEA)
                                    : Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _autoSchedule,
                        activeThumbColor: Colors.white,
                        activeTrackColor: const Color(0xFF00BCD4),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.white24,
                        onChanged: (val) {
                          setState(() => _autoSchedule = val);
                          _showSnack(
                            val
                                ? "🌙 Dusk-to-Dawn schedule activated"
                                : "⚙️ Dusk-to-Dawn schedule deactivated",
                          );
                        },
                      ),
                    ],
                  ),
                ),
                _buildControlCard(
                  title: "Gate Light",
                  subtitle: "Main entrance",
                  icon: Icons.doorbell_rounded,
                  accent: const Color(0xFFFF8F00),
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
                  subtitle: "Garden path & lawn",
                  icon: Icons.yard_rounded,
                  accent: const Color(0xFF43A047),
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
                  subtitle: "Garage bay",
                  icon: Icons.directions_car_filled_rounded,
                  accent: const Color(0xFF1E88E5),
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
                  subtitle: "Terrace accent",
                  icon: Icons.park_rounded,
                  accent: const Color(0xFF8E24AA),
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
    required String subtitle,
    required IconData icon,
    required Color accent,
    required bool isOn,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isOn
                ? accent.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isOn
              ? accent.withValues(alpha: 0.45)
              : Colors.black.withValues(alpha: 0.04),
          width: 1.5,
        ),
      ),
      child: Padding(
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
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isOn ? Colors.black87 : Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isOn
                              ? accent.withValues(alpha: 0.15)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isOn
                                ? accent.withValues(alpha: 0.4)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          isOn ? "ON" : "OFF",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: isOn ? accent : Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
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
    );
  }

  int _countLightsOn() {
    return [
      _gateLightOn,
      _gardenLightOn,
      _garageLightOn,
      _balconyLightOn,
    ].where((on) => on).length;
  }

  Widget _buildStatusDot(bool isOn) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOn ? const Color(0xFF4CAF50) : Colors.white.withValues(alpha: 0.22),
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
