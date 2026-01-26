import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class VerificationController extends GetxController {
  var codes = List<String>.filled(5, '').obs;
  var isLoading = false.obs;
  var errorMessage = RxString('');
  var isVerified = false.obs;
  var canResend = false.obs;
  var resendCountdown = 60.obs;
  List<FocusNode> focusNodes = List.generate(5, (index) => FocusNode());

  @override
  void onInit() {
    super.onInit();
    startCountdown();
  }

  void startCountdown() {
    canResend.value = false;
    resendCountdown.value = 60;
  }

  void updateCode(int index, String value) {
    if (value.length <= 1) {
      codes[index] = value;
      errorMessage.value = '';
      if (value.isNotEmpty && index < 4) {
        Future.delayed(Duration(milliseconds: 50), () {
          focusNodes[index + 1].requestFocus();
        });
      }
      if (value.isEmpty && index > 0) {
        Future.delayed(Duration(milliseconds: 50), () {
          focusNodes[index - 1].requestFocus();
        });
      }
      if (isAllFieldsFilled()) {
        focusNodes[index].unfocus();
        verifyCode();
      }
    }
  }

  bool isAllFieldsFilled() {
    return codes.every((code) => code.isNotEmpty);
  }

  String getFullCode() {
    return codes.join();
  }

  bool validateFields() {
    if (!isAllFieldsFilled()) {
      errorMessage.value = 'يرجى إدخال جميع الأرقام';
      for (int i = 0; i < codes.length; i++) {
        if (codes[i].isEmpty) {
          focusNodes[i].requestFocus();
          break;
        }
      }
      return false;
    }
    errorMessage.value = '';
    return true;
  }

  Future<void> verifyCode() async {
    if (!validateFields()) {
      return;
    }
    isLoading.value = true;
    try {
      await Future.delayed(Duration(seconds: 2));
      String enteredCode = getFullCode();
      if (enteredCode == "12345") {
        isVerified.value = true;
        Get.snackbar(
          'نجاح',
          'تم التحقق بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed('/set_new_password');
      } else {
        errorMessage.value = 'رمز التحقق غير صحيح';
        resetFields();
        focusNodes[0].requestFocus();
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء التحقق';
      resetFields();
    } finally {
      isLoading.value = false;
    }
  }

  void resetFields() {
    for (int i = 0; i < codes.length; i++) {
      codes[i] = '';
    }
  }

  Future<void> resendCode() async {
    isLoading.value = true;
    try {
      await Future.delayed(Duration(seconds: 1));
      resetFields();
      focusNodes[0].requestFocus();
      errorMessage.value = '';
      startCountdown();
      Get.snackbar(
        'تم الإرسال',
        'تم إرسال رمز تحقق جديد إلى بريدك الإلكتروني',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل إعادة إرسال الرمز',
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
    for (var node in focusNodes) {
      node.dispose();
    }
    resetFields();
    errorMessage.value = '';
    super.onClose();
  }
}