class DeviceModel {
  final String brand;
  final String model;
  final String androidVersion;
  final int ramGB;
  final String processor;
  final String gpu;
  final int batteryPercent;
  final int storageGB;
  final String screenResolution;
  final double screenSizeInches;
  final double refreshRate;
  final double dpi;

  DeviceModel({
    required this.brand,
    required this.model,
    required this.androidVersion,
    required this.ramGB,
    required this.processor,
    required this.gpu,
    required this.batteryPercent,
    required this.storageGB,
    required this.screenResolution,
    required this.screenSizeInches,
    required this.refreshRate,
    required this.dpi,
  });

  Map<String, dynamic> toJson() => {
    'brand': brand,
    'model': model,
    'androidVersion': androidVersion,
    'ramGB': ramGB,
    'processor': processor,
    'gpu': gpu,
    'batteryPercent': batteryPercent,
    'storageGB': storageGB,
    'screenResolution': screenResolution,
    'screenSizeInches': screenSizeInches,
    'refreshRate': refreshRate,
    'dpi': dpi,
  };
}