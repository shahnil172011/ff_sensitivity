import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF00D2FF).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF00D2FF).withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.games,
                size: 60,
                color: Color(0xFF00D2FF),
              ),
            ),
            const SizedBox(height: 20),
            
            // App name
            const Text(
              'FF Sensitivity AI',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'BETA',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            
            // Info cards
            _buildInfoCard(
              'Developer',
              '@UnknownGuy9876',
              Icons.person,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Community',
              '@SGCodexs',
              Icons.groups,
              Colors.purple,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Privacy Policy',
              'No data collected or stored',
              Icons.privacy_tip,
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Data Storage',
              'All data stored locally on device',
              Icons.storage,
              Colors.orange,
            ),
            
            const SizedBox(height: 30),
            
            // Description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2340),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF00D2FF).withOpacity(0.2),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📱 About This App',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00D2FF),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'FF Sensitivity AI provides smart sensitivity recommendations for Free Fire based on your device specifications, play style, and HUD layout. '
                    'The app uses transparent algorithms to generate optimal settings without modifying any game files.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '✨ Key Features:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• Device scan and detection\n'
                    '• HUD screenshot analysis\n'
                    '• AI-powered recommendations\n'
                    '• Profile saving and management\n'
                    '• Sensitivity tester with feedback\n'
                    '• Dark mode support',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => launchUrl(
                      Uri.parse('https://github.com/UnknownGuy9876/ff-sensitivity-ai'),
                    ),
                    icon: const Icon(Icons.code),
                    label: const Text('GitHub'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => launchUrl(
                      Uri.parse('https://discord.gg/SGCodexs'),
                    ),
                    icon: const Icon(Icons.discord),
                    label: const Text('Discord'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Footer
            Text(
              'Made with ❤️ for @SGCodexs community',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '© 2026 All Rights Reserved',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2340),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade800,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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