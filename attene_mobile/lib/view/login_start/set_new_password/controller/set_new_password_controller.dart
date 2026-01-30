import '../../../../general_index.dart';

class SetNewPasswordController extends GetxController {
  final RxString password = ''.obs;
  final RxString confirmPassword = ''.obs;

  final RxString passwordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;

  final RxBool isLoading = false.obs;

  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

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
      _sessionId = (args['sessionId'] ?? args['id'] ?? '').toString().trim();
      _code = (args['code'] ?? args['otp'] ?? '').toString().trim();
    }
  }

  bool validateFields() {
    bool isValid = true;

    final p = password.value.trim();
    final pc = confirmPassword.value.trim();

    if (p.isEmpty) {
      passwordError.value = 'يرجى إدخال كلمة المرور';
      isValid = false;
    } else if (p.length < 6) {
      passwordError.value = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    if (pc.isEmpty) {
      confirmPasswordError.value = 'يرجى تأكيد كلمة المرور';
      isValid = false;
    } else if (pc != p) {
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

    final p = password.value.trim();
    final pc = confirmPassword.value.trim();

    isLoading.value = true;
    try {
      final response = await ApiHelper.verifyPasswordResetCode(
        id: _sessionId,
        code: _code,
        newPassword: p,
        passwordConfirmation: pc,
        withLoading: true,
        shouldShowMessage: true,
      );

      final ok = (response is Map) && (response['status'] == true);

      if (ok) {
        Get.snackbar(
          'تم',
          (response['message'] ?? 'تم تحديث كلمة المرور بنجاح').toString(),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed('/login');
        return;
      }

      final msg = (response is Map && response['message'] != null)
          ? response['message'].toString()
          : 'فشل تحديث كلمة المرور';

      Get.snackbar(
        'خطأ',
        msg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
