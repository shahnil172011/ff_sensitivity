import 'dart:io';
import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../models/user_preferences.dart';
import '../models/hud_layout.dart';
import '../services/image_analysis_service.dart';
import 'recommendation_screen.dart';

class HudAnalysisScreen extends StatefulWidget {
  final DeviceModel device;
  final UserPreferences preferences;
  final File hudImage;
  
  const HudAnalysisScreen({
    super.key,
    required this.device,
    required this.preferences,
    required this.hudImage,
  });

  @override
  State<HudAnalysisScreen> createState() => _HudAnalysisScreenState();
}

class _HudAnalysisScreenState extends State<HudAnalysisScreen> {
  bool _analyzing = true;
  HudLayout? _hudLayout;
  Map<String, double>? _detectedPositions;

  @override
  void initState() {
    super.initState();
    _analyzeHUD();
  }

  Future<void> _analyzeHUD() async {
    if (!mounted) return;
    setState(() => _analyzing = true);
    
    try {
      final layout = await ImageAnalysisService.analyzeHUD(widget.hudImage);
      if (mounted) {
        setState(() {
          _hudLayout = layout;
          _analyzing = false;
          _detectedPositions = layout.toMap();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _analyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analysis failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HUD Analysis'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (_analyzing) ...[
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D2FF)),
                      ),
                      SizedBox(height: 20),
                      Text('Analyzing HUD layout...', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ] else if (_hudLayout != null && _detectedPositions != null) ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: FileImage(widget.hudImage),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Detected Layout',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildPositionTile('Fire Button', _detectedPositions!['fireButtonX'] ?? 0.0, _detectedPositions!['fireButtonY'] ?? 0.0),
                      _buildPositionTile('Joystick', _detectedPositions!['joystickX'] ?? 0.0, _detectedPositions!['joystickY'] ?? 0.0),
                      _buildPositionTile('Scope Button', _detectedPositions!['scopeX'] ?? 0.0, _detectedPositions!['scopeY'] ?? 0.0),
                      _buildPositionTile('Jump', _detectedPositions!['jumpX'] ?? 0.0, _detectedPositions!['jumpY'] ?? 0.0),
                      _buildPositionTile('Crouch', _detectedPositions!['crouchX'] ?? 0.0, _detectedPositions!['crouchY'] ?? 0.0),
                      _buildPositionTile('Prone', _detectedPositions!['proneX'] ?? 0.0, _detectedPositions!['proneY'] ?? 0.0),
                      _buildPositionTile('Weapon Switch', _detectedPositions!['weaponSwitchX'] ?? 0.0, _detectedPositions!['weaponSwitchY'] ?? 0.0),
                      _buildPositionTile('Utility', _detectedPositions!['utilityX'] ?? 0.0, _detectedPositions!['utilityY'] ?? 0.0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecommendationScreen(
                          device: widget.device,
                          preferences: widget.preferences,
                          hudLayout: _hudLayout!,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D2FF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Get Recommendations',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ] else ...[
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60, color: Colors.red),
                      SizedBox(height: 16),
                      Text('Analysis failed. Please try again.'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPositionTile(String label, double x, double y) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('X: ${x.toStringAsFixed(2)}  Y: ${y.toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}              const Text('Analyzing HUD layout...', style: TextStyle(fontSize: 16)),
            ] else if (_hudLayout != null) ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: FileImage(widget.hudImage),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Detected Layout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _buildPositionTile('Fire Button', _detectedPositions!['fireButtonX']!, _detectedPositions!['fireButtonY']!),
                      _buildPositionTile('Joystick', _detectedPositions!['joystickX']!, _detectedPositions!['joystickY']!),
                      _buildPositionTile('Scope Button', _detectedPositions!['scopeX']!, _detectedPositions!['scopeY']!),
                      _buildPositionTile('Jump', _detectedPositions!['jumpX']!, _detectedPositions!['jumpY']!),
                      _buildPositionTile('Crouch', _detectedPositions!['crouchX']!, _detectedPositions!['crouchY']!),
                      _buildPositionTile('Prone', _detectedPositions!['proneX']!, _detectedPositions!['proneY']!),
                      _buildPositionTile('Weapon Switch', _detectedPositions!['weaponSwitchX']!, _detectedPositions!['weaponSwitchY']!),
                      _buildPositionTile('Utility', _detectedPositions!['utilityX']!, _detectedPositions!['utilityY']!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecommendationScreen(
                        device: widget.device,
                        preferences: widget.preferences,
                        hudLayout: _hudLayout!,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D2FF),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Get Recommendations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPositionTile(String label, double x, double y) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('X: ${x.toStringAsFixed(2)}  Y: ${y.toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
