

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../general_index.dart';

class PushNotificationService {
  void _tryRefreshChatFromPayload(Map<String, dynamic> data) {
    try {
      if (!Get.isRegistered<ChatController>()) return;
      final c = ChatController.to;

      final rawId = data['conversation_id'] ?? data['conversationId'] ?? data['cid'] ?? data['chat_id'];
      final convId = int.tryParse(rawId?.toString() ?? '');

      c.loadConversations();

      if (convId != null && c.currentConversation.value?.id == convId) {
        c.loadConversationMessages(convId, silent: true);
      }
    } catch (_) {}
  }

  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Get.toNamed('/mainScreen');
      if (message.data['type'] == 'chat') {
        _tryRefreshChatFromPayload(message.data);
      }
    });
    
    await registerNotificationListeners();
  }

  dynamic registerNotificationListeners() async {
    final AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings darwinSettings =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        Get.toNamed('/mainScreen');
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.data['type'] == 'chat') {
        _tryRefreshChatFromPayload(message.data);
      }
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;
      final AppleNotification? apple = message.notification?.apple;

      if (notification != null) {
        final NotificationDetails notificationDetails = NotificationDetails(
          android: android != null
              ? AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  importance: Importance.max,
                  priority: Priority.high,
                  icon: android.smallIcon,
                )
              : null,
          iOS: apple != null
              ? DarwinNotificationDetails(
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                )
              : null,
        );

        await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          notificationDetails,
          payload: message.data.toString(),
        );
      }
    });
  }

  @pragma('vm:entry-point')
  static Future<void> notificationTapBackground(NotificationResponse notificationResponse) async {
  }

  AndroidNotificationChannel androidNotificationChannel() =>
      const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );
}