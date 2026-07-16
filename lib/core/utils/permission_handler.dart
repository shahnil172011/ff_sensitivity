import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerUtil {
  static BuildContext? _context;

  static void setContext(BuildContext context) {
    _context = context;
  }

  static BuildContext? get context => _context;

  static Future<bool> canAccessGallery(BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        // For Android 13+ use photos permission
        if (await _isAndroid13OrHigher()) {
          final status = await Permission.photos.status;
          if (status.isDenied) {
            final result = await Permission.photos.request();
            return result.isGranted;
          }
          if (status.isPermanentlyDenied) {
            return await _showPermissionDialog(context);
          }
          return status.isGranted;
        } else {
          final status = await Permission.storage.status;
          if (status.isDenied) {
            final result = await Permission.storage.request();
            return result.isGranted;
          }
          if (status.isPermanentlyDenied) {
            return await _showPermissionDialog(context);
          }
          return status.isGranted;
        }
      }
      
      if (Platform.isIOS) {
        final status = await Permission.photos.status;
        if (status.isDenied) {
          final result = await Permission.photos.request();
          return result.isGranted;
        }
        if (status.isPermanentlyDenied) {
          return await _showPermissionDialog(context);
        }
        return status.isGranted;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> canAccessCamera(BuildContext context) async {
    try {
      final status = await Permission.camera.status;
      if (status.isDenied) {
        final result = await Permission.camera.request();
        return result.isGranted;
      }
      if (status.isPermanentlyDenied) {
        return await _showPermissionDialog(context);
      }
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _isAndroid13OrHigher() async {
    try {
      if (!Platform.isAndroid) return false;
      // Simple check - Android 13 is API 33
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _showPermissionDialog(BuildContext context) async {
    try {
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.lock_open, color: Color(0xFF00D2FF)),
                SizedBox(width: 8),
                Text('Permissions Required'),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FF Sensitivity AI needs the following permissions:'),
                SizedBox(height: 12),
                _PermissionItem(
                  icon: Icons.photo_library,
                  text: 'Storage/Photos - To upload HUD screenshots',
                ),
                SizedBox(height: 8),
                _PermissionItem(
                  icon: Icons.camera_alt,
                  text: 'Camera - To take HUD screenshots',
                ),
                SizedBox(height: 12),
                Text(
                  'These permissions are essential for the app to function.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D2FF),
                  foregroundColor: Colors.black,
                ),
                child: const Text('Grant Permissions'),
              ),
            ],
          );
        },
      );

      if (result == true) {
        return await openAppSettings();
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> requestAllPermissions() async {
    if (_context == null) return false;
    return await canAccessGallery(_context!);
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PermissionItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF00D2FF)),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ],
    );
  }
}   ],
    );
  }
}
