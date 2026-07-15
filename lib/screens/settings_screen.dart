import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/history_provider.dart';
import '../providers/profile_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Appearance section
          const Text(
            'Appearance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00D2FF),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Enable dark theme'),
              value: settings.isDarkMode,
              onChanged: (_) => settings.toggleDarkMode(),
              activeColor: const Color(0xFF00D2FF),
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D2FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: const Color(0xFF00D2FF),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Language section
          const Text(
            'Language',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00D2FF),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('App Language'),
              subtitle: Text(
                settings.language.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00D2FF),
                ),
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D2FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.language,
                  color: Color(0xFF00D2FF),
                ),
              ),
              onTap: () => _showLanguageDialog(context, settings),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Data section
          const Text(
            'Data Management',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Clear History'),
                  subtitle: const Text('Remove all history entries'),
                  leading: const Icon(Icons.history_off, color: Colors.orange),
                  onTap: () {
                    _showConfirmDialog(
                      context,
                      'Clear History',
                      'This will delete all history entries. Continue?',
                      () {
                        historyProvider.clearHistory();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('History cleared'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text(
                    'Reset All Data',
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text(
                    'Delete all profiles and history',
                    style: TextStyle(color: Colors.red),
                  ),
                  leading: const Icon(Icons.reset_settings, color: Colors.red),
                  onTap: () {
                    _showConfirmDialog(
                      context,
                      'Reset All Data',
                      'This will delete all profiles and history. This action cannot be undone.',
                      () {
                        settings.resetAppData();
                        historyProvider.clearHistory();
                        // Clear profiles
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All data reset'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // About section
          Card(
            child: ListTile(
              title: const Text('App Version'),
              subtitle: const Text('1.0.0'),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D2FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF00D2FF),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: const Color(0xFF141B2D),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Divider(color: Colors.grey),
              ListTile(
                title: const Text('English', style: TextStyle(color: Colors.white)),
                leading: settings.language == 'en'
                    ? const Icon(Icons.check_circle, color: Color(0xFF00D2FF))
                    : null,
                onTap: () {
                  settings.setLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Spanish', style: TextStyle(color: Colors.white)),
                leading: settings.language == 'es'
                    ? const Icon(Icons.check_circle, color: Color(0xFF00D2FF))
                    : null,
                onTap: () {
                  settings.setLanguage('es');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Hindi', style: TextStyle(color: Colors.white)),
                leading: settings.language == 'hi'
                    ? const Icon(Icons.check_circle, color: Color(0xFF00D2FF))
                    : null,
                onTap: () {
                  settings.setLanguage('hi');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showConfirmDialog(BuildContext context, String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              style: TextButton.styleFrom(
                foregroundColor: title.contains('Reset') ? Colors.red : Colors.orange,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}