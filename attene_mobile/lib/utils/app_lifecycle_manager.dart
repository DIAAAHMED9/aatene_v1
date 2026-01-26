import '../my_app/index.dart';
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
    
    if (state == AppLifecycleState.resumed || state == AppLifecycleState.paused) {
      print('🔄 [LIFECYCLE] تغيير حالة: $state');
    }

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
    // ✅ لا تقطع تجربة المستخدم داخل مسارات الـ Stepper/الـ Pickers
    // (هذه الشاشات عادة تفتح BottomSheet/Picker وتسبب inactive/resumed)
    if (_isInCriticalFlow()) return;

    Future.delayed(const Duration(seconds: 1), () {
      _reloadDataOnResume();
    });
  }

  bool _isInCriticalFlow() {
    try {
      final r = Get.currentRoute;
      return r == '/add-service' ||
          r == '/edit-service' ||
          r == '/add-product' ||
          r == '/edit-product' ||
          r.toLowerCase().contains('stepper');
    } catch (_) {
      return false;
    }
  }

  void _onAppPaused() {
    _quickSave();
  }

  Future<void> _reloadDataOnResume() async {
    try {
      final myAppController = Get.find<MyAppController>();
      if (myAppController.isLoggedIn.value) {
        Future.delayed(const Duration(seconds: 2), () {
          _refreshCriticalData();
        });
      }
    } catch (e) {
    }
  }

  Future<void> _refreshCriticalData() async {
    try {
      print('🔄 [LIFECYCLE] تحديث البيانات...');
    } catch (e) {
      print('⚠️ [LIFECYCLE] خطأ في تحديث البيانات: $e');
    }
  }

  Future<void> _quickSave() async {
    try {
      final myAppController = Get.find<MyAppController>();
      if (myAppController.isLoggedIn.value) {
        myAppController.saveUserPreferences();
      }

      await _saveAppState();
    } catch (e) {
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