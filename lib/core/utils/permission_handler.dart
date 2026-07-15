import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionHandlerUtil {
  static BuildContext? _context;

  static void setContext(BuildContext context) {
    _context = context;
  }

  // Check and request all required permissions
  static Future<bool> requestAllPermissions() async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();
      
      List<Permission> permissions = [
        Permission.storage,
        Permission.camera,
      ];

      if (androidVersion >= 33) {
        permissions = [
          Permission.photos,
          Permission.videos,
          Permission.audio,
          Permission.camera,
        ];
      }

      final statuses = await permissions.request();
      
      bool allGranted = true;
      for (var status in statuses.values) {
        if (status != PermissionStatus.granted) {
          allGranted = false;
          break;
        }
      }

      if (!allGranted) {
        if (_context != null) {
          return await showPermissionDialogWithContext(_context!);
        }
        return false;
      }

      return true;
    }
    
    if (Platform.isIOS) {
      final permissions = [
        Permission.photos,
        Permission.camera,
      ];
      
      final statuses = await permissions.request();
      
      bool allGranted = true;
      for (var status in statuses.values) {
        if (status != PermissionStatus.granted) {
          allGranted = false;
          break;
        }
      }
      
      if (!allGranted) {
        if (_context != null) {
          return await showPermissionDialogWithContext(_context!);
        }
        return false;
      }
      
      return true;
    }

    return false;
  }

  static Future<bool> checkPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;
    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }
    if (status.isPermanentlyDenied) {
      if (_context != null) {
        return await showPermissionDialogWithContext(_context!);
      }
      return false;
    }
    return false;
  }

  static Future<PermissionStatus> getStoragePermissionStatus() async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();
      if (androidVersion >= 33) {
        return await Permission.photos.status;
      }
      return await Permission.storage.status;
    }
    return await Permission.photos.status;
  }

  static Future<PermissionStatus> getCameraPermissionStatus() async {
    return await Permission.camera.status;
  }

  static Future<bool> hasHudPermissions() async {
    final storageStatus = await getStoragePermissionStatus();
    if (!storageStatus.isGranted) {
      return false;
    }
    return true;
  }

  static Future<bool> requestHudPermissions() async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();
      if (androidVersion >= 33) {
        final status = await Permission.photos.request();
        if (status.isGranted) return true;
        if (status.isPermanentlyDenied) {
          return await openAppSettings();
        }
        return false;
      } else {
        final status = await Permission.storage.request();
        if (status.isGranted) return true;
        if (status.isPermanentlyDenied) {
          return await openAppSettings();
        }
        return false;
      }
    }
    
    if (Platform.isIOS) {
      final status = await Permission.photos.request();
      if (status.isGranted) return true;
      if (status.isPermanentlyDenied) {
        return await openAppSettings();
      }
      return false;
    }
    
    return false;
  }

  static Future<int> _getAndroidVersion() async {
    if (!Platform.isAndroid) return 0;
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return int.parse(androidInfo.version.sdkInt.toString());
    } catch (e) {
      return 0;
    }
  }

  static Future<bool> showPermissionDialogWithContext(
    BuildContext context,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.lock_open, color: Color(0xFF00D2FF)),
              SizedBox(width: 8),
              Text(
                'Permissions Required',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FF Sensitivity AI needs the following permissions:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2340),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: const [
                    _PermissionItem(
                      icon: Icons.photo_library,
                      text: 'Storage/Photos - To upload HUD screenshots',
                    ),
                    SizedBox(height: 8),
                    _PermissionItem(
                      icon: Icons.camera_alt,
                      text: 'Camera - To take HUD screenshots',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'These permissions are essential for the app to function.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
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
  }

  static Future<bool> requestPermissionWithContext(
    BuildContext context,
    Permission permission,
    String rationale,
  ) async {
    final status = await permission.status;
    
    if (status.isGranted) return true;
    
    if (status.isDenied) {
      final newStatus = await permission.request();
      if (newStatus.isGranted) return true;
      
      if (newStatus.isPermanentlyDenied) {
        return await showPermissionDialogWithContext(context);
      }
      return false;
    }
    
    if (status.isPermanentlyDenied) {
      return await showPermissionDialogWithContext(context);
    }
    
    return false;
  }

  static Future<bool> requestMultiplePermissionsWithContext(
    BuildContext context,
    List<Permission> permissions,
  ) async {
    final statuses = await permissions.request();
    
    bool allGranted = true;
    bool hasPermanentDenied = false;
    
    for (var status in statuses.values) {
      if (status.isDenied) {
        allGranted = false;
      }
      if (status.isPermanentlyDenied) {
        hasPermanentDenied = true;
        allGranted = false;
      }
    }
    
    if (allGranted) return true;
    
    if (hasPermanentDenied) {
      return await showPermissionDialogWithContext(context);
    }
    
    final retryStatuses = await permissions.request();
    bool retryAllGranted = true;
    for (var status in retryStatuses.values) {
      if (!status.isGranted) {
        retryAllGranted = false;
        break;
      }
    }
    
    if (retryAllGranted) return true;
    
    return await showPermissionDialogWithContext(context);
  }

  static Future<bool> canAccessGallery(BuildContext context) async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();
      if (androidVersion >= 33) {
        return await requestPermissionWithContext(
          context,
          Permission.photos,
          'FF Sensitivity AI needs access to your photos to upload HUD screenshots.',
        );
      } else {
        return await requestPermissionWithContext(
          context,
          Permission.storage,
          'FF Sensitivity AI needs access to your storage to upload HUD screenshots.',
        );
      }
    }
    
    if (Platform.isIOS) {
      return await requestPermissionWithContext(
        context,
        Permission.photos,
        'FF Sensitivity AI needs access to your photos to upload HUD screenshots.',
      );
    }
    
    return false;
  }

  static Future<bool> canAccessCamera(BuildContext context) async {
    return await requestPermissionWithContext(
      context,
      Permission.camera,
      'FF Sensitivity AI needs camera access to take HUD screenshots.',
    );
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
}