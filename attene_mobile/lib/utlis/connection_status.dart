import 'package:flutter/material.dart';

enum ConnectionStatus {
  connecting,
  connected,
  disconnected,
  error,
}

class ConnectionStatusHelper {
  static String getDisplayName(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connecting:
        return 'جاري الاتصال';
      case ConnectionStatus.connected:
        return 'متصل';
      case ConnectionStatus.disconnected:
        return 'غير متصل';
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

  static IconData getIcon(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connecting:
        return Icons.sync;
      case ConnectionStatus.connected:
        return Icons.wifi;
      case ConnectionStatus.disconnected:
        return Icons.wifi_off;
      case ConnectionStatus.error:
        return Icons.error_outline;
    }
  }
}