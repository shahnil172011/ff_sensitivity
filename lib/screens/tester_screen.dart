import 'package:flutter/material.dart';
import '../models/sensitivity_profile.dart';
import '../providers/profile_provider.dart';
import 'package:provider/provider.dart';

class TesterScreen extends StatefulWidget {
  final SensitivityProfile profile;
  const TesterScreen({super.key, required this.profile});

  @override
  State<TesterScreen> createState() => _TesterScreenState();
}

class _TesterScreenState extends State<TesterScreen> {
  final Map<String, bool> _feedback = {
    'aimUp': false,
    'aimDown': false,
    'recoilHard': false,
    'headshots': false,
  };

  void _submitFeedback() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    // Adjust recommendations based on feedback
    final adjusted = _adjustSensitivity(widget.profile);
    provider.saveProfile(adjusted);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback recorded! Profile updated.'), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  SensitivityProfile _adjustSensitivity(SensitivityProfile profile) {
    // Real adjustment logic
    final factor = _feedback['aimUp'] == true ? 1.1 : _feedback['aimDown'] == true ? 0.9 : 1.0;
    final adj = (v) => (v * factor).clamp(10, 100);
    
    return SensitivityProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '${profile.name} (Adjusted)',
      createdAt: DateTime.now(),
      general: _adjustMap(profile.general, adj),
      redDot: _adjustMap(profile.redDot, adj),
      scope2x: _adjustMap(profile.scope2x, adj),
      scope4x: _adjustMap(profile.scope4x, adj),
      sniperScope: _adjustMap(profile.sniperScope, adj),
      freeLook: _adjustMap(profile.freeLook, adj),
      graphicsSetting: profile.graphicsSetting,
      fpsSetting: profile.fpsSetting,
      deviceModel: profile.deviceModel,
      playStyle: profile.playStyle,
    );
  }

  Map<String, double> _adjustMap(Map<String, double> map, double Function(double) adjust) {
    return map.map((k, v) => MapEntry(k, adjust(v)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sensitivity Tester')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('How does this feel?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            _buildCheckbox('Aim going up?', 'aimUp'),
            _buildCheckbox('Aim going down?', 'aimDown'),
            _buildCheckbox('Recoil difficult?', 'recoilHard'),
            _buildCheckbox('Headshots consistent?', 'headshots'),
            const Spacer(),
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D2FF),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Submit & Update', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title, String key) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      value: _feedback[key] ?? false,
      onChanged: (val) => setState(() => _feedback[key] = val ?? false),
      activeColor: const Color(0xFF00D2FF),
    );
  }
}