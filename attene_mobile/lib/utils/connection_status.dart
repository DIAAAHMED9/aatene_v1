import 'package:flutter/material.dart';

enum ConnectionStatus { connecting, connected, disconnected, error }

class ConnectionStatusHelper {
  static String getDisplayName(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connecting:
        return 'جاري الاتصال';
      case ConnectionStatus.connected:
        return 'متصل';
      case ConnectionStatus.disconnected:
        return 'انقطع الإتصال';
      case ConnectionStatus.error:
        return 'خطأ في الاتصال';
    }
  }

  static Color getColor(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connecting:
        return Colors.orange;
      case ConnectionStatus.connected:
        return Colors.green;
      case ConnectionStatus.disconnected:
        return Colors.grey;
      case ConnectionStatus.error:
        return Colors.red;
    }
  }

  static Widget getIcon(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connecting:
        return Icon(Icons.sync);
      case ConnectionStatus.connected:
        return Icon(Icons.wifi);
      case ConnectionStatus.disconnected:
        return Image.asset(
          'assets/images/png/No_Notification_illustration.png',
        );
      case ConnectionStatus.error:
        return Icon(Icons.error_outline);
    }
  }
}
