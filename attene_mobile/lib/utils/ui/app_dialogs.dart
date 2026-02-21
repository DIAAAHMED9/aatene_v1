import 'package:attene_mobile/general_index.dart';

class AppDialogs {
  AppDialogs._();

  static bool _isLoadingOpen = false;

  static void showLoading({String? message}) {
    if (_isLoadingOpen) return;
    _isLoadingOpen = true;

    Get.dialog(
      Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            width: 260,
            height: 250,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: AppColors.neutra90
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              spacing: 10,
              children: [
                Image.asset(
                  "assets/images/gif/aatene_logo.gif",
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                ),
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

  static void hideLoading() {
    if (!_isLoadingOpen) return;
    _isLoadingOpen = false;

    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }
}