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

  // LED index lookup table for instant, unambiguous matching
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
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 244, 82, 82),
        centerTitle: true,
        elevation: 6,
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
                  Colors.black.withOpacity(0.25),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.record_voice_over,
                          color: Color(0xFFFFD54F), size: 20),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          "Tap the mic and say: \"Turn on light 1\"",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
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
            scale: _isListening ? 1.12 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: _isListening ? const EdgeInsets.all(6) : EdgeInsets.zero,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening
                    ? Colors.red.withValues(alpha: 0.35)
                    : Colors.transparent,
              ),
              child: FloatingActionButton(
                tooltip: _isListening ? 'Stop listening' : 'Voice control',
                onPressed: _isListening ? _stopListening : _startListening,
                backgroundColor: _isListening
                    ? Colors.redAccent
                    : const Color.fromARGB(255, 244, 82, 82),
                elevation: 8,
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 28,
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
    final accent = isOn ? Color(color.shade600.value) : Colors.grey;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isOn
                ? color.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isOn
              ? color.withValues(alpha: 0.45)
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
}
