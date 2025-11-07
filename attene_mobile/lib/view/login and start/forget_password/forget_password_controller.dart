import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  var email = ''.obs;
  var isLoading = false.obs;
  var emailError = RxString('');

  void updateEmail(String value) {
    email.value = value;
    emailError.value = '';
  }

  bool validateFields() {
    bool isValid = true;
    if (email.value.isEmpty) {
      emailError.value = 'يرجى إدخال البريد الإلكتروني';
      isValid = false;
    } else if (!isValidEmail(email.value)) {
      emailError.value = 'يرجى إدخال بريد إلكتروني صحيح';
      isValid = false;
    } else {
      emailError.value = '';
    }
    return isValid;
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> sendPasswordReset() async {
    if (!validateFields()) {
      return;
    }
    isLoading.value = true;
    try {
      await Future.delayed(Duration(seconds: 2));
      Get.toNamed('/verification');
      Get.snackbar(
        'نجاح',
        'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل إرسال طلب إعادة التعيين. يرجى التحقق من البريد الإلكتروني والمحاولة مرة أخرى.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    email.value = '';
    emailError.value = '';
    super.onClose();
  }
}
