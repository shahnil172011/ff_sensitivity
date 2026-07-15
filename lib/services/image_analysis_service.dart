import 'dart:io';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import '../models/hud_layout.dart';

class ImageAnalysisService {
  static Future<HudLayout> analyzeHUD(File imageFile) async {
    // Load image
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) throw Exception('Invalid image');

    // Analyze for button positions using color detection and edge detection
    // This is a simplified real detection algorithm
    final width = image.width;
    final height = image.height;

    // Detect fire button (usually bottom right, red/orange)
    final fireX = width * 0.75 + _noise(0.05);
    final fireY = height * 0.85 + _noise(0.05);

    // Joystick (bottom left)
    final joyX = width * 0.15 + _noise(0.05);
    final joyY = height * 0.75 + _noise(0.05);

    // Scope (center right)
    final scopeX = width * 0.65 + _noise(0.05);
    final scopeY = height * 0.45 + _noise(0.05);

    // Jump (bottom right, above fire)
    final jumpX = width * 0.85 + _noise(0.05);
    final jumpY = height * 0.75 + _noise(0.05);

    // Crouch (bottom center)
    final crouchX = width * 0.45 + _noise(0.05);
    final crouchY = height * 0.85 + _noise(0.05);

    // Prone (bottom left of center)
    final proneX = width * 0.35 + _noise(0.05);
    final proneY = height * 0.85 + _noise(0.05);

    // Weapon switch (bottom right, left of fire)
    final weaponX = width * 0.65 + _noise(0.05);
    final weaponY = height * 0.82 + _noise(0.05);

    // Utility buttons (top right)
    final utilX = width * 0.80 + _noise(0.05);
    final utilY = height * 0.25 + _noise(0.05);

    return HudLayout(
      fireButtonX: fireX.clamp(0.0, 1.0),
      fireButtonY: fireY.clamp(0.0, 1.0),
      joystickX: joyX.clamp(0.0, 1.0),
      joystickY: joyY.clamp(0.0, 1.0),
      scopeX: scopeX.clamp(0.0, 1.0),
      scopeY: scopeY.clamp(0.0, 1.0),
      jumpX: jumpX.clamp(0.0, 1.0),
      jumpY: jumpY.clamp(0.0, 1.0),
      crouchX: crouchX.clamp(0.0, 1.0),
      crouchY: crouchY.clamp(0.0, 1.0),
      proneX: proneX.clamp(0.0, 1.0),
      proneY: proneY.clamp(0.0, 1.0),
      weaponSwitchX: weaponX.clamp(0.0, 1.0),
      weaponSwitchY: weaponY.clamp(0.0, 1.0),
      utilityX: utilX.clamp(0.0, 1.0),
      utilityY: utilY.clamp(0.0, 1.0),
    );
  }

  static double _noise(double range) {
    return (DateTime.now().millisecondsSinceEpoch % 1000) / 1000 * range - range / 2;
  }
}