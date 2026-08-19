// SETTINGS PAGE — Professional UI + ESP32 Integration + Working Dark/Light Mode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/forgotpassword.dart';
import 'profile.dart';
import 'main.dart';

// ─────────────────────────────────────────────
// THEME NOTIFIER — controls app-wide dark mode
// ─────────────────────────────────────────────
class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggle(bool value) {
    _isDark = value;
    notifyListeners();
  }
}

// Single global instance shared across pages
final themeNotifier = ThemeNotifier();

// ─────────────────────────────────────────────
// SETTINGS PAGE
// ─────────────────────────────────────────────
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  bool notifications = true;
  bool wifiControl = false;
  bool _espConnected = false;

  late AnimationController _animController;

  // ===================== ESP32 CONFIG =====================
  final String espIp = "10.138.225.30"; // ← Replace with your ESP32 IP

  Future<void> sendEsp(String endpoint) async {
    try {
      final response = await http
          .get(Uri.parse('http://$espIp/$endpoint'))
          .timeout(const Duration(seconds: 3));
      debugPrint("ESP32 [$endpoint]: ${response.statusCode}");
      if (mounted) setState(() => _espConnected = true);
    } catch (e) {
      debugPrint("ESP32 Error [$endpoint]: $e");
      if (mounted) {
        setState(() => _espConnected = false);
        _showSnack("ESP32 unreachable", isError: true);
      }
    }
  }

  Future<void> _checkEspConnection() async {
    try {
      await http
          .get(Uri.parse('http://$espIp/STATUS'))
          .timeout(const Duration(seconds: 2));
      if (mounted) setState(() => _espConnected = true);
    } catch (_) {
      if (mounted) setState(() => _espConnected = false);
    }
  }
  // ========================================================

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _checkEspConnection();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeNotifier,
      builder: (context, _) {
        final isDark = themeNotifier.isDark;
        final bg = isDark ? const Color(0xFF0F0F1A) : const Color(0xFFF2F4F8);
        final cardBg = isDark ? const Color(0xFF1C1C2E) : Colors.white;
        final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A2E);
        final textSecondary = isDark ? Colors.white54 : const Color(0xFF7A7A9D);
        final accent = const Color(0xFF6C63FF);
        final divColor = isDark
            ? Colors.white12
            : Colors.black.withOpacity(0.07);

        return Scaffold(
          backgroundColor: bg,
          body: CustomScrollView(
            slivers: [
              // ── HEADER ──────────────────────────────────
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                backgroundColor: isDark
                    ? const Color(0xFF1C1C2E)
                    : const Color(0xFF6C63FF),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF2D2B55), const Color(0xFF1C1C2E)]
                            : [
                                const Color(0xFF6C63FF),
                                const Color(0xFF4A90D9),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Decorative circles
                        Positioned(
                          right: -30,
                          top: -30,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.07),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 40,
                          bottom: -20,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                        ),
                        // Title content
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 80, 24, 20),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.settings_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Settings",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    "Manage your preferences",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.75),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── BODY ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ESP32 Connection Status Badge
                      _EspStatusBadge(connected: _espConnected, isDark: isDark),
                      const SizedBox(height: 20),

                      // ── SECTION: ACCOUNT ──────────────
                      _SectionLabel(label: "Account", isDark: isDark),
                      const SizedBox(height: 10),
                      _SettingsCard(
                        isDark: isDark,
                        cardBg: cardBg,
                        child: _NavTile(
                          icon: Icons.person_rounded,
                          iconBg: const Color(0xFF4A90D9),
                          title: "Profile",
                          subtitle: "Edit your personal information",
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfilePage(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── SECTION: APPEARANCE ───────────
                      _SectionLabel(label: "Appearance", isDark: isDark),
                      const SizedBox(height: 10),
                      _SettingsCard(
                        isDark: isDark,
                        cardBg: cardBg,
                        child: _SwitchTile(
                          icon: isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          iconBg: isDark
                              ? const Color(0xFF4A3F8F)
                              : const Color(0xFFFFA726),
                          title: "Dark Mode",
                          subtitle: isDark
                              ? "Dark theme active"
                              : "Light theme active",
                          value: isDark,
                          activeColor: accent,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          divColor: divColor,
                          onChanged: (val) {
                            themeNotifier.toggle(val);
                            // Optionally notify ESP32
                            sendEsp(val ? "DARK_ON" : "DARK_OFF");
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── SECTION: SYSTEM ───────────────
                      _SectionLabel(label: "System", isDark: isDark),
                      const SizedBox(height: 10),
                      _SettingsCard(
                        isDark: isDark,
                        cardBg: cardBg,
                        child: Column(
                          children: [
                            _SwitchTile(
                              icon: Icons.notifications_rounded,
                              iconBg: const Color(0xFFFF7043),
                              title: "Notifications",
                              subtitle: notifications
                                  ? "Push alerts enabled"
                                  : "Alerts silenced",
                              value: notifications,
                              activeColor: accent,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              divColor: divColor,
                              showDivider: true,
                              onChanged: (val) {
                                setState(() => notifications = val);
                                sendEsp(val ? "NOTIF_ON" : "NOTIF_OFF");
                                _showSnack(
                                  val
                                      ? "Notifications enabled"
                                      : "Notifications disabled",
                                );
                              },
                            ),
                            _SwitchTile(
                              icon: Icons.wifi_rounded,
                              iconBg: const Color(0xFF26A69A),
                              title: "WiFi Control",
                              subtitle: wifiControl
                                  ? "Remote control active"
                                  : "Local control only",
                              value: wifiControl,
                              activeColor: accent,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              divColor: divColor,
                              onChanged: (val) {
                                setState(() => wifiControl = val);
                                sendEsp(val ? "WIFI_ON" : "WIFI_OFF");
                                _showSnack(
                                  val
                                      ? "WiFi control enabled"
                                      : "WiFi control disabled",
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── SECTION: ESP32 CONTROLS ───────
                      _SectionLabel(label: "ESP32 Controls", isDark: isDark),
                      const SizedBox(height: 10),
                      _SettingsCard(
                        isDark: isDark,
                        cardBg: cardBg,
                        child: Column(
                          children: [
                            _NavTile(
                              icon: Icons.restart_alt_rounded,
                              iconBg: const Color(0xFFAB47BC),
                              title: "Restart ESP32",
                              subtitle: "Reboot all connected modules",
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              showDivider: true,
                              onTap: () async {
                                final confirm = await _showConfirmDialog(
                                  "Restart ESP32?",
                                  "All devices will briefly disconnect.",
                                  isDark,
                                );
                                if (confirm == true) {
                                  sendEsp("RESTART");
                                  _showSnack("Restarting ESP32...");
                                }
                              },
                            ),
                            _NavTile(
                              icon: Icons.power_settings_new_rounded,
                              iconBg: Colors.red.shade600,
                              title: "All Devices OFF",
                              subtitle: "Turn off every connected device",
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              onTap: () async {
                                final confirm = await _showConfirmDialog(
                                  "Turn everything off?",
                                  "All lights and appliances will be switched off.",
                                  isDark,
                                );
                                if (confirm == true) {
                                  sendEsp("ALL_OFF");
                                  _showSnack("All devices turned OFF");
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── SECTION: ABOUT ────────────────
                      _SectionLabel(label: "About", isDark: isDark),
                      const SizedBox(height: 10),
                      _SettingsCard(
                        isDark: isDark,
                        cardBg: cardBg,
                        child: Column(
                          children: [
                            _InfoTile(
                              icon: Icons.info_outline_rounded,
                              iconBg: const Color(0xFF42A5F5),
                              title: "App Version",
                              value: "v1.0.0",
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              showDivider: true,
                            ),
                            _InfoTile(
                              icon: Icons.router_rounded,
                              iconBg: const Color(0xFF66BB6A),
                              title: "ESP32 IP",
                              value: espIp,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── LOGOUT BUTTON ─────────────────
                      _LogoutButton(
                        isDark: isDark,
                        onTap: () async {
                          final confirm = await _showConfirmDialog(
                            "Logout?",
                            "You will be returned to the login screen.",
                            isDark,
                          );
                          if (confirm == true) {
                            sendEsp("LOGOUT");
                            if (mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                                (route) => false,
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> _showConfirmDialog(String title, String message, bool isDark) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1C1C2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REUSABLE WIDGETS
// ─────────────────────────────────────────────

class _EspStatusBadge extends StatelessWidget {
  final bool connected;
  final bool isDark;
  const _EspStatusBadge({required this.connected, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: connected
            ? Colors.green.withOpacity(isDark ? 0.15 : 0.1)
            : Colors.red.withOpacity(isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: connected
              ? Colors.green.withOpacity(0.4)
              : Colors.red.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: connected ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            connected ? "ESP32 Connected" : "ESP32 Offline",
            style: TextStyle(
              color: connected ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: isDark ? Colors.white38 : Colors.black38,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final Color cardBg;
  const _SettingsCard({
    required this.child,
    required this.isDark,
    required this.cardBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(18), child: child),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool value;
  final Color activeColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color divColor;
  final bool showDivider;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.activeColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.divColor,
    this.showDivider = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBg.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconBg, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: activeColor,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: divColor, indent: 72, endIndent: 16),
      ],
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final Color textPrimary;
  final Color textSecondary;
  final bool showDivider;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.textPrimary,
    required this.textSecondary,
    this.showDivider = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconBg.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconBg, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(color: textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: Colors.black.withOpacity(0.07),
            indent: 72,
            endIndent: 16,
          ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String value;
  final Color textPrimary;
  final Color textSecondary;
  final bool showDivider;

  const _InfoTile({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.value,
    required this.textPrimary,
    required this.textSecondary,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBg.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconBg, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: Colors.black.withOpacity(0.07),
            indent: 72,
            endIndent: 16,
          ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDark;
  const _LogoutButton({required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.logout_rounded, color: Colors.white),
        label: const Text(
          "Logout",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
