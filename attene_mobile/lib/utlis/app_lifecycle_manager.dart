import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../my_app/my_app_controller.dart';

class AppLifecycleManager extends GetxController with WidgetsBindingObserver {
  static AppLifecycleManager get to => Get.find();

  final Rx<AppLifecycleState> _currentState = AppLifecycleState.resumed.obs;

  @override
  void onInit() {
    super.onInit();
    
    // لا تبدأ المراقبة فوراً - انتظر حتى يتم تحميل الواجهة
    Future.delayed(const Duration(seconds: 5), () {
      WidgetsBinding.instance.addObserver(this);
      print('🔄 [LIFECYCLE] بدء إدارة دورة حياة التطبيق');
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _currentState.value = state;
    
    // طباعة محدودة للتقليل من load
    if (state == AppLifecycleState.resumed || state == AppLifecycleState.paused) {
      print('🔄 [LIFECYCLE] تغيير حالة: $state');
    }

    // معالجة الحالات المهمة فقط
    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      default:
        break;
    }
  }

  void _onAppResumed() {
    // تأجيل إعادة التحميل لتفادي التحميل الزائد
    Future.delayed(const Duration(seconds: 1), () {
      _reloadDataOnResume();
    });
  }

  void _onAppPaused() {
    // حفظ البيانات بشكل غير متزامن
    _quickSave();
  }

  Future<void> _reloadDataOnResume() async {
    try {
      final myAppController = Get.find<MyAppController>();
      if (myAppController.isLoggedIn.value) {
        // تأجيل المهام الثقيلة أكثر
        Future.delayed(const Duration(seconds: 2), () {
          _refreshCriticalData();
        });
      }
    } catch (e) {
      // تجاهل الأخطاء البسيطة
    }
  }

  Future<void> _refreshCriticalData() async {
    try {
      print('🔄 [LIFECYCLE] تحديث البيانات...');
      // إضافة تحديث البيانات المهمة هنا
    } catch (e) {
      print('⚠️ [LIFECYCLE] خطأ في تحديث البيانات: $e');
    }
  }

  Future<void> _quickSave() async {
    try {
      final myAppController = Get.find<MyAppController>();
      if (myAppController.isLoggedIn.value) {
        // حفظ سريع بدون await لبيانات المستخدم
        myAppController.saveUserPreferences();
      }

      // حفظ حالة التطبيق
      await _saveAppState();
    } catch (e) {
      // تجاهل أخطاء الحفظ
    }
  }

  Future<void> _saveAppState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'last_active_time',
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      // تجاهل أخطاء SharedPreferences
    }
  }

  bool get isAppActive => _currentState.value == AppLifecycleState.resumed;
  
  bool get isAppBackground =>
      _currentState.value == AppLifecycleState.paused ||
      _currentState.value == AppLifecycleState.inactive ||
      _currentState.value == AppLifecycleState.hidden;
  
  AppLifecycleState get currentState => _currentState.value;
  
  bool get canShowDialogs {
    return _currentState.value == AppLifecycleState.resumed &&
        Get.context != null &&
        !Get.isDialogOpen!;
  }
}