import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../models/user_preferences.dart';
import 'hud_upload_screen.dart';

class QuestionsScreen extends StatefulWidget {
  final DeviceModel device;
  const QuestionsScreen({super.key, required this.device});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  bool _gyroscope = false;
  int _fingers = 4;
  String _playStyle = 'balanced';
  int _fps = 60;
  String _graphics = 'balanced';

  final List<String> _playStyles = ['headshot', 'rush', 'balanced', 'sniper'];
  final List<String> _graphicsOptions = ['smooth', 'balanced', 'hd', 'ultra'];
  final List<int> _fpsOptions = [30, 60, 90, 120];

  @override
  void initState() {
    super.initState();
    // Auto-detect optimal settings based on device
    _setDefaultPreferences();
  }

  void _setDefaultPreferences() {
    // Set FPS based on refresh rate
    if (widget.device.refreshRate >= 120) {
      _fps = 120;
    } else if (widget.device.refreshRate >= 90) {
      _fps = 90;
    } else if (widget.device.refreshRate >= 60) {
      _fps = 60;
    } else {
      _fps = 30;
    }

    // Set graphics based on RAM
    if (widget.device.ramGB >= 8) {
      _graphics = 'ultra';
    } else if (widget.device.ramGB >= 6) {
      _graphics = 'hd';
    } else if (widget.device.ramGB >= 4) {
      _graphics = 'balanced';
    } else {
      _graphics = 'smooth';
    }

    // Enable gyroscope if device supports high refresh rate
    if (widget.device.refreshRate >= 90) {
      _gyroscope = true;
    }

    // Set fingers based on screen size
    if (widget.device.screenSizeInches >= 6.5) {
      _fingers = 4;
    } else if (widget.device.screenSizeInches >= 5.5) {
      _fingers = 3;
    } else {
      _fingers = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Preferences'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device info summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2340),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF00D2FF).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_android, color: Color(0xFF00D2FF)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.device.model,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${widget.device.ramGB}GB RAM • ${widget.device.refreshRate}Hz • ${widget.device.screenSizeInches}"',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Auto-detected',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Gyroscope
              _buildSwitch(
                'Gyroscope',
                _gyroscope,
                (val) => setState(() => _gyroscope = val),
                subtitle: 'Enable for better aim control',
              ),
              const Divider(),
              
              // Finger count
              _buildFingerSelector(),
              const Divider(),
              
              // Play Style
              _buildDropdown(
                'Play Style',
                _playStyles,
                _playStyle,
                (val) => setState(() => _playStyle = val!),
                icon: Icons.games,
              ),
              const Divider(),
              
              // Graphics
              _buildDropdown(
                'Graphics Preference',
                _graphicsOptions,
                _graphics,
                (val) => setState(() => _graphics = val!),
                icon: Icons.settings_overscan,
              ),
              const Divider(),
              
              // FPS
              _buildFPSSelector(),
              
              const SizedBox(height: 30),
              
              // Next button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final prefs = UserPreferences(
                      gyroscopeOn: _gyroscope,
                      fingerCount: _fingers,
                      playStyle: _playStyle,
                      fpsPreference: _fps,
                      graphicsPreference: _graphics,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HudUploadScreen(
                          device: widget.device,
                          preferences: prefs,
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Progress indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProgressDot(true),
                  _buildProgressDot(false),
                  _buildProgressDot(false),
                  _buildProgressDot(false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressDot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? const Color(0xFF00D2FF) : Colors.grey.shade600,
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged, {String? subtitle}) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)) : null,
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF00D2FF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF00D2FF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          value ? Icons.graphic_eq : Icons.graphic_eq_outlined,
          color: value ? const Color(0xFF00D2FF) : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildFingerSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Finger Count', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(
            'How many fingers do you use?',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 12),
          Row(
            children: [2, 3, 4, 5].map((int count) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(
                      '$count',
                      style: TextStyle(
                        color: _fingers == count ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: _fingers == count,
                    onSelected: (_) => setState(() => _fingers = count),
                    selectedColor: const Color(0xFF00D2FF),
                    backgroundColor: const Color(0xFF1A2340),
                    side: BorderSide(
                      color: _fingers == count ? const Color(0xFF00D2FF) : Colors.grey.shade600,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
          Text(
            _getFingerDescription(_fingers),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade400,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  String _getFingerDescription(int fingers) {
    switch (fingers) {
      case 2: return 'Basic control, good for beginners';
      case 3: return 'Balanced control and speed';
      case 4: return 'Advanced control, pro-level';
      case 5: return 'Maximum control, claw grip';
      default: return '';
    }
  }

  Widget _buildDropdown(String label, List<String> items, String value, Function(String?) onChanged, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A2340),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade700),
            ),
            child: DropdownButtonFormField<String>(
              value: value,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18, color: const Color(0xFF00D2FF)),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        item.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              dropdownColor: const Color(0xFF1A2340),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: const Icon(Icons.arrow_drop_down, color: Color(0xFF00D2FF)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getStyleDescription(value),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade400,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  String _getStyleDescription(String style) {
    switch (style) {
      case 'headshot': return 'Focus on precision aiming';
      case 'rush': return 'Fast-paced aggressive play';
      case 'balanced': return 'All-rounder playstyle';
      case 'sniper': return 'Long-range precision';
      default: return '';
    }
  }

  Widget _buildFPSSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('FPS Preference', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(
            'Higher FPS = smoother gameplay',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 12),
          Row(
            children: _fpsOptions.map((int val) {
              final bool available = val <= widget.device.refreshRate;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(
                      '$val',
                      style: TextStyle(
                        color: _fps == val ? Colors.black : (available ? Colors.white : Colors.grey.shade500),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: _fps == val,
                    onSelected: available ? (_) => setState(() => _fps = val) : null,
                    selectedColor: const Color(0xFF00D2FF),
                    backgroundColor: const Color(0xFF1A2340),
                    side: BorderSide(
                      color: _fps == val ? const Color(0xFF00D2FF) : (available ? Colors.grey.shade600 : Colors.grey.shade800),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledColor: Colors.grey.shade800,
                  ),
                ),
              );
            }).toList(),
          ),
          if (_fps > widget.device.refreshRate)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                '⚠️ Your device supports ${widget.device.refreshRate}Hz max',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.orange.shade400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}