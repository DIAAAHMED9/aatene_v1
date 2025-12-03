import 'package:attene_mobile/controller/product_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyAppController extends GetxController {
  var isInternetConnect = true.obs;
  var noInternetWaitingRequests = <Map<String, dynamic>>[].obs;
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  final RxBool isLoggedIn = false.obs;
  final RxBool isAppInitialized = false.obs;
  final RxBool _isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();

  }

  Future<void> _initializeApp() async {
    if (isAppInitialized.value) return;
    
    _isLoading.value = true;
    print('🚀 Starting app initialization...');
    
    try {
      print('📱 Initializing Firebase...');
      await Future.delayed(Duration(milliseconds: 500));
      
      print('💾 Loading user preferences...');
      await _loadUserPreferences();
      
      print('🔐 Checking authentication...');
      _checkLoginStatus();
      
      isAppInitialized.value = true;
      print('✅ App initialization completed successfully');
    } catch (e) {
      print('❌ App initialization failed: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadUserPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      
      if (userDataString != null && userDataString.isNotEmpty) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(json.decode(userDataString));
        userData.assignAll(data);
        print('📂 Loaded user data from local storage');
      } else {
        print('ℹ️ No user data found in local storage');
      }
    } catch (e) {
      print('❌ Error loading user preferences: $e');
    }
  }

  Future<void> _saveUserPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', json.encode(userData));
      print('💾 Saved user data to local storage');
    } catch (e) {
      print('❌ Error saving user preferences: $e');
    }
  }

  void _checkLoginStatus() {
    final token = userData['token'];
    final wasLoggedIn = isLoggedIn.value;
    isLoggedIn.value = token != null && token is String && token.isNotEmpty;
    
    print('🔐 Login status: ${isLoggedIn.value}');
    
    if (isLoggedIn.value && !wasLoggedIn) {
      print('✅ User authentication validated');
      _notifyControllersOnLogin();
    } else if (!isLoggedIn.value && wasLoggedIn) {
      print('❌ User logged out');
      _notifyControllersOnLogout();
    }
  }

  void updateUserData(Map<String, dynamic> newData) {
    userData.assignAll(newData);
    _checkLoginStatus();
    _saveUserPreferences();
  }

  void clearUserData() {
    userData.clear();
    isLoggedIn.value = false;
    _clearLocalStorage();
    _notifyControllersOnLogout();
  }

  Future<void> _clearLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      print('🗑️ Cleared user data from local storage');
    } catch (e) {
      print('❌ Error clearing local storage: $e');
    }
  }

  void _notifyControllersOnLogin() {
    print('🔔 Notifying controllers of login state change');
  }

  void _notifyControllersOnLogout() {
    print('🔔 Notifying controllers of logout');
  }

  void updateInternetStatus(bool status) {
    isInternetConnect.value = status;
  }

  void onSignOut() {
    userData.value = {};
    noInternetWaitingRequests.clear();
    clearUserData();
  }

  String? get token => userData['token'];
  
  bool get isLoading => _isLoading.value;
Future<void> checkAndRedirectIfLoggedIn() async {
  if (isLoggedIn.value && !Get.currentRoute.contains('/mainScreen')) {
    print('🔄 المستخدم مسجل دخول، التوجيه إلى الشاشة الرئيسية...');
    await Future.delayed(const Duration(milliseconds: 500));
    Get.offAllNamed('/mainScreen');
  }
}
  @override
  void onClose() {
    noInternetWaitingRequests.clear();
    super.onClose();
  }
}