import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'hud_upload_screen.dart';
import 'profiles_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FF Sensitivity AI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Welcome header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00D2FF), Color(0xFF3A7BD5)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.games,
                      color: Color(0xFF0A0E1A),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to FF Sensitivity AI',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Get your perfect sensitivity settings',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildMenuCard(
                    context,
                    'Start Scan',
                    Icons.scanner,
                    const Color(0xFF00D2FF),
                    'Detect device specs',
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanScreen())),
                  ),
                  _buildMenuCard(
                    context,
                    'Upload HUD',
                    Icons.upload_file,
                    const Color(0xFFFF6B6B),
                    'Analyze your layout',
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HudUploadScreen(device: null, preferences: null))),
                  ),
                  _buildMenuCard(
                    context,
                    'Saved Profiles',
                    Icons.save_alt,
                    const Color(0xFF00E676),
                    'View saved settings',
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilesScreen())),
                  ),
                  _buildMenuCard(
                    context,
                    'History',
                    Icons.history,
                    const Color(0xFFFFD600),
                    'Past recommendations',
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                  ),
                  _buildMenuCard(
                    context,
                    'Settings',
                    Icons.settings,
                    const Color(0xFF9C27B0),
                    'Customize app',
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                  ),
                  _buildMenuCard(
                    context,
                    'About',
                    Icons.info,
                    const Color(0xFF00BCD4),
                    'App information',
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 36, color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade400,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}