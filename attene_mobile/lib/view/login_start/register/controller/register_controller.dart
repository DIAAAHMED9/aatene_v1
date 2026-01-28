import '../../../../general_index.dart';

class RegisterController extends GetxController {
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

  // =========================
  // Live validators (helpers)
  // =========================

  String? _validateEmailLive(String value) {
    final v = value.trim();

    if (v.isEmpty) return 'يرجى إدخال البريد الإلكتروني';

    if (!v.contains('@')) return 'البريد الإلكتروني يجب أن يحتوي على @';

    // لازم يكون فيه جزء قبل وبعد @
    final parts = v.split('@');
    if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }

    // الدومين لازم يحتوي نقطة "."
    final domain = parts[1];
    if (!domain.contains('.')) return 'أكمل الدومين مثل example.com';

    // لازم يكون فيه امتداد (TLD) بعد آخر نقطة (مثل com, net, org...)
    final lastDot = domain.lastIndexOf('.');
    if (lastDot == -1 || lastDot == domain.length - 1) {
      return 'أدخل الامتداد مثل .com';
    }

    final tld = domain.substring(lastDot + 1);
    if (tld.length < 2) return 'امتداد غير صحيح (مثل .com)';

    // تحقق عام بسيط إضافي: لا يسمح بمسافات
    if (v.contains(' ')) return 'البريد الإلكتروني لا يجب أن يحتوي مسافات';

    return null;
  }

  String? _validatePhoneLive(String value) {
    final v = value.trim();

    if (v.isEmpty) return 'يرجى إدخال رقم الجوال';

    // فقط أرقام
    if (!RegExp(r'^\d+$').hasMatch(v)) return 'رقم الجوال يجب أن يحتوي أرقام فقط';

    // عندك طلب واضح: أقل من 11 يظهر خطأ
    if (v.length < 11) return 'رقم الهاتف أقل من 11 رقم';

    // لو بدك حد أعلى (اختياري)
    if (v.length > 15) return 'رقم الجوال طويل جدًا (15 رقم كحد أقصى)';

    return null;
  }

  String? _validateNameLive(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'يرجى إدخال الاسم الكامل';
    if (v.length < 2) return 'الاسم يجب أن يكون على الأقل حرفين';
    return null;
  }

  String? _validatePasswordLive(String value) {
    final v = value;
    if (v.isEmpty) return 'يرجى إدخال كلمة المرور';
    if (v.length < 6) return 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
    return null;
  }

  String? _validateConfirmPasswordLive(String value) {
    final v = value;
    if (v.isEmpty) return 'يرجى تأكيد كلمة المرور';
    if (password.value.isNotEmpty && v != password.value) return 'كلمة المرور غير متطابقة';
    return null;
  }

  // =========================
  // OnChanged handlers (Live)
  // =========================

  void updateEmail(String value) {
    email.value = value;

    // ✅ Live validation
    final err = _validateEmailLive(value);
    emailError.value = err ?? '';
  }

  void updateName(String value) {
    name.value = value;

    final err = _validateNameLive(value);
    nameError.value = err ?? '';
  }

  void updatePhone(String value) {
    // لو بدك تمنع غير الأرقام من البداية:
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');

    phone.value = cleaned;

    // ✅ Live validation
    final err = _validatePhoneLive(cleaned);
    phoneError.value = err ?? '';
  }

  void updatePassword(String value) {
    password.value = value;

    final err = _validatePasswordLive(value);
    passwordError.value = err ?? '';

    // ✅ Live update confirm password match مثل ما بدك
    if (confirmPassword.value.isNotEmpty) {
      final cErr = _validateConfirmPasswordLive(confirmPassword.value);
      confirmPasswordError.value = cErr ?? '';
    }
  }

  void updateConfirmPassword(String value) {
    confirmPassword.value = value;

    final err = _validateConfirmPasswordLive(value);
    confirmPasswordError.value = err ?? '';
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  // =========================
  // Final validation on submit
  // =========================
  bool validateFields() {
    bool isValid = true;

    final nErr = _validateNameLive(name.value);
    nameError.value = nErr ?? '';
    if (nErr != null) isValid = false;

    final eErr = _validateEmailLive(email.value);
    emailError.value = eErr ?? '';
    if (eErr != null) isValid = false;

    final pErr = _validatePhoneLive(phone.value);
    phoneError.value = pErr ?? '';
    if (pErr != null) isValid = false;

    final passErr = _validatePasswordLive(password.value);
    passwordError.value = passErr ?? '';
    if (passErr != null) isValid = false;

    final cErr = _validateConfirmPasswordLive(confirmPassword.value);
    confirmPasswordError.value = cErr ?? '';
    if (cErr != null) isValid = false;

    return isValid;
  }

  Future<void> register() async {
    if (!validateFields()) return;

    isLoading.value = true;

    try {
      final response = await ApiHelper.register(
        name: name.value.trim(),
        email: email.value.trim(),
        phone: phone.value.trim(),
        password: password.value,
        passwordConfirmation: confirmPassword.value,
        withLoading: false,
      );

      if (response != null && response['status'] == true) {
        final Map<String, dynamic>? userData =
            (response['user'] is Map) ? Map<String, dynamic>.from(response['user']) : null;
        final String? token = response['token']?.toString();

        if (token != null && token.isNotEmpty) {
          final storage = GetStorage();
          await storage.write('auth_token', token);
          await storage.write('user_data', userData ?? {});
          await storage.write('is_guest', false);
          await storage.write('has_completed_onboarding', true);

          if (Get.isRegistered<MyAppController>()) {
            final myAppController = Get.find<MyAppController>();
            myAppController.updateUserData(userData ?? {});
          }
        }

        Get.snackbar(
          'نجاح',
          'تم إنشاء الحساب بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(milliseconds: 1200));

        if (token != null && token.isNotEmpty) {
          Get.offAllNamed('/mainScreen');
        } else {
          Get.toNamed('/login');
        }
      } else {
        _handleApiError(response);
      }
    } catch (error) {
      _handleGeneralError(error);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleApiError(dynamic response) {
    String errorMessage = 'فشل إنشاء الحساب. يرجى المحاولة مرة أخرى.';

    if (response != null && response['errors'] != null) {
      final errors = response['errors'];

      // هذه قد تكون Arrays
      if (errors is Map) {
        if (errors['email'] != null && errors['email'] is List && errors['email'].isNotEmpty) {
          emailError.value = errors['email'][0].toString();
        }
        if (errors['name'] != null && errors['name'] is List && errors['name'].isNotEmpty) {
          nameError.value = errors['name'][0].toString();
        }
        if (errors['phone'] != null && errors['phone'] is List && errors['phone'].isNotEmpty) {
          phoneError.value = errors['phone'][0].toString();
        }
        if (errors['password'] != null && errors['password'] is List && errors['password'].isNotEmpty) {
          passwordError.value = errors['password'][0].toString();
        }
      }

      if (response['message'] != null) {
        errorMessage = response['message'].toString();
      }
    } else if (response != null && response['message'] != null) {
      errorMessage = response['message'].toString();
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
    String errorMessage = 'حدث خطأ أثناء إنشاء الحساب.';

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = 'انتهت مهلة الاتصال. تحقق من الإنترنت.';
          break;
        case DioExceptionType.badResponse:
          errorMessage = 'استجابة غير صالحة من الخادم.';
          break;
        case DioExceptionType.cancel:
          errorMessage = 'تم إلغاء الطلب.';
          break;
        case DioExceptionType.unknown:
          errorMessage = error.toString().contains('SocketException')
              ? 'لا يوجد اتصال بالإنترنت.'
              : 'حدث خطأ غير معروف.';
          break;
        default:
          errorMessage = 'حدث خطأ غير معروف.';
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

  void goToLogin() {
    Get.offAllNamed('/login');
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
