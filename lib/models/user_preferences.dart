class UserPreferences {
  final bool gyroscopeOn;
  final int fingerCount; // 2-5
  final String playStyle; // headshot, rush, balanced, sniper
  final int fpsPreference; // 30, 60, 90, 120
  final String graphicsPreference; // smooth, balanced, hd, ultra

  UserPreferences({
    required this.gyroscopeOn,
    required this.fingerCount,
    required this.playStyle,
    required this.fpsPreference,
    required this.graphicsPreference,
  });

  Map<String, dynamic> toJson() => {
    'gyroscopeOn': gyroscopeOn,
    'fingerCount': fingerCount,
    'playStyle': playStyle,
    'fpsPreference': fpsPreference,
    'graphicsPreference': graphicsPreference,
  };
}