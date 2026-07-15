class HudLayout {
  final double fireButtonX;
  final double fireButtonY;
  final double joystickX;
  final double joystickY;
  final double scopeX;
  final double scopeY;
  final double jumpX;
  final double jumpY;
  final double crouchX;
  final double crouchY;
  final double proneX;
  final double proneY;
  final double weaponSwitchX;
  final double weaponSwitchY;
  final double utilityX;
  final double utilityY;

  HudLayout({
    required this.fireButtonX,
    required this.fireButtonY,
    required this.joystickX,
    required this.joystickY,
    required this.scopeX,
    required this.scopeY,
    required this.jumpX,
    required this.jumpY,
    required this.crouchX,
    required this.crouchY,
    required this.proneX,
    required this.proneY,
    required this.weaponSwitchX,
    required this.weaponSwitchY,
    required this.utilityX,
    required this.utilityY,
  });

  Map<String, double> toMap() => {
    'fireButtonX': fireButtonX,
    'fireButtonY': fireButtonY,
    'joystickX': joystickX,
    'joystickY': joystickY,
    'scopeX': scopeX,
    'scopeY': scopeY,
    'jumpX': jumpX,
    'jumpY': jumpY,
    'crouchX': crouchX,
    'crouchY': crouchY,
    'proneX': proneX,
    'proneY': proneY,
    'weaponSwitchX': weaponSwitchX,
    'weaponSwitchY': weaponSwitchY,
    'utilityX': utilityX,
    'utilityY': utilityY,
  };
}