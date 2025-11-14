// LIVINGROOM PAGE
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class LivingRoomPage extends StatefulWidget {
  const LivingRoomPage({super.key});

  @override
  State<LivingRoomPage> createState() => _LivingRoomPageState();
}

class _LivingRoomPageState extends State<LivingRoomPage> {
  bool _lightOn = false;
  bool _fanOn = false;

  double _lightIntensity = 50; // Light intensity %
  double _fanSpeed = 2; // Fan speed level (0–5)

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
          // Background Image
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

          // Controls
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Light Control Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                  shadowColor: Colors.black.withOpacity(0.3),
                  margin: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _lightOn
                          ? Colors.yellow.shade200
                          : Colors.grey.shade200,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _lightOn
                                      ? Icons.lightbulb
                                      : Icons.lightbulb_outline,
                                  color: _lightOn
                                      ? Colors.yellow.shade800
                                      : Colors.grey,
                                  size: 36,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Light",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: _lightOn
                                        ? Colors.black87
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _lightOn,
                              activeColor: Colors.deepPurple,
                              onChanged: (value) {
                                setState(() {
                                  _lightOn = value;
                                });
                              },
                            ),
                          ],
                        ),

                        // Light intensity knob
                        if (_lightOn) ...[
                          const SizedBox(height: 12),
                          Text("Intensity: ${_lightIntensity.toInt()}%"),
                          const SizedBox(height: 8),
                          SleekCircularSlider(
                            min: 0,
                            max: 100,
                            initialValue: _lightIntensity,
                            appearance: CircularSliderAppearance(
                              size: 120,
                              customColors: CustomSliderColors(
                                progressBarColor: Colors.yellow.shade700,
                                trackColor: Colors.yellow.shade100,
                                dotColor: Colors.orange,
                              ),
                              customWidths: CustomSliderWidths(
                                progressBarWidth: 8,
                                trackWidth: 4,
                                handlerSize: 12,
                              ),
                            ),
                            onChange: (val) {
                              setState(() {
                                _lightIntensity = val;
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Fan Control Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                  shadowColor: Colors.black.withOpacity(0.3),
                  margin: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _fanOn
                          ? Colors.blue.shade200
                          : Colors.grey.shade200,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.fan,
                                  color: _fanOn
                                      ? Colors.blue.shade700
                                      : Colors.grey,
                                  size: 36,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Fan",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: _fanOn
                                        ? Colors.black87
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _fanOn,
                              activeColor: Colors.deepPurple,
                              onChanged: (value) {
                                setState(() {
                                  _fanOn = value;
                                });
                              },
                            ),
                          ],
                        ),

                        // Fan speed knob
                        if (_fanOn) ...[
                          const SizedBox(height: 12),
                          Text("Speed: ${_fanSpeed.toInt()}"),
                          const SizedBox(height: 8),
                          SleekCircularSlider(
                            min: 0,
                            max: 5,
                            initialValue: _fanSpeed,
                            appearance: CircularSliderAppearance(
                              size: 120,
                              customColors: CustomSliderColors(
                                progressBarColor: Colors.blue.shade700,
                                trackColor: Colors.blue.shade100,
                                dotColor: Colors.blueAccent,
                              ),
                              infoProperties: InfoProperties(
                                modifier: (val) => val.toStringAsFixed(0),
                              ),
                            ),
                            onChange: (val) {
                              setState(() {
                                _fanSpeed = val;
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
