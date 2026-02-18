import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/notification/model/notification_model.dart';

class NotificationController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;

  final notifications = <NotificationModel>[
    NotificationModel(
      title: 'عاد المنتج المفضل لديك للتوفر الآن!',
      body: 'تحقق من الكمية المتوفرة قبل انتهاء العرض',
      time: 'منذ ساعة',
      image: 'assets/images/user1.png',
      isRead: false,
    ),
    NotificationModel(
      title: 'خصم جديد على متجرك المفضل!',
      body: 'المنتج الذي أضفته لمفضلاتك عاد للتخزين',
      time: 'منذ ساعة',
      image: 'assets/images/user1.png',
      isRead: false,
    ),
  ].obs;

  NotificationModel? _lastRemoved;
  int? _lastRemovedIndex;

  List<NotificationModel> get unreadList =>
      notifications.where((e) => !e.isRead).toList();

  List<NotificationModel> get readList =>
      notifications.where((e) => e.isRead).toList();

  void changePage(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  void markAsRead(NotificationModel model) {
    final index = notifications.indexOf(model);
    if (index != -1) {
      notifications[index] = model.copyWith(isRead: true);
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }
  }

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