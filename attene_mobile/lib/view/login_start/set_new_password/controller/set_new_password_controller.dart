import '../../../../general_index.dart';

class SetNewPasswordController extends GetxController {
  final RxString password = ''.obs;
  final RxString confirmPassword = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;
  final RxBool isLoading = false.obs;

  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  void updatePassword(String value) {
    password.value = value;
    if (passwordError.value.isNotEmpty) passwordError.value = '';
  }

  void updateConfirmPassword(String value) {
    confirmPassword.value = value;
    if (confirmPasswordError.value.isNotEmpty) confirmPasswordError.value = '';
  }

  String _sessionId = '';
  String _code = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      _sessionId = (args['sessionId'] ?? args['id'] ?? '').toString();
      _code = (args['code'] ?? '').toString();
    }
  }

  bool validateFields() {
    bool isValid = true;
    if (password.value.trim().length < 6) {
      passwordError.value = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    if (confirmPassword.value.trim() != password.value.trim()) {
      confirmPasswordError.value = 'كلمتا المرور غير متطابقتين';
      isValid = false;
    } else {
      confirmPasswordError.value = '';
    }

    if (_sessionId.isEmpty || _code.isEmpty) {
      Get.snackbar(
        'خطأ',
        'بيانات التحقق غير مكتملة، أعد طلب كود جديد',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isValid = false;
    }
    return isValid;
  }

  Future<void> submitNewPassword() async {
    if (!validateFields()) return;

    isLoading.value = true;
    try {
      final response = await ApiHelper.verifyPasswordResetCode(
        id: _sessionId,
        code: _code,
        newPassword: password.value.trim(),
        withLoading: true,
      );

      if (response is Map && response['status'] == true) {
        Get.snackbar(
          'تم',
          response['message'] ?? 'تم تحديث كلمة المرور بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed('/login');
      } else {
        final msg = (response is Map)
            ? (response['message'] ?? 'فشل تحديث كلمة المرور')
            : 'فشل تحديث كلمة المرور';

        Get.snackbar(
          'خطأ',
          msg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
