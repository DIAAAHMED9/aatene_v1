import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/notification/model/notification_model.dart';

class NotificationController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;

  /// القائمة الرئيسية
  final notifications = <NotificationModel>[].obs;

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void onReady() {
    super.onReady();
    fetchNotificationData();
  }

  /// =========================
  /// FETCH DATA FROM API
  /// =========================
  Future<void> fetchNotificationData() async {
    try {
      isLoading = true;
      hasError = false;
      update();

      final res = await ApiHelper.notificationData();

      if (res != null && res['status'] == true) {
        final List raw = (res['notifications'] as List?) ?? const [];

        notifications.value = raw
            .whereType<Map>()
            .map((e) => NotificationModel.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList(growable: false);
      } else {
        hasError = true;
        errorMessage = res?['message'] ?? 'حدث خطأ أثناء جلب البيانات';
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  /// =========================
  /// FILTERS
  /// =========================
  List<NotificationModel> get unreadList =>
      notifications.where((e) => !e.isRead).toList();

  List<NotificationModel> get readList =>
      notifications.where((e) => e.isRead).toList();

  /// =========================
  /// PAGE CONTROL
  /// =========================
  void changePage(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  /// =========================
  /// MARK AS READ
  /// =========================
  void markAsRead(NotificationModel model) {
    final index = notifications.indexOf(model);
    if (index != -1) {
      notifications[index] = model.copyWith(isRead: true);
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        notifications[i] =
            notifications[i].copyWith(isRead: true);
      }
    }
  }

  /// =========================
  /// DELETE WITH UNDO
  /// =========================
  NotificationModel? _lastRemoved;
  int? _lastRemovedIndex;

  void removeWithUndo(NotificationModel model) {
    _lastRemovedIndex = notifications.indexOf(model);
    _lastRemoved = model;
    notifications.remove(model);

    Get.snackbar(
      'تم حذف الإشعار',
      '',
      snackPosition: SnackPosition.BOTTOM,
      mainButton: TextButton(
        onPressed: undoDelete,
        child: const Text(
          'تراجع',
          style: TextStyle(color: AppColors.neutral100),
        ),
      ),
      backgroundColor: AppColors.primary50,
      colorText: AppColors.primary400,
      duration: const Duration(seconds: 4),
    );
  }

  void undoDelete() {
    if (_lastRemoved != null && _lastRemovedIndex != null) {
      notifications.insert(_lastRemovedIndex!, _lastRemoved!);
      _lastRemoved = null;
      _lastRemovedIndex = null;
    }
  }

  void clearAllNotifications() {
    notifications.clear();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}