import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;

class DeviceNameService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  
  static Future<String> getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.model ?? 'Unknown Device';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.name ?? 'Unknown Device';
      }
    } catch (e) {
      print('❌ خطأ في جلب اسم الجهاز: $e');
    }
    return 'Unknown Device';
  }
}