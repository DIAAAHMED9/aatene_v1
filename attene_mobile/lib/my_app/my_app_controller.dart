// lib/my_app/my_app_controller.dart
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MyAppController extends GetxController with WidgetsBindingObserver {
  static MyAppController get to => Get.find();
  
  // حالات المستخدم
  final RxBool _isLoggedIn = false.obs;
  final RxMap<String, dynamic> _userData = <String, dynamic>{}.obs;
  final RxBool _isLoading = false.obs;
  
  // حالات التطبيق
  final RxBool _isAppInitialized = false.obs;
  final RxBool _isInternetConnect = true.obs;
  final RxBool _isDarkMode = false.obs;
  final RxString _currentLanguage = 'ar'.obs;
  
  // إحصائيات التطبيق
  final RxInt _appLaunchCount = 0.obs;
  final RxString _appVersion = '1.0.0'.obs;
  
  // متغير للتحقق من الاتصال
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    
    print('🔄 بدء تهيئة MyAppController');
    
    // تحميل البيانات الأولية
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    try {
      _isLoading.value = true;
      
      // تحميل بيانات المستخدم
      await _loadUserData();
      
      // تحميل إعدادات التطبيق
      await _loadAppSettings();
      
      // بدء مراقبة الاتصال بالإنترنت
      await _startConnectivityMonitoring();
      
      // تحديث حالة التهيئة
      _isAppInitialized.value = true;
      
      print('✅ تم تهيئة التطبيق بنجاح');
      print('👤 حالة المستخدم: ${_isLoggedIn.value ? 'مسجل دخول' : 'غير مسجل'}');
      
    } catch (e) {
      print('❌ خطأ في تهيئة التطبيق: $e');
    } finally {
      _isLoading.value = false;
    }
  }
  
  // ==================== مراقبة الاتصال بالإنترنت ====================
  
  Future<void> _startConnectivityMonitoring() async {
    try {
      // التحقق من الاتصال الحالي
      final connectivityResult = await _connectivity.checkConnectivity();
      _isInternetConnect.value = connectivityResult != ConnectivityResult.none;
      
      print('📶 حالة الاتصال الحالية: ${_isInternetConnect.value ? 'متصل' : 'غير متصل'}');
      
      // مراقبة تغيرات الاتصال
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
        final bool isConnected = result != ConnectivityResult.none;
        if (_isInternetConnect.value != isConnected) {
          _isInternetConnect.value = isConnected;
          print('📶 تغير حالة الاتصال: ${isConnected ? 'متصل' : 'غير متصل'}');
          
          // إشعار المتحكمات الأخرى بتغير الاتصال
          if (isConnected) {
            _onInternetRestored();
          } else {
            _onInternetLost();
          }
        }
      } as void Function(List<ConnectivityResult> event)?) as StreamSubscription<ConnectivityResult>;
      
      print('📡 بدء مراقبة الاتصال بالإنترنت');
    } catch (e) {
      print('⚠️ خطأ في مراقبة الاتصال: $e');
    }
  }
  
  void _onInternetRestored() {
    print('🌐 استعادة الاتصال بالإنترنت');
    // يمكن إضافة إشعارات أو تنفيذ مهام متأخرة
    Get.snackbar(
      'تم استعادة الاتصال',
      'تمت استعادة الاتصال بالإنترنت',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
  
  void _onInternetLost() {
    print('⚠️ فقدان الاتصال بالإنترنت');
    Get.snackbar(
      'انقطع الاتصال',
      'فقدان الاتصال بالإنترنت',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
  
  // ==================== وظائف المستخدم ====================
  
  RxBool get isLoggedIn => _isLoggedIn;
  RxBool get isAppInitialized => _isAppInitialized;
  RxBool get isInternetConnect => _isInternetConnect;
  
  Map<String, dynamic> get userData => _userData;
  bool get isLoading => _isLoading.value;
  String? get token => _userData['token'];
  String? get userId => _userData['id']?.toString() ?? _userData['_id']?.toString();
  
  // تحديث بيانات المستخدم
  void updateUserData(Map<String, dynamic> newData) {
    final Map<String, dynamic> mergedData = Map.from(_userData)..addAll(newData);
    _userData.value = mergedData;
    _isLoggedIn.value = true;
    
    // حفظ البيانات فوراً
    _saveUserData();
    
    print('✅ تم تحديث بيانات المستخدم');
    print('📊 البيانات: ${newData.keys.join(', ')}');
  }
  
  // معالجة نجاح تسجيل الدخول
  Future<void> onLoginSuccess(Map<String, dynamic> userData) async {
    try {
      _isLoading.value = true;
      
      print('🎉 معالجة نجاح تسجيل الدخول');
      
      // تحديث بيانات المستخدم
      updateUserData(userData);
      
      // تحميل البيانات الإضافية
      await _loadAdditionalUserData();
      
      // حفظ وقت التسجيل الأخير
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_login_time', DateTime.now().toIso8601String());
      
      // زيادة عداد تسجيلات الدخول
      await _incrementLoginCount();
      
      print('✅ تم تسجيل الدخول بنجاح للمستخدم: ${userData['email'] ?? userId}');
      
      // إشعار المتحكمات الأخرى بتسجيل الدخول
      _notifyLoginSuccess();
      
    } catch (e) {
      print('❌ خطأ في معالجة تسجيل الدخول: $e');
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }
  
  // إشعار المتحكمات الأخرى بتسجيل الدخول
  void _notifyLoginSuccess() {
    // يمكن إضافة منطق لإشعار المتحكمات الأخرى هنا
    print('📢 إشعار تسجيل الدخول للمتحكمات الأخرى');
  }
  
  // تحميل بيانات إضافية للمستخدم
  Future<void> _loadAdditionalUserData() async {
    try {
      print('🔄 جاري تحميل البيانات الإضافية للمستخدم...');
      
      // هنا يمكنك إضافة طلبات API لتحميل بيانات إضافية
      // مثل الملف الشخصي، الإشعارات، الإعدادات، إلخ.
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      print('✅ تم تحميل البيانات الإضافية');
    } catch (e) {
      print('⚠️ خطأ في تحميل البيانات الإضافية: $e');
    }
  }
  
  Future<void> _incrementLoginCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCount = prefs.getInt('login_count') ?? 0;
      await prefs.setInt('login_count', currentCount + 1);
      print('📊 عدد مرات تسجيل الدخول: ${currentCount + 1}');
    } catch (e) {
      print('⚠️ خطأ في زيادة عداد تسجيلات الدخول: $e');
    }
  }
  
  // ==================== وظائف حفظ البيانات ====================
  
  // حفظ تفضيلات المستخدم
  Future<void> saveUserPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool('is_logged_in', _isLoggedIn.value);
      await prefs.setString('user_data', json.encode(_userData));
      await prefs.setString('last_save_time', DateTime.now().toIso8601String());
      
      print('💾 تم حفظ تفضيلات المستخدم');
    } catch (e) {
      print('❌ خطأ في حفظ تفضيلات المستخدم: $e');
      throw e;
    }
  }
  
  // حفظ بيانات المستخدم
  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', json.encode(_userData));
      await prefs.setBool('is_logged_in', _isLoggedIn.value);
      
      print('💾 تم حفظ بيانات المستخدم في التخزين المحلي');
    } catch (e) {
      print('⚠️ خطأ في حفظ بيانات المستخدم: $e');
    }
  }
  
  // تحميل بيانات المستخدم
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      final userDataString = prefs.getString('user_data');
      
      if (userDataString != null && isLoggedIn) {
        final decodedData = json.decode(userDataString) as Map<String, dynamic>;
        _userData.value = decodedData;
        _isLoggedIn.value = isLoggedIn;
        
        // التحقق من صلاحية التوكن
        final bool isTokenValid = await _validateToken();
        if (!isTokenValid) {
          await onSignOut();
        } else {
          print('✅ تم تحميل بيانات المستخدم من التخزين المحلي');
          print('👤 المستخدم: ${_userData['email'] ?? _userData['phone']}');
        }
      } else {
        print('ℹ️ لا توجد بيانات مستخدم محفوظة');
      }
    } catch (e) {
      print('❌ خطأ في تحميل بيانات المستخدم: $e');
      await onSignOut(); // تسجيل الخروج في حالة وجود خطأ
    }
  }
  
  // ==================== وظائف إعدادات التطبيق ====================
  
  Future<void> _loadAppSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // تحميل إعدادات التطبيق
      _isDarkMode.value = prefs.getBool('dark_mode') ?? false;
      _currentLanguage.value = prefs.getString('language') ?? 'ar';
      _appLaunchCount.value = prefs.getInt('app_launch_count') ?? 0;
      _appVersion.value = prefs.getString('app_version') ?? '1.0.0';
      
      // زيادة عداد تشغيل التطبيق
      await _incrementAppLaunchCount();
      
      print('⚙️ تحميل إعدادات التطبيق');
      print('   الوضع المظلم: ${_isDarkMode.value}');
      print('   اللغة: ${_currentLanguage.value}');
      print('   عدد التشغيلات: ${_appLaunchCount.value}');
      
    } catch (e) {
      print('⚠️ خطأ في تحميل إعدادات التطبيق: $e');
    }
  }
  
  Future<void> _incrementAppLaunchCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCount = prefs.getInt('app_launch_count') ?? 0;
      await prefs.setInt('app_launch_count', currentCount + 1);
      _appLaunchCount.value = currentCount + 1;
    } catch (e) {
      print('⚠️ خطأ في زيادة عداد تشغيل التطبيق: $e');
    }
  }
  
  // ==================== وظائف تسجيل الخروج ====================
  
  // دالة onSignOut - تسمى من الـAPI عند حدوث خطأ 401
  Future<void> onSignOut() async {
    print('🔐 تنفيذ onSignOut بسبب انتهاء الجلسة');
    await _performSignOut(showMessage: true);
  }
  
  // دالة logout - تسمى من واجهة المستخدم
  Future<void> logout() async {
    print('👋 تنفيذ logout من قبل المستخدم');
    await _performSignOut(showMessage: false);
  }
  
  // الدالة الأساسية لتسجيل الخروج
  Future<void> _performSignOut({bool showMessage = true}) async {
    try {
      _isLoading.value = true;
      
      print('🔄 بدء عملية تسجيل الخروج...');
      
      // إرسال طلب تسجيل الخروج للخادم (اختياري)
      try {
        // await ApiHelper.logout();
      } catch (e) {
        print('⚠️ خطأ في طلب تسجيل الخروج للخادم: $e');
      }
      
      // مسح البيانات المحلية
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      await prefs.setBool('is_logged_in', false);
      
      // مسح بيانات الذاكرة
      _userData.clear();
      _isLoggedIn.value = false;
      
      print('✅ تم تسجيل الخروج بنجاح');
      
      // إظهار رسالة للمستخدم إذا طلبنا ذلك
      if (showMessage) {
        Get.snackbar(
          'انتهت الجلسة',
          'يرجى تسجيل الدخول مرة أخرى',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
      
      // الانتقال لشاشة تسجيل الدخول
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed('/login');
      
    } catch (e) {
      print('❌ خطأ في تسجيل الخروج: $e');
      Get.snackbar(
        'خطأ',
        'فشل في تسجيل الخروج',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }
  
  // ==================== وظائف مساعدة ====================
  
  // التحقق من صلاحية التوكن
  Future<bool> _validateToken() async {
    try {
      final token = _userData['token'];
      if (token == null || token.isEmpty) return false;
      
      // هنا يمكنك إضافة منطق للتحقق من صلاحية التوكن مع الخادم
      // مؤقتاً: نعتبر التوكن صالحاً إذا كان موجوداً
      return true;
    } catch (e) {
      print('⚠️ خطأ في التحقق من صلاحية التوكن: $e');
      return false;
    }
  }
  
  // تبديل الوضع المظلم
  Future<void> toggleDarkMode() async {
    try {
      _isDarkMode.value = !_isDarkMode.value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('dark_mode', _isDarkMode.value);
      
      print('🌙 تبديل الوضع المظلم إلى: ${_isDarkMode.value}');
    } catch (e) {
      print('❌ خطأ في تبديل الوضع المظلم: $e');
    }
  }
  
  // تغيير اللغة
  Future<void> changeLanguage(String languageCode) async {
    try {
      if (languageCode != _currentLanguage.value) {
        _currentLanguage.value = languageCode;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('language', languageCode);
        
        print('🌍 تغيير اللغة إلى: $languageCode');
        
        // يمكن إضافة إعادة تحميل التطبيق هنا
        Get.updateLocale(Locale(languageCode));
      }
    } catch (e) {
      print('❌ خطأ في تغيير اللغة: $e');
    }
  }
  
  // التحقق مما إذا كان المستخدم لديه صلاحية معينة
  bool hasPermission(String permission) {
    final permissions = _userData['permissions'] as List<dynamic>?;
    return permissions?.contains(permission) ?? false;
  }
  
  // التحقق مما إذا كان المستخدم لديه دور معين
  bool hasRole(String role) {
    final roles = _userData['roles'] as List<dynamic>?;
    return roles?.contains(role) ?? false;
  }
  
  // تحديث بيانات محددة
  void updateSpecificData(String key, dynamic value) {
    _userData[key] = value;
    _saveUserData();
    print('📝 تم تحديث $key: $value');
  }
  
  // الحصول على بيانات محددة
  dynamic getUserData(String key) {
    return _userData[key];
  }
  
  // الحصول على الاسم الكامل
  String get fullName {
    if (_userData['full_name'] != null) return _userData['full_name'];
    if (_userData['first_name'] != null && _userData['last_name'] != null) {
      return '${_userData['first_name']} ${_userData['last_name']}';
    }
    return _userData['email'] ?? _userData['phone'] ?? 'مستخدم';
  }
  
  // الحصول على الصورة الشخصية
  String? get profileImage {
    return _userData['profile_image'] ?? 
           _userData['avatar'] ?? 
           _userData['image_url'];
  }
  
  // الحصول على إحصائيات التطبيق
  Map<String, dynamic> get appStatistics {
    return {
      'app_launches': _appLaunchCount.value,
      'app_version': _appVersion.value,
      'is_dark_mode': _isDarkMode.value,
      'language': _currentLanguage.value,
      'is_initialized': _isAppInitialized.value,
      'is_online': _isInternetConnect.value,
      'user_logged_in': _isLoggedIn.value,
      'user_id': userId,
    };
  }
  
  // ==================== مراقبة دورة حياة التطبيق ====================
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('📱 تغير حالة دورة حياة التطبيق: $state');
    
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
    print('📱 استئناف التطبيق');
    // تحديث حالة الاتصال
    _checkConnectivity();
  }
  
  void _onAppPaused() {
    print('⏸️ إيقاف التطبيق مؤقتاً');
    // حفظ البيانات قبل الإيقاف
    saveUserPreferences();
  }
  
  void _onAppInactive() => print('😴 التطبيق غير نشط');
  void _onAppHidden() => print('🙈 إخفاء التطبيق');
  void _onAppDetached() => print('❌ فصل التطبيق');
  
  Future<void> _checkConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final isConnected = connectivityResult != ConnectivityResult.none;
      
      if (_isInternetConnect.value != isConnected) {
        _isInternetConnect.value = isConnected;
        print('📶 تحديث حالة الاتصال: ${isConnected ? 'متصل' : 'غير متصل'}');
      }
    } catch (e) {
      print('⚠️ خطأ في التحقق من الاتصال: $e');
    }
  }
  
  @override
  void onClose() {
    // إيقاف مراقبة الاتصال
    _connectivitySubscription.cancel();
    
    // إزالة مراقب دورة الحياة
    WidgetsBinding.instance.removeObserver(this);
    
    // حفظ البيانات قبل الإغلاق
    saveUserPreferences();
    
    print('🔚 إغلاق MyAppController');
    super.onClose();
  }
}