// LIVINGROOM PAGE — 4 LEDs via Firebase RTDB
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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
