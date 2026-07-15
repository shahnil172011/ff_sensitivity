import 'package:flutter/material.dart';
import '../models/sensitivity_profile.dart';
import '../services/storage_service.dart';

class ProfileProvider extends ChangeNotifier {
  List<SensitivityProfile> _profiles = [];

  List<SensitivityProfile> get profiles => _profiles;

  ProfileProvider() {
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    _profiles = await StorageService.loadProfiles();
    notifyListeners();
  }

  Future<void> saveProfile(SensitivityProfile profile) async {
    _profiles.add(profile);
    await StorageService.saveProfiles(_profiles);
    notifyListeners();
  }

  Future<void> deleteProfile(String id) async {
    _profiles.removeWhere((p) => p.id == id);
    await StorageService.saveProfiles(_profiles);
    notifyListeners();
  }

  Future<void> renameProfile(String id, String newName) async {
    final index = _profiles.indexWhere((p) => p.id == id);
    if (index != -1) {
      _profiles[index] = SensitivityProfile(
        id: _profiles[index].id,
        name: newName,
        createdAt: _profiles[index].createdAt,
        general: _profiles[index].general,
        redDot: _profiles[index].redDot,
        scope2x: _profiles[index].scope2x,
        scope4x: _profiles[index].scope4x,
        sniperScope: _profiles[index].sniperScope,
        freeLook: _profiles[index].freeLook,
        graphicsSetting: _profiles[index].graphicsSetting,
        fpsSetting: _profiles[index].fpsSetting,
        deviceModel: _profiles[index].deviceModel,
        playStyle: _profiles[index].playStyle,
      );
      await StorageService.saveProfiles(_profiles);
      notifyListeners();
    }
  }

  void loadProfile(SensitivityProfile profile) {
    // Load profile into current session
    // Implementation depends on app state management
  }
}