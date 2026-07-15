class SensitivityProfile {
  final String id;
  final String name;
  final DateTime createdAt;
  final Map<String, double> general;
  final Map<String, double> redDot;
  final Map<String, double> scope2x;
  final Map<String, double> scope4x;
  final Map<String, double> sniperScope;
  final Map<String, double> freeLook;
  final String graphicsSetting;
  final int fpsSetting;
  final String deviceModel;
  final String playStyle;

  SensitivityProfile({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.general,
    required this.redDot,
    required this.scope2x,
    required this.scope4x,
    required this.sniperScope,
    required this.freeLook,
    required this.graphicsSetting,
    required this.fpsSetting,
    required this.deviceModel,
    required this.playStyle,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'general': general,
    'redDot': redDot,
    'scope2x': scope2x,
    'scope4x': scope4x,
    'sniperScope': sniperScope,
    'freeLook': freeLook,
    'graphicsSetting': graphicsSetting,
    'fpsSetting': fpsSetting,
    'deviceModel': deviceModel,
    'playStyle': playStyle,
  };
}