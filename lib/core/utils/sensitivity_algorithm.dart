import '../../models/device_model.dart';
import '../../models/user_preferences.dart';
import '../../models/hud_layout.dart';
import '../../models/sensitivity_profile.dart';

class SensitivityAlgorithm {
  static SensitivityProfile generateRecommendation(
    DeviceModel device,
    UserPreferences prefs,
    HudLayout hud,
  ) {
    // Base sensitivity calculation based on device specs
    final baseSensitivity = _calculateBase(device, prefs);
    
    // Adjust for screen size and refresh rate
    final screenFactor = _screenFactor(device);
    final refreshFactor = _refreshFactor(device);
    final dpiFactor = _dpiFactor(device);
    final styleFactor = _styleFactor(prefs.playStyle);
    final fingerFactor = _fingerFactor(prefs.fingerCount);
    
    // Generate all scope values
    final general = _generateScopeValues(baseSensitivity, screenFactor, refreshFactor, dpiFactor, styleFactor, fingerFactor, 1.0);
    final redDot = _generateScopeValues(baseSensitivity, screenFactor, refreshFactor, dpiFactor, styleFactor, fingerFactor, 1.2);
    final scope2x = _generateScopeValues(baseSensitivity, screenFactor, refreshFactor, dpiFactor, styleFactor, fingerFactor, 0.9);
    final scope4x = _generateScopeValues(baseSensitivity, screenFactor, refreshFactor, dpiFactor, styleFactor, fingerFactor, 0.7);
    final sniperScope = _generateScopeValues(baseSensitivity, screenFactor, refreshFactor, dpiFactor, styleFactor, fingerFactor, 0.5);
    final freeLook = _generateScopeValues(baseSensitivity, screenFactor, refreshFactor, dpiFactor, styleFactor, fingerFactor, 0.8);

    // Graphics and FPS based on device capability
    final graphics = _recommendGraphics(device, prefs);
    final fps = _recommendFPS(device, prefs);

    return SensitivityProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Profile ${DateTime.now().toLocal()}',
      createdAt: DateTime.now(),
      general: general,
      redDot: redDot,
      scope2x: scope2x,
      scope4x: scope4x,
      sniperScope: sniperScope,
      freeLook: freeLook,
      graphicsSetting: graphics,
      fpsSetting: fps,
      deviceModel: device.model,
      playStyle: prefs.playStyle,
    );
  }

  static double _calculateBase(DeviceModel device, UserPreferences prefs) {
    // Real algorithm based on device capabilities
    double base = 50.0;
    base += (device.ramGB - 4) * 1.5;
    base += (device.refreshRate - 60) * 0.3;
    base += (device.screenSizeInches - 6) * 2.0;
    if (prefs.gyroscopeOn) base += 10.0;
    return base.clamp(30, 100);
  }

  static double _screenFactor(DeviceModel device) {
    return (device.screenSizeInches / 6.0).clamp(0.8, 1.5);
  }

  static double _refreshFactor(DeviceModel device) {
    return (device.refreshRate / 60.0).clamp(0.9, 1.8);
  }

  static double _dpiFactor(DeviceModel device) {
    return (device.dpi / 400).clamp(0.85, 1.4);
  }

  static double _styleFactor(String style) {
    switch (style) {
      case 'headshot': return 1.3;
      case 'rush': return 1.1;
      case 'balanced': return 1.0;
      case 'sniper': return 0.8;
      default: return 1.0;
    }
  }

  static double _fingerFactor(int fingers) {
    switch (fingers) {
      case 2: return 1.2;
      case 3: return 1.1;
      case 4: return 1.0;
      case 5: return 0.9;
      default: return 1.0;
    }
  }

  static Map<String, double> _generateScopeValues(
    double base,
    double screenFactor,
    double refreshFactor,
    double dpiFactor,
    double styleFactor,
    double fingerFactor,
    double scopeMultiplier,
  ) {
    final value = base * screenFactor * refreshFactor * dpiFactor * styleFactor * fingerFactor * scopeMultiplier;
    return {
      'x': (value * 0.8).clamp(10, 100),
      'y': (value * 0.7).clamp(10, 100),
      'ads': (value * 0.6).clamp(10, 100),
    };
  }

  static String _recommendGraphics(DeviceModel device, UserPreferences prefs) {
    if (device.ramGB >= 8 && device.refreshRate >= 90) return 'Ultra';
    if (device.ramGB >= 6) return 'HD';
    if (device.ramGB >= 4) return 'Balanced';
    return 'Smooth';
  }

  static int _recommendFPS(DeviceModel device, UserPreferences prefs) {
    if (device.refreshRate >= 120 && device.ramGB >= 8) return 120;
    if (device.refreshRate >= 90 && device.ramGB >= 6) return 90;
    if (device.refreshRate >= 60 && device.ramGB >= 4) return 60;
    return 30;
  }
}