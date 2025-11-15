import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/my_app/may_app_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  var obscurePassword = true.obs;
  var emailError = RxString('');
  var passwordError = RxString('');

  void updateEmail(String value) {
    email.value = value;
    emailError.value = '';
  }

  void updatePassword(String value) {
    password.value = value;
    passwordError.value = '';
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  bool validateFields() {
    bool isValid = true;

    if (email.value.isEmpty) {
      emailError.value = 'يرجى إدخال البريد الإلكتروني أو رقم الجوال';
      isValid = false;
    } else {
      // More flexible validation
      if (!isValidEmail(email.value) && !isValidPhone(email.value)) {
        emailError.value = 'يرجى إدخال بريد إلكتروني أو رقم جوال صحيح';
        isValid = false;
      } else {
        emailError.value = '';
      }
    }

    if (password.value.isEmpty) {
      passwordError.value = 'يرجى إدخال كلمة المرور';
      isValid = false;
    } else if (password.value.length < 6) {
      passwordError.value = 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    return isValid;
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPhone(String phone) {
    // Allow various phone formats
    final phoneRegex = RegExp(r'^[0-9\+\(\)\-\s]{10,15}$');
    final cleanPhone = phone.replaceAll(RegExp(r'[\+\-\(\)\s]'), '');
    return phoneRegex.hasMatch(phone) && cleanPhone.length >= 10;
  }

  Future<void> login() async {
    if (!validateFields()) {
      return;
    }

    isLoading.value = true;

    try {
      print('🔑 محاولة تسجيل الدخول للمستخدم: ${email.value}');
      print(
        '📱 نوع المدخل: ${isEmail
            ? "Email"
            : isPhone
            ? "Phone"
            : "Unknown"}',
      );

      final response = await ApiHelper.login(
        email: email.value,
        password: password.value,
        withLoading: false,
      );

      print('📄 استجابة الخادم: $response');

      if (response != null) {
        // Handle different response structures
        if (response['status'] == true || response['success'] == true) {
          final userData = response['user'] ?? response['data'] ?? {};
          final token =
              response['token'] ??
              response['access_token'] ??
              userData['token'];

          if (token != null) {
            userData['token'] = token;
            final MyAppController myAppController = Get.find<MyAppController>();
            myAppController.updateUserData(userData);

            Get.snackbar(
              'نجاح',
              response['message'] ?? 'تم تسجيل الدخول بنجاح',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
            Get.offAllNamed('/mainScreen');
          } else {
            throw Exception('Token not found in response');
          }
        } else {
          _handleApiError(response);
        }
      } else {
        throw Exception('Null response from server');
      }
    } catch (error) {
      print('❌ خطأ في تسجيل الدخول: $error');
      _handleGeneralError(error);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleApiError(dynamic response) {
    String errorMessage = 'فشل تسجيل الدخول. يرجى المحاولة مرة أخرى.';
    if (response != null) {
      if (response['message'] != null) {
        errorMessage = response['message'];
      }
      if (response['errors'] != null) {
        final errors = response['errors'];
        if (errors['email'] != null) {
          emailError.value = errors['email'][0];
        }
        if (errors['password'] != null) {
          passwordError.value = errors['password'][0];
        }
      }
    }
    Get.snackbar(
      'خطأ',
      errorMessage,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _handleGeneralError(dynamic error) {
    print('Login error: $error');
    String errorMessage = 'حدث خطأ أثناء تسجيل الدخول. ';
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage += 'انتهت مهلة الاتصال. يرجى التحقق من اتصال الإنترنت.';
          break;
        case DioExceptionType.badResponse:
          if (error.response?.statusCode == 401) {
            errorMessage = 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
          } else if (error.response?.statusCode == 422) {
            errorMessage = 'بيانات الدخول غير صالحة.';
          } else {
            errorMessage += 'استجابة غير صالحة من الخادم.';
          }
          break;
        case DioExceptionType.cancel:
          errorMessage += 'تم إلغاء الطلب.';
          break;
        case DioExceptionType.unknown:
          errorMessage += 'لا يوجد اتصال بالإنترنت.';
          break;
        default:
          errorMessage += 'خطأ غير معروف.';
      }
    }
    Get.snackbar(
      'خطأ',
      errorMessage,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> socialLogin(String provider) async {
    isLoading.value = true;
    try {
      print('بدء تسجيل الدخول بواسطة: $provider');
      await Future.delayed(Duration(seconds: 2));
      Get.snackbar(
        'نجاح',
        'تم تسجيل الدخول بواسطة $provider',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed('/mainScreen');
    } catch (error) {
      Get.snackbar(
        'خطأ',
        'فشل تسجيل الدخول بواسطة $provider',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void forgotPassword() {
    Get.toNamed('/forget_password');
  }

  void createNewAccount() {
    Get.toNamed('/register');
  }

  bool get isEmail => isValidEmail(email.value);

  bool get isPhone => isValidPhone(email.value);

  Future<void> autoLogin() async {
    final MyAppController myAppController = Get.find<MyAppController>();
    if (myAppController.isLoggedIn) {
      print('🔑 محاولة تسجيل دخول تلقائي...');
      Get.offAllNamed('/mainScreen');
    }
  }

  Future<bool> validateToken() async {
    try {
      final MyAppController myAppController = Get.find<MyAppController>();
      if (!myAppController.isLoggedIn) {
        return false;
      }
      return true;
    } catch (error) {
      print('Token validation error: $error');
      return false;
    }
  }

  @override
  void onClose() {
    email.value = '';
    password.value = '';
    emailError.value = '';
    passwordError.value = '';
    super.onClose();
  }
}
