import 'package:flutter/material.dart';
import 'package:get/get.dart';



class AppRestartHandler {
  static final AppRestartHandler _instance = AppRestartHandler._internal();
  
  factory AppRestartHandler() {
    return _instance;
  }
  
  AppRestartHandler._internal();
  
  bool _isRestarting = false;
  DateTime? _lastRestartTime;
  int _restartCount = 0;
  final int _maxRestarts = 2;
  final Duration _restartCooldown = const Duration(seconds: 30);
  
  Future<void> handleAppRestart() async {
    final now = DateTime.now();
    
    if (_lastRestartTime != null) {
      final timeSinceLastRestart = now.difference(_lastRestartTime!);
      if (timeSinceLastRestart < _restartCooldown) {
        print('⚠️ [APP RESTART] تم إعادة التشغيل مؤخراً، تجاوز');
        return;
      }
    }
    
    if (_restartCount >= _maxRestarts) {
      print('🚨 [APP RESTART] تجاوز الحد الأقصى لإعادة التشغيل');
      await _showRestartLimitDialog();
      return;
    }
    
    _restartCount++;
    _lastRestartTime = now;
    _isRestarting = true;
    
    print('🔄 [APP RESTART] إعادة تشغيل التطبيق (المحاولة $_restartCount)');
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final String currentRoute = Get.currentRoute;
      
      if (currentRoute != '/login' && currentRoute != '/splash') {
        print('🔄 [APP RESTART] إعادة التوجيه إلى $currentRoute');
        Get.offAllNamed(currentRoute);
      }
    } catch (e) {
      print('❌ [APP RESTART] خطأ في إعادة التشغيل: $e');
    } finally {
      _isRestarting = false;
    }
  }
  
  Future<void> _showRestartLimitDialog() async {
    await Get.dialog(
      AlertDialog(
        title: const Text('تحذير'),
        content: const Text('تم إعادة تشغيل التطبيق عدة مرات. يرجى إغلاق التطبيق وإعادة فتحه يدوياً.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('موافق'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
  
  void resetRestartCount() {
    _restartCount = 0;
    _lastRestartTime = null;
    print('🔄 [APP RESTART] إعادة تعيين عداد إعادة التشغيل');
  }
  
  bool get isRestarting => _isRestarting;
  int get restartCount => _restartCount;
}