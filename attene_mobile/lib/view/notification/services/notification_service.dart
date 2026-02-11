import 'package:attene_mobile/view/notification/model/notification_model.dart';

class NotificationService {
  Future<List<NotificationModel>> fetchNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }
  Future<void> markAsRead(String notificationId) async {
  }
  Future<void> deleteNotification(String notificationId) async {
  }
}