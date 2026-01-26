import 'package:flutter/material.dart';
import 'package:get/get.dart';



class SetNewPasswordController extends GetxController {
  var email = ''.obs;
  var name = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var phone = ''.obs;
  var isLoading = false.obs;
  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;
  var emailError = RxString('');
  var nameError = RxString('');
  var passwordError = RxString('');
  var confirmPasswordError = RxString('');
  var phoneError = RxString('');

  void updateEmail(String value) {
    email.value = value;
    emailError.value = '';
  }

  void updateName(String value) {
    name.value = value;
    nameError.value = '';
  }

  void updatePhone(String value) {
    phone.value = value;
    phoneError.value = '';
  }

  void updatePassword(String value) {
    password.value = value;
    passwordError.value = '';
    if (confirmPassword.value.isNotEmpty) {
      confirmPasswordError.value = confirmPassword.value == value
          ? ''
          : 'كلمة المرور غير متطابقة';
    }
  }

  void updateConfirmPassword(String value) {
    confirmPassword.value = value;
    confirmPasswordError.value = value == password.value
        ? ''
        : 'كلمة المرور غير متطابقة';
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  bool validateFields() {
    bool isValid = true;
    if (name.value.isEmpty) {
      nameError.value = 'يرجى إدخال الاسم الكامل';
      isValid = false;
    } else if (name.value.length < 2) {
      nameError.value = 'الاسم يجب أن يكون على الأقل حرفين';
      isValid = false;
    } else {
      nameError.value = '';
    }
    if (email.value.isEmpty) {
      emailError.value = 'يرجى إدخال البريد الإلكتروني';
      isValid = false;
    } else if (!isValidEmail(email.value)) {
      emailError.value = 'يرجى إدخال بريد إلكتروني صحيح';
      isValid = false;
    } else {
      emailError.value = '';
    }
    if (phone.value.isEmpty) {
      phoneError.value = 'يرجى إدخال رقم الجوال';
      isValid = false;
    } else if (!isValidPhoneNumber(phone.value)) {
      phoneError.value = 'يرجى إدخال رقم جوال صحيح (10-15 رقم)';
      isValid = false;
    } else {
      phoneError.value = '';
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
    if (confirmPassword.value.isEmpty) {
      confirmPasswordError.value = 'يرجى تأكيد كلمة المرور';
      isValid = false;
    } else if (confirmPassword.value != password.value) {
      confirmPasswordError.value = 'كلمة المرور غير متطابقة';
      isValid = false;
    } else {
      confirmPasswordError.value = '';
    }
    return isValid;
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    return phoneRegex.hasMatch(phone);
  }

  Future<void> register() async {
    if (!validateFields()) {
      return;
    }
    isLoading.value = true;
    try {
      await Future.delayed(Duration(seconds: 2));
      Get.offAllNamed('/mainScreen');
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل إنشاء الحساب. يرجى التحقق من البيانات والمحاولة مرة أخرى.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.toNamed('/login');
  }

  @override
  void onClose() {
    email.value = '';
    name.value = '';
    phone.value = '';
    password.value = '';
    confirmPassword.value = '';
    emailError.value = '';
    nameError.value = '';
    phoneError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    super.onClose();
  }
}