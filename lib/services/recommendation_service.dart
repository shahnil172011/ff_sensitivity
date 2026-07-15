import '../models/device_model.dart';
import '../models/user_preferences.dart';
import '../models/hud_layout.dart';
import '../models/sensitivity_profile.dart';
import '../core/utils/sensitivity_algorithm.dart';

class RecommendationService {
  static SensitivityProfile generate(
    DeviceModel device,
    UserPreferences preferences,
    HudLayout hudLayout,
  ) {
    return SensitivityAlgorithm.generateRecommendation(device, preferences, hudLayout);
  }
}