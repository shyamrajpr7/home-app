// LIVINGROOM PAGE — 4 LEDs via Firebase RTDB + Voice Commands
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LivingRoomPage extends StatefulWidget {
  const LivingRoomPage({super.key});

  @override
  State<LivingRoomPage> createState() => _LivingRoomPageState();
}

class _LivingRoomPageState extends State<LivingRoomPage> {
  bool _led1 = false;
  bool _led2 = false;
  bool _led3 = false;
  bool _led4 = false;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("/leds");
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  bool _speechReady = false;
  bool _ttsReady = false;
  String _lastWords = '';

  String _audioScene = "Cinema";
  static const Map<String, int> _ledIndex = {
    "led 1": 0, "led one": 0, "light 1": 0, "light one": 0, "first": 0,
    "led 2": 1, "led two": 1, "light 2": 1, "light two": 1, "second": 1,
    "led 3": 2, "led three": 2, "light 3": 2, "light three": 2, "third": 2,
    "led 4": 3, "led four": 3, "light 4": 3, "light four": 3, "fourth": 3,
  };
  static const List<String> _ledNames = ["led1", "led2", "led3", "led4"];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage("en-US");
      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _ttsReady = true;
    } catch (_) {}
  }

  void _speak(String text) {
    if (!_ttsReady) return;
    _tts.stop();
    _tts.speak(text);
  }

  Future<void> _initSpeech() async {
    _speechReady = await _speech.initialize(
      onError: (val) {
        if (mounted) setState(() => _isListening = false);
      },
    );
  }

  void _startListening() async {
    if (!_speechReady || !_speech.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Speech recognition not available")),
      );
      return;
    }
    setState(() {
      _isListening = true;
      _lastWords = '';
    });
    _speech.listen(
      onResult: _onSpeechResult,
      listenMode: ListenMode.confirmation,
      pauseFor: const Duration(seconds: 1),
    );
  }

  void _stopListening() async {
    await _speech.stop();
    if (mounted) setState(() => _isListening = false);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    final text = result.recognizedWords;
    if (mounted) setState(() => _lastWords = text);
    if (result.finalResult) {
      _handleCommand(text);
      if (mounted) setState(() => _isListening = false);
    }
  }

  // Parse a spoken command into "which light" + "on/off".
  // Returns immediately once a clear action is found.
  void _handleCommand(String command) {
    final t = command.toLowerCase().trim();

    // Determine desired state from clear keywords only.
    bool off = t.contains("off") || t.contains("close") ||
        t.contains(" switch off");
    bool on = t.contains(" on ") || t.contains(" on.") ||
        t.contains(" on,") || t.endsWith(" on") || t.contains("open") ||
        t.contains("switch on") || t.contains("turn on");

    // If neither detected, default based on presence of "on/off" anywhere.
    if (!on && !off) {
      on = t.contains(" on") && !t.contains(" off");
      off = t.contains("off");
    }

    // --- ALL LIGHTS ---
    if (t.contains("all")) {
      if (off) {
        _toggleAll(false);
        _voicesay("All lights off");
      } else {
        _toggleAll(true);
        _voicesay("All lights on");
      }
      return;
    }

    // --- INDIVIDUAL LIGHTS ---
    int idx = -1;
    for (final n in _ledIndex.keys) {
      if (t.contains(n)) {
        idx = _ledIndex[n] as int;
        break;
      }
    }

    if (idx >= 0) {
      final led = _ledNames[idx];
      if (off) {
        _toggleLed(idx, false);
        _voicesay("$led off");
      } else {
        _toggleLed(idx, true);
        _voicesay("$led on");
      }
      return;
    }

    // No actionable command
    _voicesay("Sorry, I didn't catch that");
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(milliseconds: 1500),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _voicesay(String msg) {
    _speak(msg);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.deepPurple,
        ),
      );
  }

  void _toggleLed(int index, bool state) {
    setState(() {
      switch (index) {
        case 0: _led1 = state; break;
        case 1: _led2 = state; break;
        case 2: _led3 = state; break;
        case 3: _led4 = state; break;
      }
    });
    // write only the changed LED — one fast round-trip
    _dbRef.child(_ledNames[index]).set(state);
  }

  void _toggleAll(bool state) {
    setState(() {
      _led1 = state;
      _led2 = state;
      _led3 = state;
      _led4 = state;
    });
    // single atomic update for all LEDS — faster than 4 separate writes
    _dbRef.update({"led1": state, "led2": state, "led3": state, "led4": state});
  }

  Future<void> _setLed(String led, bool state) async {
    try {
      await _dbRef.child(led).set(state);
    } catch (e) {
      print("Error setting $led: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Living Room",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF4A90D9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/living.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.25),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // ── Status & Quick Actions Bar ──
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.42),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C63FF).withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              color: Color(0xFFFFD54F),
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "${[_led1, _led2, _led3, _led4].where((e) => e).length}/4 Active",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _led1 = true;
                            _led2 = true;
                            _led3 = true;
                            _led4 = true;
                          });
                          for (final k in _ledNames) {
                            _setLed(k, true);
                          }
                          _toast("All Living Room lights ON");
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50).withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF4CAF50).withValues(alpha: 0.45),
                            ),
                          ),
                          child: const Text(
                            "All ON",
                            style: TextStyle(
                              color: Color(0xFF81C784),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _led1 = false;
                            _led2 = false;
                            _led3 = false;
                            _led4 = false;
                          });
                          for (final k in _ledNames) {
                            _setLed(k, false);
                          }
                          _toast("All Living Room lights OFF");
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.4),
                            ),
                          ),
                          child: const Text(
                            "All OFF",
                            style: TextStyle(
                              color: Color(0xFFE57373),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Ambience Scenes Preset Selector ──
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.38),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2, bottom: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.palette_rounded,
                              color: Color(0xFFB388FF),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "Ambience Presets",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildScenePill(
                              label: "Cinema Night",
                              icon: Icons.movie_filter_rounded,
                              accent: const Color(0xFFAB47BC),
                              onTap: () {
                                _applyScene(
                                  l1: false,
                                  l2: false,
                                  l3: false,
                                  l4: true,
                                  name: "🎬 Cinema Night",
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            _buildScenePill(
                              label: "Party Glow",
                              icon: Icons.celebration_rounded,
                              accent: const Color(0xFF29B6F6),
                              onTap: () {
                                _applyScene(
                                  l1: false,
                                  l2: true,
                                  l3: false,
                                  l4: true,
                                  name: "🎉 Party Glow",
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            _buildScenePill(
                              label: "Cozy Warm",
                              icon: Icons.local_fire_department_rounded,
                              accent: const Color(0xFFFFB74D),
                              onTap: () {
                                _applyScene(
                                  l1: true,
                                  l2: false,
                                  l3: true,
                                  l4: false,
                                  name: "🕯️ Cozy Warm",
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            _buildScenePill(
                              label: "Focus Study",
                              icon: Icons.menu_book_rounded,
                              accent: const Color(0xFF66BB6A),
                              onTap: () {
                                _applyScene(
                                  l1: true,
                                  l2: true,
                                  l3: true,
                                  l4: false,
                                  name: "📖 Focus Study",
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                _buildLedCard(
                  title: "LED 1",
                  subtitle: "D1 — Pin 5",
                  isOn: _led1,
                  color: Colors.yellow,
                  onChanged: (val) {
                    setState(() => _led1 = val);
                    _setLed("led1", val);
                    _toast("LED 1 ${val ? 'on' : 'off'}");
                  },
                ),
                const SizedBox(height: 16),
                _buildLedCard(
                  title: "LED 2",
                  subtitle: "D2 — Pin 4",
                  isOn: _led2,
                  color: Colors.blue,
                  onChanged: (val) {
                    setState(() => _led2 = val);
                    _setLed("led2", val);
                    _toast("LED 2 ${val ? 'on' : 'off'}");
                  },
                ),
                const SizedBox(height: 16),
                _buildLedCard(
                  title: "LED 3",
                  subtitle: "D5 — Pin 14",
                  isOn: _led3,
                  color: Colors.green,
                  onChanged: (val) {
                    setState(() => _led3 = val);
                    _setLed("led3", val);
                    _toast("LED 3 ${val ? 'on' : 'off'}");
                  },
                ),
                const SizedBox(height: 16),
                _buildLedCard(
                  title: "LED 4",
                  subtitle: "D6 — Pin 12",
                  isOn: _led4,
                  color: Colors.deepPurple,
                  onChanged: (val) {
                    setState(() => _led4 = val);
                    _setLed("led4", val);
                    _toast("LED 4 ${val ? 'on' : 'off'}");
                  },
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.55),
                        const Color(0xFFE53935).withValues(alpha: 0.18),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE53935).withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.record_voice_over,
                              color: Color(0xFFFFD54F), size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Voice Control Active",
                            style: TextStyle(
                              color: Color(0xFFFFD54F),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "\"Turn on light 1\" · \"All lights off\"",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // ── Acoustics & Home Theater Mode Card ──
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.42),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.surround_sound_rounded,
                              color: Color(0xFF9E95FF),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Acoustics & Ambience Mode",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Dolby Atmos & Spatial EQ Sync",
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Hi-Res 96kHz",
                              style: TextStyle(
                                color: Color(0xFF81C784),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildAudioPresetChip("Cinema", Icons.movie_filter_rounded, const Color(0xFFE53935)),
                            const SizedBox(width: 8),
                            _buildAudioPresetChip("Lounge", Icons.nightlife_rounded, const Color(0xFFFFB300)),
                            const SizedBox(width: 8),
                            _buildAudioPresetChip("Gaming", Icons.sports_esports_rounded, const Color(0xFF00E676)),
                            const SizedBox(width: 8),
                            _buildAudioPresetChip("Late Night", Icons.bedtime_rounded, const Color(0xFF42A5F5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_lastWords.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "\"$_lastWords\"",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          AnimatedScale(
            scale: _isListening ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: _isListening ? const EdgeInsets.all(8) : EdgeInsets.zero,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: _isListening
                    ? [
                        BoxShadow(
                          color: Colors.redAccent.withValues(alpha: 0.55),
                          blurRadius: 28,
                          spreadRadius: 6,
                        )
                      ]
                    : [],
                color: Colors.transparent,
              ),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: _isListening
                        ? [Colors.redAccent, Colors.deepOrange]
                        : [const Color(0xFFE53935), const Color(0xFFFF6F00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: IconButton(
                  tooltip: _isListening ? 'Stop listening' : 'Voice control',
                  onPressed: _isListening ? _stopListening : _startListening,
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLedCard({
    required String title,
    required String subtitle,
    required bool isOn,
    required MaterialColor color,
    required Function(bool) onChanged,
  }) {
    final accent = isOn ? color[600] ?? color : Colors.grey;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: isOn
            ? color.withValues(alpha: 0.13)
            : Colors.black.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isOn
                ? color.withValues(alpha: 0.35)
                : Colors.black.withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isOn
              ? color.withValues(alpha: 0.55)
              : Colors.white.withValues(alpha: 0.12),
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
                    ? color.withValues(alpha: 0.18)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isOn ? color.withValues(alpha: 0.4) : Colors.transparent,
                ),
              ),
              child: Icon(
                isOn ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
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
                          color: isOn ? Colors.white : Colors.white70,
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
                              ? color.withValues(alpha: 0.25)
                              : Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isOn
                                ? color.withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          isOn ? "ON" : "OFF",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: isOn ? color[300] ?? Colors.white : Colors.white38,
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
                          color: isOn ? accent : Colors.grey.shade400,
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
                                ? Colors.white60
                                : Colors.white38,
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
              activeTrackColor: color.shade300,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade300,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScenePill({
    required String label,
    required IconData icon,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: accent.withValues(alpha: 0.5),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: accent, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudioPresetChip(String name, IconData icon, Color accent) {
    final bool isSelected = _audioScene == name;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _audioScene = name;
          });
          _toast("Acoustics set to $name Preset");
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? accent.withValues(alpha: 0.28)
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? accent : Colors.white24,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? accent : Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                name,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _applyScene({
    required bool l1,
    required bool l2,
    required bool l3,
    required bool l4,
    required String name,
  }) {
    setState(() {
      _led1 = l1;
      _led2 = l2;
      _led3 = l3;
      _led4 = l4;
    });
    _dbRef.update({
      "led1": l1,
      "led2": l2,
      "led3": l3,
      "led4": l4,
    });
    _toast("$name activated");
  }
}

