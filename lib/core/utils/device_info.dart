import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:screen/screen.dart';
import 'package:battery_plus/battery_plus.dart';
import '../../models/device_model.dart';

class DeviceInfoUtil {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static final Battery _battery = Battery();

  static Future<DeviceModel> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      final ram = androidInfo.totalRam ?? 0;
      final ramGB = (ram / (1024 * 1024 * 1024)).round();
      
      final screenWidth = Screen.width;
      final screenHeight = Screen.height;
      final screenSize = Screen.diagonalInches ?? 6.5;
      final dpi = Screen.density ?? 2.0;
      final refreshRate = Screen.refreshRate ?? 60.0;

      return DeviceModel(
        brand: androidInfo.brand,
        model: androidInfo.model,
        androidVersion: androidInfo.version.release,
        ramGB: ramGB,
        processor: androidInfo.hardware ?? 'Unknown',
        gpu: androidInfo.supportedAbis.isNotEmpty ? androidInfo.supportedAbis[0] : 'Unknown',
        batteryPercent: await _getBatteryLevel(),
        storageGB: await _getStorageGB(),
        screenResolution: '${screenWidth.round()}x${screenHeight.round()}',
        screenSizeInches: screenSize,
        refreshRate: refreshRate,
        dpi: dpi * 160,
      );
    }
    throw Exception('Only Android supported');
  }

  static Future<int> _getBatteryLevel() async {
    try {
      return await _battery.batteryLevel;
    } catch (e) {
      return 75; // Fallback
    }
  }

  static Future<int> _getStorageGB() async {
    try {
      final dir = await Directory('/storage/emulated/0').stat();
      final totalBytes = dir.size;
      return (totalBytes / (1024 * 1024 * 1024)).round();
    } catch (e) {
      return 128; // Fallback
    }
  }
}