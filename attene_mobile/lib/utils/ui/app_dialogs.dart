import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialogs {
  AppDialogs._();

  static bool _isLoadingOpen = false;

  /// Loading dialog آمن (يضمن وجود Material) + يمنع التكرار
  static void showLoading({String? message}) {
    if (_isLoadingOpen) return;
    _isLoadingOpen = true;

    Get.dialog(
      Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            width: 260,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message ?? 'جاري التحميل...',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      useSafeArea: true,
    ).whenComplete(() {
      _isLoadingOpen = false;
    });
  }

  /// إغلاق آمن
  static void hideLoading() {
    if (!_isLoadingOpen) return;
    _isLoadingOpen = false;

    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }
}
