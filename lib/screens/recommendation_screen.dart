import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:clipboard/clipboard.dart';
import '../models/device_model.dart';
import '../models/user_preferences.dart';
import '../models/hud_layout.dart';
import '../models/sensitivity_profile.dart';
import '../core/utils/sensitivity_algorithm.dart';
import '../providers/profile_provider.dart';
import '../widgets/sensitivity_card.dart';
import 'tester_screen.dart';

class RecommendationScreen extends StatefulWidget {
  final DeviceModel device;
  final UserPreferences preferences;
  final HudLayout hudLayout;
  
  const RecommendationScreen({
    super.key,
    required this.device,
    required this.preferences,
    required this.hudLayout,
  });

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  SensitivityProfile? _profile;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _profile = SensitivityAlgorithm.generateRecommendation(
      widget.device,
      widget.preferences,
      widget.hudLayout,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final profile = _profile!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Recommendations'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copySensitivity,
            tooltip: 'Copy',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareSensitivity,
            tooltip: 'Share',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfo('Device', widget.device.model),
                    _buildInfo('Style', widget.preferences.playStyle.toUpperCase()),
                    _buildInfo('Fingers', '${widget.preferences.fingerCount}'),
                    _buildInfo('Graphics', profile.graphicsSetting),
                    _buildInfo('FPS', '${profile.fpsSetting}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Sensitivity cards
            SensitivityCard(title: 'General', values: profile.general),
            SensitivityCard(title: 'Red Dot', values: profile.redDot),
            SensitivityCard(title: '2X Scope', values: profile.scope2x),
            SensitivityCard(title: '4X Scope', values: profile.scope4x),
            SensitivityCard(title: 'Sniper Scope', values: profile.sniperScope),
            SensitivityCard(title: 'Free Look', values: profile.freeLook),
            
            const SizedBox(height: 30),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saving ? null : _saveProfile,
                    icon: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(_saving ? 'Saving...' : 'Save Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TesterScreen(profile: profile),
                        ),
                      );
                    },
                    icon: const Icon(Icons.thumb_up),
                    label: const Text('Test It'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D2FF),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_profile == null) return;
    setState(() => _saving = true);
    
    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await provider.saveProfile(_profile!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Profile saved!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Save failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _copySensitivity() {
    if (_profile == null) return;
    final text = _formatSensitivity(_profile!);
    FlutterClipboard.copy(text).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📋 Copied to clipboard!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }).catchError((e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Failed to copy'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void _shareSensitivity() {
    if (_profile == null) return;
    final text = _formatSensitivity(_profile!);
    Share.share(text, subject: 'FF Sensitivity AI Recommendations');
  }

  String _formatSensitivity(SensitivityProfile p) {
    return '''
FF SENSITIVITY AI - RECOMMENDATIONS
-----------------------------------
Device: ${widget.device.model}
Style: ${widget.preferences.playStyle}
Fingers: ${widget.preferences.fingerCount}
Graphics: ${p.graphicsSetting}
FPS: ${p.fpsSetting}

GENERAL: X=${p.general['x']?.toStringAsFixed(1)} Y=${p.general['y']?.toStringAsFixed(1)} ADS=${p.general['ads']?.toStringAsFixed(1)}
RED DOT: X=${p.redDot['x']?.toStringAsFixed(1)} Y=${p.redDot['y']?.toStringAsFixed(1)} ADS=${p.redDot['ads']?.toStringAsFixed(1)}
2X: X=${p.scope2x['x']?.toStringAsFixed(1)} Y=${p.scope2x['y']?.toStringAsFixed(1)} ADS=${p.scope2x['ads']?.toStringAsFixed(1)}
4X: X=${p.scope4x['x']?.toStringAsFixed(1)} Y=${p.scope4x['y']?.toStringAsFixed(1)} ADS=${p.scope4x['ads']?.toStringAsFixed(1)}
SNIPER: X=${p.sniperScope['x']?.toStringAsFixed(1)} Y=${p.sniperScope['y']?.toStringAsFixed(1)} ADS=${p.sniperScope['ads']?.toStringAsFixed(1)}
FREE LOOK: X=${p.freeLook['x']?.toStringAsFixed(1)} Y=${p.freeLook['y']?.toStringAsFixed(1)} ADS=${p.freeLook['ads']?.toStringAsFixed(1)}
''';
  }
}          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfo('Device', widget.device.model),
                    _buildInfo('Style', widget.preferences.playStyle.toUpperCase()),
                    _buildInfo('Fingers', '${widget.preferences.fingerCount}'),
                    _buildInfo('Graphics', profile.graphicsSetting),
                    _buildInfo('FPS', '${profile.fpsSetting}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SensitivityCard(title: 'General', values: profile.general),
            SensitivityCard(title: 'Red Dot', values: profile.redDot),
            SensitivityCard(title: '2X Scope', values: profile.scope2x),
            SensitivityCard(title: '4X Scope', values: profile.scope4x),
            SensitivityCard(title: 'Sniper Scope', values: profile.sniperScope),
            SensitivityCard(title: 'Free Look', values: profile.freeLook),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TesterScreen(profile: profile),
                        ),
                      );
                    },
                    icon: const Icon(Icons.thumb_up),
                    label: const Text('Test It'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D2FF),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _saveProfile() async {
    if (_profile == null) return;
    setState(() => _saving = true);
    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await provider.saveProfile(_profile!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _saving = false);
    }
  }

  void _copySensitivity() {
    if (_profile == null) return;
    final text = _formatSensitivity(_profile!);
    FlutterClipboard.copy(text).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard!'), backgroundColor: Colors.green),
      );
    });
  }

  void _shareSensitivity() {
    if (_profile == null) return;
    final text = _formatSensitivity(_profile!);
    Share.share(text, subject: 'FF Sensitivity AI Recommendations');
  }

  String _formatSensitivity(SensitivityProfile p) {
    return '''
FF SENSITIVITY AI - RECOMMENDATIONS
-----------------------------------
Device: ${widget.device.model}
Style: ${widget.preferences.playStyle}
Fingers: ${widget.preferences.fingerCount}
Graphics: ${p.graphicsSetting}
FPS: ${p.fpsSetting}

GENERAL: X=${p.general['x']?.toStringAsFixed(1)} Y=${p.general['y']?.toStringAsFixed(1)} ADS=${p.general['ads']?.toStringAsFixed(1)}
RED DOT: X=${p.redDot['x']?.toStringAsFixed(1)} Y=${p.redDot['y']?.toStringAsFixed(1)} ADS=${p.redDot['ads']?.toStringAsFixed(1)}
2X: X=${p.scope2x['x']?.toStringAsFixed(1)} Y=${p.scope2x['y']?.toStringAsFixed(1)} ADS=${p.scope2x['ads']?.toStringAsFixed(1)}
4X: X=${p.scope4x['x']?.toStringAsFixed(1)} Y=${p.scope4x['y']?.toStringAsFixed(1)} ADS=${p.scope4x['ads']?.toStringAsFixed(1)}
SNIPER: X=${p.sniperScope['x']?.toStringAsFixed(1)} Y=${p.sniperScope['y']?.toStringAsFixed(1)} ADS=${p.sniperScope['ads']?.toStringAsFixed(1)}
FREE LOOK: X=${p.freeLook['x']?.toStringAsFixed(1)} Y=${p.freeLook['y']?.toStringAsFixed(1)} ADS=${p.freeLook['ads']?.toStringAsFixed(1)}
''';
  }
}
