import '../../../../general_index.dart';

class LoginController extends GetxController {
  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxString emailError = RxString('');
  final RxString passwordError = RxString('');
  final RxInt loginAttempts = 0.obs;
  final RxBool isLoginDisabled = false.obs;
  final Rx<DateTime?> lastLoginAttempt = Rx<DateTime?>(null);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  static const int maxLoginAttempts = 5;
  static const Duration loginTimeoutDuration = Duration(minutes: 15);
  static const Duration snackbarDuration = Duration(seconds: 4);

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
    _checkLoginStatus();
  }

  void _setupListeners() {
    ever(email, (_) => _validateEmail());
    ever(password, (_) => _validatePassword());

    ever(lastLoginAttempt, (DateTime? timestamp) {
      if (timestamp != null) {
        final now = DateTime.now();
        final difference = now.difference(timestamp);
        if (difference > loginTimeoutDuration) {
          _resetLoginAttempts();
        }
      }
    });
  }

  void _checkLoginStatus() {
    final MyAppController myAppController = Get.find<MyAppController>();
    if (myAppController.isLoggedIn.value) {
      _redirectAfterLogin();
    }
  }

  void updateEmail(String value) {
    email.value = value.trim();
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
    final isEmailValid = _validateEmail();
    final isPasswordValid = _validatePassword();

    return isEmailValid && isPasswordValid;
  }

  bool _validateEmail() {
    if (email.value.isEmpty) {
      emailError.value = 'يرجى إدخال البريد الإلكتروني أو رقم الجوال';
      return false;
    }

    if (!isValidEmail(email.value) && !isValidPhone(email.value)) {
      emailError.value = 'يرجى إدخال بريد إلكتروني أو رقم جوال صحيح';
      return false;
    }

    emailError.value = '';
    return true;
  }

  bool _validatePassword() {
    if (password.value.isEmpty) {
      passwordError.value = 'يرجى إدخال كلمة المرور';
      return false;
    }

    if (password.value.length < 6) {
      passwordError.value = 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
      return false;
    }

    passwordError.value = '';
    return true;
  }

  bool isValidEmail(String email) {
    if (email.isEmpty) return false;

    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;

    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    if (cleanPhone.length < 10 || cleanPhone.length > 15) return false;

    return RegExp(r'^[0-9]+$').hasMatch(cleanPhone);
  }

  Future<void> login() async {
    if (!_canAttemptLogin()) {
      _showLoginDisabledMessage();
      return;
    }

    if (!validateFields()) {
      return;
    }

    await _performLogin();
  }

  bool _canAttemptLogin() {
    if (isLoginDisabled.value) {
      final now = DateTime.now();
      final lastAttempt = lastLoginAttempt.value;
      if (lastAttempt != null) {
        final difference = now.difference(lastAttempt);
        if (difference > loginTimeoutDuration) {
          _resetLoginAttempts();
          return true;
        }
      }
      return false;
    }
    return true;
  }

  Future<void> _performLogin() async {
    isLoading.value = true;
    lastLoginAttempt.value = DateTime.now();

    try {
      print('🔑 محاولة تسجيل الدخول للمستخدم: ${email.value}');
      print('📱 نوع المدخل: ${_getInputType()}');

      final response = await ApiHelper.login(
        email: email.value,
        password: password.value,
        withLoading: false,
      ).timeout(const Duration(seconds: 30));

      await _handleLoginResponse(response);
    } catch (error) {
      await _handleLoginError(error);
    } finally {
      isLoading.value = false;
    }
  }

  String _getInputType() {
    if (isEmail) return "Email";
    if (isPhone) return "Phone";
    return "Unknown";
  }

  Future<void> _handleLoginResponse(dynamic response) async {
    print('📄 استجابة الخادم: $response');

    if (response == null) {
      throw Exception('لم يتم استلام استجابة من الخادم');
    }

    if (response['status'] == true || response['success'] == true) {
      await _processSuccessfulLogin(response);
    } else {
      _handleFailedLogin(response);
    }
  }

  Future<void> _processSuccessfulLogin(dynamic response) async {
    final userData = response['user'] ?? response['data'] ?? {};
    final token =
        response['token'] ?? response['access_token'] ?? userData['token'];

    if (token == null) {
      throw Exception('لم يتم العثور على رمز المصادقة في الاستجابة');
    }

    final MyAppController myAppController = Get.find<MyAppController>();
    final completeUserData = Map<String, dynamic>.from(userData)
      ..['token'] = token
      ..['login_time'] = DateTime.now().toString();

    // ✅ Fix: sync session to GetStorage (DataInitializerService depends on it)
    try {
      final storage = Get.find<GetStorage>();
      await storage.write('user_data', {
        'user': Map<String, dynamic>.from(userData),
        'token': token,
        'user_type': (userData['user_type'] ?? '').toString(),
        'login_time': DateTime.now().toIso8601String(),
        'store_id': null,
        'active_store_id': null,
        'store': null,
      });
    } catch (e) {
      print('⚠️ [LOGIN] Failed to sync user_data to GetStorage: $e');
    }

    myAppController.updateUserData(completeUserData);

    await myAppController.onLoginSuccess(completeUserData);

    _resetLoginAttempts();

    _showSuccessMessage(response['message'] ?? 'تم تسجيل الدخول بنجاح');

    await _redirectAfterLogin();
  }

  /// بعد نجاح تسجيل الدخول (أو إذا كان المستخدم مسجل دخول سابقاً)
  /// نتحقق هل تم اختيار متجر أم لا.
  /// - إذا لا يوجد store_id/active_store_id => نذهب لشاشة اختيار المتجر.
  /// - إذا موجود => نكمل إلى الشاشة الرئيسية.
  Future<void> _redirectAfterLogin() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // ✅ Phase 2: تهيئة عامة للجميع
    try {
      await DataInitializerService.to.initializeCoreData(silent: true);
    } catch (_) {}

    final isMerchant = DataInitializerService.to.isMerchantUser;
    final ud = DataInitializerService.to.getUserData();
    final dynamic storeIdRaw = ud['active_store_id'] ?? ud['store_id'];
    final String storeIdStr = storeIdRaw?.toString() ?? '';

    // ✅ للتاجر فقط: لا نعرض شاشة اختيار المتجر بعد تسجيل الدخول.
// إذا لا يوجد متجر فعّال، DataInitializerService يقوم بتعيين المتجر الأول تلقائياً (إن وُجد).
if (isMerchant && storeIdStr.isEmpty) {
  // لا نفعل شيء هنا، سنكمل للرئيسية (وقد تكون قائمة المتاجر فارغة عند حساب جديد)
}
// ✅ للتاجر: تهيئة بيانات المتجر بعد توفر storeId
    if (isMerchant && storeIdStr.isNotEmpty) {
      final sid = int.tryParse(storeIdStr);
      if (sid != null) {
        try {
          await DataInitializerService.to.initializeStoreData(
            storeId: sid,
            silent: true,
          );
        } catch (_) {}
      }
    }

    Get.offAllNamed('/mainScreen');
  }

  void _handleFailedLogin(dynamic response) {
    loginAttempts.value++;

    if (loginAttempts.value >= maxLoginAttempts) {
      isLoginDisabled.value = true;
      _showMaxAttemptsMessage();
    } else {
      _handleApiError(response);
    }
  }

  Future<void> _handleLoginError(dynamic error) async {
    print('❌ خطأ في تسجيل الدخول: $error');

    loginAttempts.value++;

    if (loginAttempts.value >= maxLoginAttempts) {
      isLoginDisabled.value = true;
      _showMaxAttemptsMessage();
      return;
    }

    if (error is TimeoutException) {
      _showErrorSnackbar('انتهت مهلة الاتصال', 'يرجى المحاولة مرة أخرى');
    } else if (error is DioException) {
      _handleDioError(error);
    } else {
      _showErrorSnackbar('خطأ غير متوقع', 'حدث خطأ أثناء تسجيل الدخول');
    }
  }

  void _handleDioError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        _showErrorSnackbar(
          'انتهت مهلة الاتصال',
          'يرجى التحقق من اتصال الإنترنت',
        );
        break;

      case DioExceptionType.badResponse:
        if (statusCode == 401) {
          _showErrorSnackbar(
            'فشل التسجيل',
            'البريد الإلكتروني أو كلمة المرور غير صحيحة',
          );
        } else if (statusCode == 422) {
          _handleValidationErrors(response?.data);
        } else if (statusCode == 500) {
          // _showErrorSnackbar('خطأ في الخادم', 'يرجى المحاولة لاحقاً');
        } else {
          _showErrorSnackbar('خطأ في الاستجابة', 'رمز الخطأ: $statusCode');
        }
        break;

      case DioExceptionType.cancel:
        _showErrorSnackbar('تم الإلغاء', 'تم إلغاء عملية تسجيل الدخول');
        break;

      case DioExceptionType.unknown:
        _showErrorSnackbar('خطأ في الاتصال', 'لا يوجد اتصال بالإنترنت');
        break;

      default:
        _showErrorSnackbar('خطأ غير معروف', 'حدث خطأ أثناء الاتصال بالخادم');
    }
  }

  void _handleValidationErrors(dynamic errorData) {
    if (errorData is Map<String, dynamic>) {
      final errors = errorData['errors'];
      if (errors is Map<String, dynamic>) {
        if (errors['email'] is List) {
          emailError.value = errors['email'].first ?? 'بريد إلكتروني غير صالح';
        }
        if (errors['password'] is List) {
          passwordError.value =
              errors['password'].first ?? 'كلمة مرور غير صالحة';
        }
      }

      if (errorData['message'] != null) {
        _showErrorSnackbar('خطأ في البيانات', errorData['message']);
      }
    }
  }

  void _handleApiError(dynamic response) {
    String errorMessage = 'فشل تسجيل الدخول. يرجى المحاولة مرة أخرى.';

    if (response != null) {
      if (response['message'] != null) {
        errorMessage = response['message'];
      }
      _handleValidationErrors(response);
    }

    _showErrorSnackbar('خطأ', errorMessage);
  }

  void _resetLoginAttempts() {
    loginAttempts.value = 0;
    isLoginDisabled.value = false;
    lastLoginAttempt.value = null;
  }

  void _showSuccessMessage(String message) {
    if (Get.context != null) {
      Get.snackbar(
        'نجاح',
        message,
        backgroundColor: AppColors.success300,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: snackbarDuration,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } else {
      print('✅ نجاح: $message');
    }
  }

  void _showErrorSnackbar(String title, String message) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: snackbarDuration,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } else {
      print('❌ $title: $message');
    }
  }

  void _showLoginDisabledMessage() {
    final lastAttempt = lastLoginAttempt.value;
    if (lastAttempt != null) {
      final now = DateTime.now();
      final difference = loginTimeoutDuration - now.difference(lastAttempt);
      final minutesLeft = difference.inMinutes;

      _showErrorSnackbar(
        'تم تعطيل التسجيل',
        'يرجى الانتظار $minutesLeft دقيقة قبل المحاولة مرة أخرى',
      );
    }
  }

  void _showMaxAttemptsMessage() {
    _showErrorSnackbar(
      'عدد محاولات متجاوز',
      'تم تعطيل التسجيل مؤقتاً بسبب تجاوز عدد المحاولات المسموح بها',
    );
  }

  Future<void> _redirectToMainScreen() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (Get.context != null) {
      Get.offAllNamed('/mainScreen');
    } else {
      print('⚠️ لا يمكن التنقل إلى الشاشة الرئيسية: Get.context غير متوفر');

      await Future.delayed(const Duration(milliseconds: 500));
      if (Get.context != null) {
        Get.offAllNamed('/mainScreen');
      }
    }
  }

  Future<void> socialLogin(String provider) async {
    if (!_canAttemptLogin()) {
      _showLoginDisabledMessage();
      return;
    }

    isLoading.value = true;

    try {
      print('🌐 بدء تسجيل الدخول بواسطة: $provider');

      await Future.delayed(const Duration(seconds: 2));

      _showSuccessMessage('تم تسجيل الدخول بواسطة $provider');

      _resetLoginAttempts();
      await _redirectToMainScreen();
    } catch (error) {
      _showErrorSnackbar('فشل التسجيل', 'فشل تسجيل الدخول بواسطة $provider');
    } finally {
      isLoading.value = false;
    }
  }

  void forgotPassword() {
    if (Get.context != null) {
      Get.toNamed('/forget_password');
    }
  }

  void createNewAccount() {
    if (Get.context != null) {
      Get.toNamed('/register');
    }
  }

  bool get isEmail => isValidEmail(email.value);

  bool get isPhone => isValidPhone(email.value);

  bool get canLogin => !isLoading.value && !isLoginDisabled.value;

  int get remainingAttempts => maxLoginAttempts - loginAttempts.value;

  String get inputType => _getInputType();

  Future<void> autoLogin() async {
    final MyAppController myAppController = Get.find<MyAppController>();
    if (myAppController.isLoggedIn.value) {
      print('🔑 تحميل تسجيل الدخول التلقائي...');
      await _redirectToMainScreen();
    }
  }

  Future<bool> validateToken() async {
    try {
      final MyAppController myAppController = Get.find<MyAppController>();
      if (!myAppController.isLoggedIn.value) {
        return false;
      }

      final token = myAppController.userData['token'];
      return token != null && token is String && token.isNotEmpty;
    } catch (error) {
      print('❌ خطأ في التحقق من رمز المصادقة: $error');
      return false;
    }
  }

  void clearForm() {
    email.value = '';
    password.value = '';
    emailError.value = '';
    passwordError.value = '';
    emailController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
