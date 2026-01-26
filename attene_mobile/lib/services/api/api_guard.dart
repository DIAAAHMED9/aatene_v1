import 'package:attene_mobile/utils/ui/app_dialogs.dart';

class ApiGuard {
  ApiGuard._();

  static Future<T> run<T>(
    Future<T> Function() action, {
    bool showLoading = true,
    String? loadingText,
  }) async {
    if (showLoading) {
      AppDialogs.showLoading(message: loadingText ?? 'جاري التحميل...');
    }
    try {
      return await action();
    } finally {
      if (showLoading) {
        AppDialogs.hideLoading();
      }
    }
  }
}
