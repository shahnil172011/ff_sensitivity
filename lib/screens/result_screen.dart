import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultScreen extends StatelessWidget {
  final bool gyroscope;
  final String playStyle;
  final String fingers;

  const ResultScreen({
    super.key,
    required this.gyroscope,
    required this.playStyle,
    required this.fingers,
  });

  Map<String, int> generateSensitivity() {
    int general = 180;
    int redDot = 170;
    int scope2x = 160;
    int scope4x = 145;
    int sniper = 100;
    int freeLook = 70;

    switch (playStyle) {
      case "Headshot":
        general = 200;
        redDot = 195;
        scope2x = 180;
        scope4x = 165;
        sniper = 100;
        freeLook = 75;
        break;

      case "Rush":
        general = 195;
        redDot = 185;
        scope2x = 170;
        scope4x = 155;
        sniper = 95;
        freeLook = 75;
        break;

      case "Sniper":
        general = 150;
        redDot = 140;
        scope2x = 120;
        scope4x = 110;
        sniper = 70;
        freeLook = 60;
        break;
    }

    if (!gyroscope) {
      general -= 10;
      redDot -= 10;
    }

    return {
      "General": general,
      "Red Dot": redDot,
      "2X Scope": scope2x,
      "4X Scope": scope4x,
      "Sniper Scope": sniper,
      "Free Look": freeLook,
    };
  }

  @override
  Widget build(BuildContext context) {
    final sensi = generateSensitivity();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("AI Result"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Recommended Sensitivity",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: sensi.entries.map((e) {
                  return Card(
                    color: Colors.white10,
                    child: ListTile(
                      title: Text(
                        e.key,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        e.value.toString(),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            ElevatedButton.icon(
              onPressed: () {
                String text = "";

                sensi.forEach((k, v) {
                  text += "$k : $v\n";
                });

                Clipboard.setData(ClipboardData(text: text));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Sensitivity Copied"),
                  ),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text("COPY SETTINGS"),
            ),
          ],
        ),
      ),
    );
  }
}