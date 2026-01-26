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
    print('Register function called');

    if (!validateFields()) {
      print('Register Failed - Validation failed');
      return;
    }

    isLoading.value = true;

    try {
      print('Sending registration request...');

      final response = await ApiHelper.post(
        path: '/auth/register',
        body: {
          'first_name': name.value,
          'last_name': name.value,
          'email': email.value,
          'phone': phone.value,
          'password': password.value,
          'device_name': 'mobile',
        },
        withLoading: false,
        shouldShowMessage: false,
      );

      print('API Response: $response');

      if (response != null && response['status'] == true) {
        print('Registration successful');

        final userData = response['user'];
        final token = response['token'];

        final MyAppController myAppController = Get.find<MyAppController>();
        myAppController.updateUserData(userData);

        Get.snackbar(
          'نجاح',
          'تم إنشاء الحساب بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(milliseconds: 1500));

        print('Navigating to login screen...');
        Get.toNamed('/login');
      } else {
        print('Registration failed with response: $response');
        _handleApiError(response);
      }
    } catch (error) {
      print('Registration error: $error');
      _handleGeneralError(error);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleApiError(dynamic response) {
    print('Handling API error: $response');

    String errorMessage = 'فشل إنشاء الحساب. يرجى المحاولة مرة أخرى.';

    if (response != null && response['errors'] != null) {
      final errors = response['errors'];
      if (errors['email'] != null) {
        emailError.value = errors['email'][0];
      }
      if (errors['name'] != null) {
        nameError.value = errors['name'][0];
      }
      if (errors['phone'] != null) {
        phoneError.value = errors['phone'][0];
      }
      if (errors['password'] != null) {
        passwordError.value = errors['password'][0];
      }
      if (errors['message'] != null) {
        errorMessage = errors['message'];
      } else if (response['message'] != null) {
        errorMessage = response['message'];
      }
    } else if (response != null && response['message'] != null) {
      errorMessage = response['message'];
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
    print('Register error: $error');
    String errorMessage = 'حدث خطأ أثناء إنشاء الحساب. ';

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage += 'انتهت مهلة الاتصال. يرجى التحقق من اتصال الإنترنت.';
          break;
        case DioExceptionType.badResponse:
          errorMessage += 'استجابة غير صالحة من الخادم.';
          break;
        case DioExceptionType.cancel:
          errorMessage += 'تم إلغاء الطلب.';
          break;
        case DioExceptionType.unknown:
          if (error.toString().contains('SocketException')) {
            errorMessage += 'لا يوجد اتصال بالإنترنت.';
          } else {
            errorMessage += 'خطأ غير معروف.';
          }
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

  void goToLogin() {
    print('Navigating to login...');
    Get.offAllNamed('/mainScreen');
  }

  Future<bool> checkUserExists() async {
    try {
      final response = await ApiHelper.post(
        path: '/auth/check-email',
        body: {'email': email.value},
        withLoading: false,
        shouldShowMessage: false,
      );
      return response != null && response['exists'] == true;
    } catch (error) {
      print('Check user exists error: $error');
      return false;
    }
  }

  Future<bool> checkPhoneExists() async {
    try {
      final response = await ApiHelper.post(
        path: '/auth/check-phone',
        body: {'phone': phone.value},
        withLoading: false,
        shouldShowMessage: false,
      );
      return response != null && response['exists'] == true;
    } catch (error) {
      print('Check phone exists error: $error');
      return false;
    }
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
