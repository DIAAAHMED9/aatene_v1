import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/core/api_helper.dart';

class MyAppController extends GetxController with WidgetsBindingObserver {
  static MyAppController get to => Get.find<MyAppController>();

  final RxBool isInternetConnect = true.obs;

  final RxString _token = ''.obs;

  final RxMap<String, dynamic> _userData = <String, dynamic>{}.obs;

  final RxBool _isLoggedIn = false.obs;
  final RxBool _isAppInitialized = false.obs;

  RxString get token => _token;
  RxMap<String, dynamic> get userData => _userData;

  bool get isAuthenticated => _isLoggedIn.value;
  RxBool get isLoggedIn => _isLoggedIn;

  bool get isInitialized => _isAppInitialized.value;
  RxBool get isAppInitialized => _isAppInitialized;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    initializeApp();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  Future<void> initializeApp() async {
    await _loadFromStorage();
    _isAppInitialized.value = true;

    if (_token.value.isNotEmpty) {
      await refreshAccount();
    }
  }
Future<void> onSignOut({bool redirectToLogin = true}) async {
  await clearAuth();

  if (redirectToLogin) {
    Get.offAllNamed('/login');
  }
}

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();

    _token.value = prefs.getString('token') ?? '';
    _isLoggedIn.value = _token.value.isNotEmpty;

    final userJson = prefs.getString('user_data');
    if (userJson != null && userJson.trim().isNotEmpty) {
      try {
        final decoded = json.decode(userJson);
        if (decoded is Map) {
          _userData.value = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
      }
    }
  }

  void setInternetConnection(bool connected) {
    isInternetConnect.value = connected;
  }

  Future<void> setAuth({
    required String token,
    Map<String, dynamic>? user,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    _token.value = token;
    _isLoggedIn.value = token.isNotEmpty;
    await prefs.setString('token', token);

    if (user != null) {
      await updateUserData(user);
    }
  }

  Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();

    _token.value = '';
    _isLoggedIn.value = false;
    _userData.clear();

    await prefs.remove('token');
    await prefs.remove('user_data');
  }

  Future<void> updateUserData(Map<String, dynamic> newData) async {
    final merged = Map<String, dynamic>.from(_userData);
    merged.addAll(Map<String, dynamic>.from(newData));
    _userData.value = merged;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(_userData.value));
  }

  Future<void> onLoginSuccess(
    Map<String, dynamic> completeUserData, {
    String? token,
  }) async {
    if (token != null && token.trim().isNotEmpty) {
      await setAuth(token: token.trim(), user: completeUserData);
    } else {
      await updateUserData(completeUserData);
      _isLoggedIn.value = _token.value.isNotEmpty;
    }

    await refreshAccount();
  }

  Future<void> refreshAccount() async {
    if (_token.value.isEmpty) return;

    final response = await ApiHelper.account(withLoading: false);

    if (response is Map && response['status'] == true) {
      final data = response['data'];
      if (data is Map) {
        await updateUserData(Map<String, dynamic>.from(data));
      }
    }
  }
}