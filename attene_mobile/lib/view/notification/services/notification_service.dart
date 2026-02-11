import 'package:attene_mobile/view/notification/model/notification_model.dart';

class NotificationService {
  Future<List<NotificationModel>> fetchNotifications() async {
    // جلب الإشعارات من API
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }
  Future<void> markAsRead(String notificationId) async {
    // تحديث حالة الإشعار في الخادم
  }
  Future<void> deleteNotification(String notificationId) async {
    // حذف الإشعار من الخادم
  }
}
