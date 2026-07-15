import 'package:flutter/material.dart';

class SensitivityCard extends StatelessWidget {
  final String title;
  final Map<String, double> values;

  const SensitivityCard({super.key, required this.title, required this.values});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00D2FF)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildValue('X', values['x'] ?? 0),
                _buildValue('Y', values['y'] ?? 0),
                _buildValue('ADS', values['ads'] ?? 0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValue(String label, double value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}