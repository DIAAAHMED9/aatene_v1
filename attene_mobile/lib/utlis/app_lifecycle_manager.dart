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
    WidgetsBinding.instance.addObserver(this);
    print('🔄 [LIFECYCLE] بدء إدارة دورة حياة التطبيق');
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _currentState.value = state;
    print('🔄 [LIFECYCLE] تغيير حالة التطبيق: $state');

    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.inactive:
        _onAppInactive();
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.hidden:
        _onAppHidden();
        break;
      case AppLifecycleState.detached:
        _onAppDetached();
        break;
    }
  }

  void _onAppResumed() {
    print('✅ [LIFECYCLE] التطبيق عاد للعمل');
    _reloadDataOnResume();
  }

  void _onAppInactive() {
    print('⚠️ [LIFECYCLE] التطبيق غير نشط');
  }

  void _onAppPaused() {
    print('⏸️ [LIFECYCLE] التطبيق متوقف');
    _saveDataBeforePause();
  }

  void _onAppHidden() {
    print('🙈 [LIFECYCLE] التطبيق مخفي');
    _saveDataBeforePause();
  }

  void _onAppDetached() {
    print('❌ [LIFECYCLE] التطبيق مغلق');
    _saveDataBeforePause();
  }

  Future<void> _reloadDataOnResume() async {
    try {
      final myAppController = Get.find<MyAppController>();
      if (myAppController.isLoggedIn.value) {
        print('🔄 [LIFECYCLE] إعادة تحميل البيانات بعد استئناف التطبيق');
        _refreshCriticalData();
      }
    } catch (e) {
      print('⚠️ [LIFECYCLE] خطأ في إعادة تحميل البيانات: $e');
    }
  }

  Future<void> _refreshCriticalData() async {
    try {
      print('🔄 [LIFECYCLE] تحديث البيانات الحرجة...');
    } catch (e) {
      print('⚠️ [LIFECYCLE] خطأ في تحديث البيانات: $e');
    }
  }

  Future<void> _saveDataBeforePause() async {
    try {
      print('💾 [LIFECYCLE] حفظ البيانات قبل توقف التطبيق');

      final myAppController = Get.find<MyAppController>();
      if (myAppController.isLoggedIn.value) {
        await myAppController.saveUserPreferences();
      }

      await _saveAppState();
    } catch (e) {
      print('⚠️ [LIFECYCLE] خطأ في حفظ البيانات: $e');
    }
  }

  Future<void> _saveAppState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'last_active_time',
        DateTime.now().toIso8601String(),
      );
      print('💾 [LIFECYCLE] تم حفظ حالة التطبيق');
    } catch (e) {
      print('⚠️ [LIFECYCLE] خطأ في حفظ حالة التطبيق: $e');
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
