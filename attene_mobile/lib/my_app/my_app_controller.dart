import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';



class MyAppController extends GetxController with WidgetsBindingObserver {
  static MyAppController get to => Get.find();

  final RxBool _isLoggedIn = false.obs;
  final RxMap<String, dynamic> _userData = <String, dynamic>{}.obs;
  final RxBool _isLoading = false.obs;

  final RxBool _isAppInitialized = false.obs;
  final RxBool _isInternetConnect = true.obs;
  final RxBool _isDarkMode = false.obs;
  final RxString _currentLanguage = 'ar'.obs;

  final RxInt _appLaunchCount = 0.obs;
  final RxString _appVersion = '1.0.0'.obs;

  /// ⚠️ connectivity_plus (الإصدارات الحديثة) يرجّع List<ConnectivityResult>
  /// لذلك نجعل الاشتراك nullable لتفادي LateInitializationError عند فشل التهيئة.
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    print('🔄 بدء تهيئة MyAppController');

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      _isLoading.value = true;

      await _loadUserData();

      await _loadAppSettings();

      await _startConnectivityMonitoring();

      _isAppInitialized.value = true;

      print('✅ تم تهيئة التطبيق بنجاح');
      print(
        '👤 حالة المستخدم: ${_isLoggedIn.value ? 'مسجل دخول' : 'غير مسجل'}',
      );
    } catch (e) {
      print('❌ خطأ في تهيئة التطبيق: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _startConnectivityMonitoring() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final bool isConnected = !results.contains(ConnectivityResult.none);
      _isInternetConnect.value = isConnected;

      print(
        '📶 حالة الاتصال الحالية: ${_isInternetConnect.value ? 'متصل' : 'غير متصل'}',
      );

      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (List<ConnectivityResult> results) {
          final bool isConnected = !results.contains(ConnectivityResult.none);

          if (_isInternetConnect.value != isConnected) {
            _isInternetConnect.value = isConnected;
            print(
              '📶 تغير حالة الاتصال: ${isConnected ? 'متصل' : 'غير متصل'}',
            );

            if (isConnected) {
              _onInternetRestored();
            } else {
              _onInternetLost();
            }
          }
        },
      );

      print('📡 بدء مراقبة الاتصال بالإنترنت');
    } catch (e) {
      print('⚠️ خطأ في مراقبة الاتصال: $e');
    }
  }

  void _onInternetRestored() {
    print('🌐 استعادة الاتصال بالإنترنت');
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

  RxBool get isLoggedIn => _isLoggedIn;

  RxBool get isAppInitialized => _isAppInitialized;

  RxBool get isInternetConnect => _isInternetConnect;

  Map<String, dynamic> get userData => _userData;

  bool get isLoading => _isLoading.value;

  String? get token => _userData['token'];

  String? get userId =>
      _userData['id']?.toString() ?? _userData['_id']?.toString();

  void updateUserData(Map<String, dynamic> newData) {
    final Map<String, dynamic> mergedData = Map.from(_userData)
      ..addAll(newData);
    _userData.value = mergedData;
    _isLoggedIn.value = true;

    _saveUserData();

    print('✅ تم تحديث بيانات المستخدم');
    print('📊 البيانات: ${newData.keys.join(', ')}');
  }

  Future<void> onLoginSuccess(Map<String, dynamic> userData) async {
    try {
      _isLoading.value = true;

      print('🎉 معالجة نجاح تسجيل الدخول');

      updateUserData(userData);

      await _loadAdditionalUserData();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'last_login_time',
        DateTime.now().toIso8601String(),
      );

      await _incrementLoginCount();

      print('✅ تم تسجيل الدخول بنجاح للمستخدم: ${userData['email'] ?? userId}');

      _notifyLoginSuccess();
    } catch (e) {
      print('❌ خطأ في معالجة تسجيل الدخول: $e');
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  void _notifyLoginSuccess() {
    print('📢 إشعار تسجيل الدخول للمتحكمات الأخرى');
  }

  Future<void> _loadAdditionalUserData() async {
    try {
      print('🔄 جاري تحميل البيانات الإضافية للمستخدم...');

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

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      final userDataString = prefs.getString('user_data');

      if (userDataString != null && isLoggedIn) {
        final decodedData = json.decode(userDataString) as Map<String, dynamic>;
        _userData.value = decodedData;
        _isLoggedIn.value = isLoggedIn;

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
      await onSignOut();
    }
  }

  Future<void> _loadAppSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _isDarkMode.value = prefs.getBool('dark_mode') ?? false;
      _currentLanguage.value = prefs.getString('language') ?? 'ar';
      _appLaunchCount.value = prefs.getInt('app_launch_count') ?? 0;
      _appVersion.value = prefs.getString('app_version') ?? '1.0.0';

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

  Future<void> onSignOut() async {
    print('🔐 تنفيذ onSignOut بسبب انتهاء الجلسة');
    await _performSignOut(showMessage: true);
  }

  Future<void> logout() async {
    print('👋 تنفيذ logout من قبل المستخدم');
    await _performSignOut(showMessage: false);
  }

  Future<void> _performSignOut({bool showMessage = true}) async {
    try {
      _isLoading.value = true;

      print('🔄 بدء عملية تسجيل الخروج...');

      try {} catch (e) {
        print('⚠️ خطأ في طلب تسجيل الخروج للخادم: $e');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      await prefs.setBool('is_logged_in', false);

      // ✅ Also clear GetStorage session (used by DataInitializerService)
      try {
        if (Get.isRegistered<GetStorage>()) {
          final s = Get.find<GetStorage>();
          await s.remove('user_data');
        }
      } catch (_) {}

      _userData.clear();
      _isLoggedIn.value = false;

      print('✅ تم تسجيل الخروج بنجاح');

      // if (showMessage) {
      //   Get.snackbar(
      //     'انتهت الجلسة',
      //     'يرجى تسجيل الدخول مرة أخرى',
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.orange,
      //     colorText: Colors.white,
      //     duration: const Duration(seconds: 3),
      //   );
      // }

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

  Future<bool> _validateToken() async {
    try {
      final token = _userData['token'];
      if (token == null || token.isEmpty) return false;

      return true;
    } catch (e) {
      print('⚠️ خطأ في التحقق من صلاحية التوكن: $e');
      return false;
    }
  }

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

  Future<void> changeLanguage(String languageCode) async {
    try {
      if (languageCode != _currentLanguage.value) {
        _currentLanguage.value = languageCode;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('language', languageCode);

        print('🌍 تغيير اللغة إلى: $languageCode');

        Get.updateLocale(Locale(languageCode));
      }
    } catch (e) {
      print('❌ خطأ في تغيير اللغة: $e');
    }
  }

  bool hasPermission(String permission) {
    final permissions = _userData['permissions'] as List<dynamic>?;
    return permissions?.contains(permission) ?? false;
  }

  bool hasRole(String role) {
    final roles = _userData['roles'] as List<dynamic>?;
    return roles?.contains(role) ?? false;
  }

  void updateSpecificData(String key, dynamic value) {
    _userData[key] = value;
    _saveUserData();
    print('📝 تم تحديث $key: $value');
  }

  dynamic getUserData(String key) {
    return _userData[key];
  }

  String get fullName {
    if (_userData['full_name'] != null) return _userData['full_name'];
    if (_userData['first_name'] != null && _userData['last_name'] != null) {
      return '${_userData['first_name']} ${_userData['last_name']}';
    }
    return _userData['email'] ?? _userData['phone'] ?? 'مستخدم';
  }

  String? get profileImage {
    return _userData['profile_image'] ??
        _userData['avatar'] ??
        _userData['image_url'];
  }

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
    _checkConnectivity();
  }

  void _onAppPaused() {
    print('⏸️ إيقاف التطبيق مؤقتاً');
    saveUserPreferences();
  }

  void _onAppInactive() => print('😴 التطبيق غير نشط');

  void _onAppHidden() => print('🙈 إخفاء التطبيق');

  void _onAppDetached() => print('❌ فصل التطبيق');

  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final bool isConnected = !results.contains(ConnectivityResult.none);

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
    try {
      _connectivitySubscription?.cancel();
      _connectivitySubscription = null;
    } catch (_) {}

    WidgetsBinding.instance.removeObserver(this);

    saveUserPreferences();

    print('🔚 إغلاق MyAppController');
    super.onClose();
  }
}