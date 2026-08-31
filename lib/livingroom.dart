// LIVINGROOM PAGE — 4 LEDs via Firebase RTDB + Voice Commands
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

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
  bool _isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speech.initialize(
      onError: (val) {
        setState(() => _isListening = false);
      },
    );
  }

  void _startListening() async {
    if (!_speech.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Speech recognition not available")),
      );
      return;
    }
    setState(() {
      _isListening = true;
      _lastWords = '';
    });
    await _speech.listen(onResult: _onSpeechResult);
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() => _lastWords = result.recognizedWords);
    if (result.finalResult) {
      _processVoiceCommand(result.recognizedWords.toLowerCase());
      setState(() => _isListening = false);
    }
  }

  void _processVoiceCommand(String command) {
    // --- ALL LIGHTS ---
    if (command.contains("all") &&
        (command.contains("on") || command.contains("open"))) {
      _toggleAll(true);
      _showSnack("Turning ON all lights");
      return;
    }
    if (command.contains("all") &&
        (command.contains("off") || command.contains("close"))) {
      _toggleAll(false);
      _showSnack("Turning OFF all lights");
      return;
    }

    // --- INDIVIDUAL LIGHTS (LED 1–4) ---
    final lights = [
      {"led": "led1", "names": ["led 1", "light 1", "light one", "led one", "first"], "index": 0},
      {"led": "led2", "names": ["led 2", "light 2", "light two", "led two", "second"], "index": 1},
      {"led": "led3", "names": ["led 3", "light 3", "light three", "led three", "third"], "index": 2},
      {"led": "led4", "names": ["led 4", "light 4", "light four", "led four", "fourth"], "index": 3},
    ];

    for (final light in lights) {
      for (final name in light["names"] as List<String>) {
        if (command.contains(name)) {
          if (command.contains("on") || command.contains("open")) {
            _toggleLed(light["led"] as String, light["index"] as int, true);
            _showSnack("Turning ON ${light["led"]}");
            return;
          }
          if (command.contains("off") || command.contains("close")) {
            _toggleLed(light["led"] as String, light["index"] as int, false);
            _showSnack("Turning OFF ${light["led"]}");
            return;
          }
        }
      }
    }

    // No matching command
    _showSnack("Command not recognized: \"$command\"");
  }

  void _toggleLed(String led, int index, bool state) {
    setState(() {
      switch (index) {
        case 0: _led1 = state; break;
        case 1: _led2 = state; break;
        case 2: _led3 = state; break;
        case 3: _led4 = state; break;
      }
    });
    _setLed(led, state);
  }

  void _toggleAll(bool state) {
    setState(() {
      _led1 = state;
      _led2 = state;
      _led3 = state;
      _led4 = state;
    });
    _setLed("led1", state);
    _setLed("led2", state);
    _setLed("led3", state);
    _setLed("led4", state);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.deepPurple,
      ),
    );
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
            color: Color.fromARGB(182, 3, 3, 9),
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 244, 82, 82),
        centerTitle: true,
        elevation: 6,
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
                  },
                ),
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
          FloatingActionButton(
            onPressed: _isListening ? _stopListening : _startListening,
            backgroundColor: _isListening
                ? Colors.red
                : const Color.fromARGB(255, 244, 82, 82),
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
              size: 28,
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isOn ? color.shade200 : Colors.grey.shade200,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isOn ? Icons.lightbulb : Icons.lightbulb_outline,
                  color: isOn ? color.shade800 : Colors.grey,
                  size: 36,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isOn ? Colors.black87 : Colors.black54,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isOn ? Colors.black54 : Colors.grey,
                      ),
                    ),
                  ],
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
}
