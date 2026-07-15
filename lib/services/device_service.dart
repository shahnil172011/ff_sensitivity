import '../core/utils/device_info.dart';
import '../models/device_model.dart';

class DeviceService {
  static Future<DeviceModel> scanDevice() async {
    return await DeviceInfoUtil.getDeviceInfo();
  }
}