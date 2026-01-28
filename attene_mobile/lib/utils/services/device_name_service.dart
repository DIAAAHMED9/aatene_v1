import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, kDebugMode, debugPrint, defaultTargetPlatform, TargetPlatform;

class DeviceNameService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<String> getDeviceName() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfo.webBrowserInfo;
        final browser = webInfo.browserName.name;
        final ua = (webInfo.userAgent ?? '').trim();
        final shortUa = ua.isEmpty ? '' : ' - ${ua.substring(0, ua.length.clamp(0, 40))}';
        return 'Web ($browser)$shortUa';
      }

      final platform = defaultTargetPlatform;

      if (platform == TargetPlatform.android) {
        final androidInfo = await _deviceInfo.androidInfo;
        final model = (androidInfo.model ?? '').trim();
        return model.isNotEmpty ? model : 'Android Device';
      }

      if (platform == TargetPlatform.iOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        final name = (iosInfo.name ?? '').trim();
        return name.isNotEmpty ? name : 'iOS Device';
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ DeviceNameService.getDeviceName error: $e');
      }
    }

    return 'Unknown Device';
  }
}