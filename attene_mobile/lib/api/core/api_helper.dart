




import 'dart:convert';

import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../general_index.dart';

export 'package:get/get.dart' hide FormData, MultipartFile,Response;

class ApiHelper {
  /// Whether the current logged-in user is a merchant (has stores endpoints).
  /// Safe to call on web/mobile and does not throw.
  static bool get isMerchantUser {
    try {
      final storage = GetStorage();
      final raw = storage.read('user_data');
      final Map<String, dynamic> user = (raw is Map)
          ? Map<String, dynamic>.from(raw as Map)
          : <String, dynamic>{};
      // Common backends: role, type, guard, user_type, is_merchant ...
      final role = (user['role'] ?? user['type'] ?? user['guard'] ?? user['user_type'] ?? '')
          .toString()
          .toLowerCase();
      if (role.contains('merchant') || role.contains('vendor') || role == 'store') return true;
      final isMerchant = user['is_merchant'];
      if (isMerchant is bool) return isMerchant;
      if (isMerchant is num) return isMerchant == 1;
      return false;
    } catch (_) {
      return false;
    }
  }

  /// True when we currently have an auth token stored.
  /// Used to avoid triggering forced sign-out loops for guest users.
  static bool get hasAuthToken {
    try {
      final storage = GetStorage();
      final raw = storage.read('user_data');
      final Map<String, dynamic> user = (raw is Map)
          ? Map<String, dynamic>.from(raw as Map)
          : <String, dynamic>{};

      final token = (user['token'] ?? '').toString();
      return token.trim().isNotEmpty;
    } catch (_) {
      return false;
    }
    }


/// Whether the app is currently running in "guest mode".
/// Stored in GetStorage under key `is_guest`.
static bool get isGuestMode {
  try {
    return GetStorage().read('is_guest') == true;
  } catch (_) {
    return false;
  }
}
  

  /// Returns true if this API path should only be called when the user is authenticated.
  ///
  /// In guest mode we **skip** calling these endpoints to avoid noisy 401 responses
  /// and unexpected "session انتهت" sign-out loops.
  static bool _isProtectedPath(String path) {
    final p = path.trim();

    // Merchant area
    if (p.startsWith('/merchants')) return true;

    // Chat / blocks
    if (p.startsWith('/conversations')) return true;
    if (p.startsWith('/blocks')) return true;

    // Favorites, notifications, profile, etc. (extend as needed)
    if (p.startsWith('/favorites')) return true;
    if (p.startsWith('/notifications')) return true;
    if (p.startsWith('/profile')) return true;

    return false;
  }

  /// Builds base headers.
  ///
  /// Important: Do NOT rely only on in-memory controllers for the token.
  /// During navigation, GetX may recreate controllers and the first API call can happen
  /// before MyAppController finishes loading user data.
  /// So we also read the token from SharedPreferences as a fallback.
  static Future<Map<String, dynamic>> _getBaseHeaders() async {
    try {
      final bool hasMyApp = Get.isRegistered<MyAppController>();
      final MyAppController? myAppController = hasMyApp ? Get.find<MyAppController>() : null;

      final String lang = Get.isRegistered<LanguageController>()
          ? Get.find<LanguageController>().appLocale.value
          : 'ar';

      // Authorization (controller first, SharedPreferences fallback)
      String token = '';
      if (myAppController != null &&
          myAppController.userData.isNotEmpty &&
          myAppController.userData['token'] != null) {
        token = myAppController.userData['token'].toString();
      }

      if (token.isEmpty) {
        try {
          final prefs = await SharedPreferences.getInstance();
          final raw = prefs.getString('user_data');
          if (raw != null && raw.trim().isNotEmpty) {
            final decoded = jsonDecode(raw);
            if (decoded is Map && decoded['token'] != null) {
              token = decoded['token'].toString();
            }
          }
        } catch (_) {}
      }

      // Fallback: GetStorage (some builds persist user/token there).
      if (token.isEmpty) {
        try {
          final box = GetStorage();
          final dynamic ud = box.read('user_data') ?? box.read('user') ?? box.read('auth_user');
          if (ud is Map && ud['token'] != null) {
            token = ud['token'].toString();
          } else if (ud is String && ud.trim().isNotEmpty) {
            final decoded = jsonDecode(ud);
            if (decoded is Map && decoded['token'] != null) {
              token = decoded['token'].toString();
            }
          }

          // Some apps store token directly.
          final direct = box.read('token');
          if (token.isEmpty && direct != null) {
            token = direct.toString();
          }
        } catch (_) {}
      }

      final String authorization = token.isNotEmpty ? 'Bearer $token' : '';
      if (authorization.isNotEmpty) {
        print('🔑 [API] Token ready');
      } else {
        print('⚠️ [API] No token / not logged in');
      }

      // Determine if merchant
      bool isMerchant = false;
      try {
        final ud = (myAppController?.userData is Map)
            ? Map<String, dynamic>.from(myAppController!.userData)
            : <String, dynamic>{};
        final user = ud['user'];
        if (user is Map) {
          final t = (user['user_type'] ?? '').toString().toLowerCase();
          isMerchant = t == 'merchant';
        } else {
          final t2 = (ud['user_type'] ?? ud['role'] ?? ud['type'] ?? '').toString().toLowerCase();
          isMerchant = t2 == 'merchant';
        }
      } catch (_) {}

      // storeId (merchant only) from controller then GetStorage
      String? storeId;
      if (isMerchant) {
        try {
          final ud = (myAppController?.userData is Map)
              ? Map<String, dynamic>.from(myAppController!.userData)
              : <String, dynamic>{};

          final v = ud['active_store_id'] ??
              ud['store_id'] ??
              ud['storeId'] ??
              (ud['store'] is Map ? ud['store']['id'] : null);

          if (v != null) storeId = v.toString();

          if ((storeId == null || storeId!.isEmpty) &&
              Get.isRegistered<GetStorage>()) {
            final s = Get.find<GetStorage>();
            final userData = s.read('user_data');
            if (userData is Map) {
              final vv = userData['active_store_id'] ??
                  userData['store_id'] ??
                  userData['storeId'] ??
                  (userData['store'] is Map ? userData['store']['id'] : null);

              if (vv != null) storeId = vv.toString();
            }
          }
        } catch (_) {}

        if (storeId != null && storeId!.isNotEmpty) {
          print('🏪 [API] storeId in headers = $storeId');
        } else {
          print('⚠️ [API] storeId is NULL (merchant request may fail)');
        }
      }

      return {
        if (authorization.isNotEmpty) 'Authorization': authorization,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Device-Type': 'MOBILE',
        'Accept-Language': lang,
        if (isMerchant && storeId != null && storeId!.isNotEmpty) 'storeId': storeId!,
      };
    } catch (e) {
      print('❌ [API] Headers error: $e');
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Device-Type': 'MOBILE',
        'Accept-Language': 'ar',
      };
    }
  }

  static String? getStoreIdOrNull() {
    try {
      if (Get.isRegistered<MyAppController>()) {
        final c = Get.find<MyAppController>();
        final ud = (c.userData is Map) ? Map<String, dynamic>.from(c.userData) : <String, dynamic>{};
        final v = (ud['store_id'] ?? ud['storeId'] ?? ud['store']?['id']);
        if (v != null) return v.toString();
      }

      // Fallback to GetStorage (sync) if controller is not ready.
      try {
        final box = GetStorage();
        final v = box.read('storeId') ?? box.read('store_id') ?? box.read('selected_store_id');
        if (v != null) return v.toString();
      } catch (_) {}

      return null;
    } catch (_) {
      return null;
    }
  }

  static String _getBaseUrl() {
    switch (currentMode) {
      case AppMode.dev:
        return 'https://aatene.dev/api';
      case AppMode.staging:
        return 'https://staging-api.aatene.com/api/v1';
      case AppMode.production:
        return 'https://api.aatene.com/api/v1';
    }
  }

  static Future<dynamic> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool withLoading = false,
    bool shouldShowMessage = true,
  }) async {
    return await _makeRequest(
      method: getMethod,
      path: path,
      queryParameters: queryParameters,
      headers: headers,
      withLoading: withLoading,
      shouldShowMessage: shouldShowMessage,
    );
  }

  static Future<dynamic> post({
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool withLoading = false,
    bool shouldShowMessage = true,
  }) async {
    return await _makeRequest(
      method: postMethod,
      path: path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      withLoading: withLoading,
      shouldShowMessage: shouldShowMessage,
    );
  }

  static Future<dynamic> put({
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool withLoading = false,
    bool shouldShowMessage = true,
  }) async {
    return await _makeRequest(
      method: putMethod,
      path: path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      withLoading: withLoading,
      shouldShowMessage: shouldShowMessage,
    );
  }

  static String parseApiError(dynamic error, StackTrace stackTrace) {
    try {
      if (error is DioException) {
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            return 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';

          case DioExceptionType.badResponse:
            if (error.response != null) {
              final statusCode = error.response!.statusCode;
              final data = error.response!.data;

              if (statusCode == 422) {
                return _parse422Error(data);
              } else if (statusCode == 401) {
                return 'انتهت جلسة التسجيل، يرجى تسجيل الدخول مرة أخرى';
              } else if (statusCode == 403) {
                return 'ليس لديك صلاحية للقيام بهذا الإجراء';
              } else if (statusCode == 404) {
                return 'الرابط غير موجود';
              } else if (statusCode! >= 500) {
                return 'خطأ في الخادم، يرجى المحاولة لاحقًا';
              }
            }
            return 'حدث خطأ في الاستجابة: ${error.response?.statusCode}';

          case DioExceptionType.cancel:
            return 'تم إلغاء الطلب';

          case DioExceptionType.unknown:
            return 'خطأ في الاتصال بالإنترنت';

          default:
            return 'حدث خطأ غير متوقع';
        }
      }

      return error.toString();
    } catch (e) {
      return 'حدث خطأ غير معروف';
    }
  }

  static String _parse422Error(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        if (data['errors'] != null && data['errors'] is Map) {
          final errors = Map<String, dynamic>.from(data['errors']);
          if (errors.isNotEmpty) {
            final firstError = errors.entries.first;
            final errorMessages = List<String>.from(firstError.value);
            return errorMessages.isNotEmpty
                ? errorMessages.first
                : 'بيانات غير صحيحة';
          }
        }

        if (data['message'] != null) {
          return data['message'].toString();
        }
      }

      return 'بيانات غير صحيحة يرجى التحقق من المدخلات';
    } catch (e) {
      return 'بيانات غير صحيحة';
    }
  }

  static String _safeJsonEncode(dynamic value) {
    try {
      return const JsonEncoder.withIndent('  ').convert(value);
    } catch (_) {
      try {
        return jsonEncode(value);
      } catch (e) {
        return value.toString();
      }
    }
  }

  static Future<dynamic> delete({
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool withLoading = false,
    bool shouldShowMessage = true,
  }) async {
    return await _makeRequest(
      method: deleteMethod,
      path: path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      withLoading: withLoading,
      shouldShowMessage: shouldShowMessage,
    );
  }

  static Future<dynamic> patch({
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool withLoading = false,
    bool shouldShowMessage = true,
  }) async {
    return await _makeRequest(
      method: patchMethod,
      path: path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      withLoading: withLoading,
      shouldShowMessage: shouldShowMessage,
    );
  }

  static Future<dynamic> _makeRequest({
    required String method,
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required bool withLoading,
    required bool shouldShowMessage,
  }) async {
    final Stopwatch stopwatch = Stopwatch()..start();
    final MyAppController myAppController = Get.find<MyAppController>();

    if (!myAppController.isInternetConnect.value) {
      _showNoInternetError(shouldShowMessage);
      return null;
    }

    // ✅ Guest mode guard: do NOT hit protected endpoints without a token
    if (!hasAuthToken && _isProtectedPath(path)) {
      print('⚠️ [API] Guest mode: skipping protected request $method $path');
      return null;
    }

    try {
      if (withLoading) {
        _startLoading();
      }

      final baseHeaders = await _getBaseHeaders();
      final requestHeaders = {...baseHeaders, ...?headers};

      if (body is FormData) {
        requestHeaders.removeWhere((k, _) => k.toLowerCase() == 'content-type');
      }

      if (method.toUpperCase() == 'POST' && path.contains('/auth/login')) {
        requestHeaders.removeWhere(
          (key, value) => key.toLowerCase() == 'authorization',
        );
        print('🔄 [API] إزالة رأس التوكن من طلب تسجيل الدخول');
      }

      print('''
🎯 [API REQUEST] $method ${_getBaseUrl()}$path
📦 Headers: $requestHeaders
📤 Body: ${body == null ? 'null' : (body is FormData ? '[FormData]' : _safeJsonEncode(body))}
    ''');

      final Dio dio = Dio(
        BaseOptions(
          baseUrl: _getBaseUrl(),
          headers: requestHeaders,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      Response response;
      switch (method.toUpperCase()) {
        case getMethod:
          response = await dio.get(path, queryParameters: queryParameters);
          break;
        case postMethod:
          response = await dio.post(
            path,
            data: body,
            queryParameters: queryParameters,
          );
          break;
        case putMethod:
          response = await dio.put(
            path,
            data: body,
            queryParameters: queryParameters,
          );
          break;
        case deleteMethod:
          response = await dio.delete(
            path,
            data: body,
            queryParameters: queryParameters,
          );
          break;
        case patchMethod:
          response = await dio.patch(
            path,
            data: body,
            queryParameters: queryParameters,
          );
          break;
        default:
          throw Exception('HTTP method not supported: $method');
      }

      _logRequestSuccess(method, path, response.data, stopwatch);

      if (withLoading) {
        _dismissLoading();
      }

      return response.data;
    } catch (error) {
      _dismissLoading();
      return _handleError(error, method, path, stopwatch, shouldShowMessage);
    }
  }

  static Future<dynamic> login({
    required String email,
    required String password,
    bool withLoading = true,
  }) async {
   final  GetStorage storage= GetStorage();
    final bool isEmail = email.contains('@');

    Map<String, dynamic> body = {'password': password};
    body['login'] = email;
    final dynamic storedToken = storage.read('device_token');
    final String deviceToken = (storedToken == null || storedToken.toString().trim().isEmpty)
        ? 'temp_${DateTime.now().millisecondsSinceEpoch}'
        : storedToken.toString();

    body['device_name'] = storage.read('device_name');
    body['device_token'] = deviceToken;

    print('''
🔑 محاولة تسجيل الدخول للمستخدم: $email
📱 نوع المدخل: ${isEmail ? 'Email' : 'Username/Phone'}
⚠️ [API] طلب تسجيل دخول جديد - سيتم إزالة التوكن القديم
''');

    return await post(
      path: '/auth/login',
      body: body,
      withLoading: withLoading,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    bool withLoading = true,
  }) async {
       final  GetStorage storage= GetStorage();

    return await post(
      path: '/auth/register',
      body: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
            'device_name': storage.read('device_name'),
            'device_token': (storage.read('device_token') == null || storage.read('device_token').toString().trim().isEmpty)
                ? 'temp_${DateTime.now().millisecondsSinceEpoch}'
                : storage.read('device_token').toString(),
      },
      withLoading: withLoading,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> logout() async {
    return await post(
      path: '/auth/logout',
      withLoading: false,
      shouldShowMessage: false,
    );
  }

  static Future<dynamic> forgotPassword({
    required String email,
    bool withLoading = true,
  }) async {
    return await post(
      path: '/auth/forgot-password',
      body: {'email': email},
      withLoading: withLoading,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
    bool withLoading = true,
  }) async {
    return await post(
      path: '/auth/reset-password',
      body: {
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      withLoading: withLoading,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> verifyEmail({
    required String code,
    bool withLoading = true,
  }) async {
    return await post(
      path: '/auth/verify-email',
      body: {'code': code},
      withLoading: withLoading,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> resendVerificationCode({
    bool withLoading = true,
  }) async {
    return await post(
      path: '/auth/resend-verification',
      withLoading: withLoading,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> checkEmailExists(String email) async {
    return await post(
      path: '/auth/check-email',
      body: {'email': email},
      withLoading: false,
      shouldShowMessage: false,
    );
  }

  static Future<dynamic> checkPhoneExists(String phone) async {
    return await post(
      path: '/auth/check-phone',
      body: {'phone': phone},
      withLoading: false,
      shouldShowMessage: false,
    );
  }

  static Future<dynamic> getUserProfile() async {
    return await get(
      path: '/user/profile',
      withLoading: false,
      shouldShowMessage: false,
    );
  }
static Future<dynamic> getChatConversations({
  int? lastMessageId,
  int? limit = 50,
}) async {
  Map<String, dynamic> queryParams = {};
  if (lastMessageId != null) {
    queryParams['last_message_id'] = lastMessageId;
  }
  if (limit != null) {
    queryParams['limit'] = limit;
  }
  
  return await get(
    path: '/conversations',
    queryParameters: queryParams,
    withLoading: false,
    shouldShowMessage: false,
  );
}

static Future<dynamic> getConversationMessages(
  int conversationId, {
  int? lastMessageId,
  int? page,
  int? perPage,
}) async {
  Map<String, dynamic> queryParams = {};
  if (lastMessageId != null) {
    queryParams['last_message_id'] = lastMessageId;
  }
  if (page != null) {
    queryParams['page'] = page;
  }
  if (perPage != null) {
    queryParams['per_page'] = perPage;
  }
  
  return await get(
    path: '/conversations/$conversationId/messages',
    queryParameters: queryParams,
    withLoading: false,
    shouldShowMessage: false,
  );
}
static Future<dynamic> markMessageAsSeen(int messageId) async {
  return await post(
    path: '/messages/$messageId/seen',
    withLoading: false,
    shouldShowMessage: false,
  );
}

static Future<dynamic> getUnreadCounts() async {
  return await get(
    path: '/conversations/unread-counts',
    withLoading: false,
    shouldShowMessage: false,
  );
}

static Future<dynamic> getConversationDetails(int conversationId) async {
  return await get(
    path: '/conversations/$conversationId',
    withLoading: false,
    shouldShowMessage: false,
  );
}
  static Future<dynamic> updateUserProfile(Map<String, dynamic> data) async {
    return await put(
      path: '/user/profile',
      body: data,
      withLoading: true,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    return await post(
      path: '/user/change-password',
      body: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': newPasswordConfirmation,
      },
      withLoading: true,
      shouldShowMessage: true,
    );
  }

  static void _startLoading() {
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('جاري التحميل...'),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void _dismissLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static void _showNoInternetError(bool shouldShowMessage) {
    if (shouldShowMessage) {
      Get.snackbar(
        'لا يوجد اتصال بالإنترنت',
        'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  static dynamic _handleError(
    dynamic error,
    String method,
    String path,
    Stopwatch stopwatch,
    bool shouldShowMessage,
  ) {
    stopwatch.stop();

    if (error is DioException) {
      final errorData =
          error.response?.data ??
          {
            'errors': [
              {'message': 'حدث خطأ غير متوقع'},
            ],
          };

      _logRequestError(
        method,
        path,
        errorData,
        stopwatch,
        true,
        error.response?.statusCode,
      );

      if (shouldShowMessage) {
        final errorMessage = parseApiError(error, StackTrace.current);
        _showErrorMessage(errorMessage);
      }

      _handleSpecificErrors(error);

      return errorData;
    } else {
      _logRequestError(method, path, error.toString(), stopwatch, false, null);

      if (shouldShowMessage) {
        _showGenericError();
      }

      return {'message': error.toString()};
    }
  }

  static void _logRequestSuccess(
    String method,
    String path,
    dynamic response,
    Stopwatch stopwatch,
  ) {
    stopwatch.stop();
    print('''
🚀 [API SUCCESS] $method $path
⏱️  Time: ${stopwatch.elapsedMilliseconds}ms
📦 Response: ${_formatJson(response)}
    ''');
  }

  static void _logRequestError(
    String method,
    String path,
    dynamic error,
    Stopwatch stopwatch,
    bool isDioError,
    int? statusCode,
  ) {
    print('''
❌ [API ERROR] $method $path
⏱️  Time: ${stopwatch.elapsedMilliseconds}ms
${isDioError ? '📊 Status Code: $statusCode' : ''}
📦 Error: ${isDioError ? _formatJson(error) : error}
    ''');
  }

  static void _showErrorMessage(String errorMessage) {
    Get.snackbar(
      'خطأ',
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  static void _showGenericError() {
    Get.snackbar(
      'خطأ',
      'حدث خطأ أثناء الاتصال بالخادم',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  static void _handleSpecificErrors(DioException error) {
    final MyAppController myAppController = Get.find<MyAppController>();

    switch (error.response?.statusCode) {
      case 401:
        // Guest / not-authenticated requests can return 401. Don't force sign-out loops.
        final bool isGuest = (() {
          try {
            return GetStorage().read('is_guest') == true;
          } catch (_) {
            return false;
          }
        })();

        if (isGuest || !ApiHelper.hasAuthToken) {
          // Just ignore in guest mode.
          return;
        }

        myAppController.onSignOut();
        Get.offAllNamed('/login');
        break;
      case 403:
        Get.snackbar(
          'ممنوع الوصول',
          'ليس لديك صلاحية للوصول إلى هذا المورد',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        break;
      case 404:
        // Get.snackbar(
        //   'غير موجود',
        //   'المورد المطلوب غير موجود',
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.orange,
        //   colorText: Colors.white,
        // );
        break;
      case 422:
        break;
      case 500:
        Get.snackbar(
          'خطأ في الخادم',
          'حدث خطأ في الخادم، يرجى المحاولة لاحقاً',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        break;
    }
  }

  static String _formatJson(dynamic json) {
    try {
      if (json is String) {
        return json;
      }
      return const JsonEncoder.withIndent('  ').convert(json);
    } catch (e) {
      return json.toString();
    }
  }

  static Future<bool> checkInternetConnection() async {
    try {
      final response = await Dio().get(
        'https://www.google.com',
        options: Options(receiveTimeout: Duration(seconds: 5)),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<dynamic> uploadMedia({
    required XFile file,
    required String type,
    bool withLoading = false,
    Function(int, int)? onSendProgress,
  }) async {
    try {
      if (withLoading) {
        _startLoading();
      }

      final String fileName = (file.name.isNotEmpty) ? file.name : file.path.split('/').last;
      final FormData formData = FormData.fromMap({
        'type': type,
        'file': MultipartFile.fromBytes(await file.readAsBytes(), filename: fileName),
      });

      final requestHeaders = await _getBaseHeaders();
      requestHeaders.remove('Content-Type');

      print('''
🔼 [UPLOAD] Starting upload...
📁 File: $fileName
📊 Type: $type
📦 Size: ${await file.length()} bytes
    ''');

      final Dio dio = Dio(
        BaseOptions(
          baseUrl: _getBaseUrl(),
          headers: requestHeaders,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      final Response response = await dio.post(
        '/media-center/add-new',
        data: formData,
        onSendProgress: onSendProgress,
      );

      if (withLoading) {
        _dismissLoading();
      }

      _logRequestSuccess(
        'POST',
        '/media-center/add-new',
        response.data,
        Stopwatch()..start(),
      );

      return response.data;
    } catch (error) {
      _dismissLoading();
      return _handleError(
        error,
        'POST',
        '/media-center/add-new',
        Stopwatch()..start(),
        true,
      );
    }
  }

  static Future<dynamic> getMediaList({
    required String type,
    bool withLoading = false,
  }) async {
    return await _makeRequest(
      method: getMethod,
      path: '/media-center/list',
      queryParameters: {'type': type},
      withLoading: withLoading,
      shouldShowMessage: false,
    );
  }

  static Future<dynamic> deleteMedia({
    required String fileName,
    bool withLoading = true,
  }) async {
    return await _makeRequest(
      method: deleteMethod,
      path: '/media-center/delete',
      queryParameters: {'file_name': fileName},
      withLoading: withLoading,
      shouldShowMessage: true,
    );
  }

  static String getBaseUrl() {
    return _getBaseUrl().replaceAll('/api', '');
  }

  static Future<dynamic> getCities({
    Map<String, dynamic>? queryParameters,
  }) async {
    return await get(
      path: '/merchants/cities',
      queryParameters: queryParameters,
      withLoading: false,
      shouldShowMessage: false,
    );
  }

  static Future<dynamic> getCity(int id) async {
    return await get(
      path: '/merchants/cities/$id',
      withLoading: false,
      shouldShowMessage: false,
    );
  }

  static Future<dynamic> createCity(Map<String, dynamic> data) async {
    return await post(
      path: '/merchants/cities',
      body: data,
      withLoading: true,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> updateCity(int id, Map<String, dynamic> data) async {
    return await put(
      path: '/merchants/cities/$id',
      body: data,
      withLoading: true,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> deleteCity(int id) async {
    return await delete(
      path: '/merchants/cities/$id',
      withLoading: true,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> getDistricts({
    Map<String, dynamic>? queryParameters,
  }) async {
    return await get(
      path: '/merchants/districts',
      queryParameters: queryParameters,
      withLoading: false,
      shouldShowMessage: false,
    );
  }

  static Future<dynamic> getDistrict(int id) async {
    return await get(
      path: '/merchants/districts/$id',
      withLoading: false,
      shouldShowMessage: false,
    );
  }

  static Future<dynamic> createDistrict(Map<String, dynamic> data) async {
    return await post(
      path: '/merchants/districts',
      body: data,
      withLoading: true,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> updateDistrict(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await put(
      path: '/merchants/districts/$id',
      body: data,
      withLoading: true,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> deleteDistrict(int id) async {
    return await delete(
      path: '/merchants/districts/$id',
      withLoading: true,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> getCurrencies({
    Map<String, dynamic>? queryParameters,
  }) async {
    return await get(
      path: '/merchants/currencies',
      queryParameters: queryParameters,
      withLoading: false,
      shouldShowMessage: false,
    );
  }

  static Future<dynamic> getStoreDetails(int storeId) async {
    return await get(
      path: '/merchants/stores/$storeId',
      withLoading: false,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> updateStore(
    int storeId,
    Map<String, dynamic> data,
  ) async {
    return await post(
      path: '/merchants/mobile/stores/$storeId',
      body: data,
      withLoading: true,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> deleteStore(int storeId) async {
    return await delete(
      path: '/merchants/stores/$storeId',
      withLoading: true,
      shouldShowMessage: true,
    );
  }

  static Future<dynamic> getProducts({
    int? sectionId,
    Map<String, dynamic>? queryParameters,
  }) async {
    String path = '/merchants/products';
    if (sectionId != null) {
      queryParameters ??= {};
      queryParameters['section_id'] = sectionId;
    }

    return await get(
      path: path,
      queryParameters: queryParameters,
      withLoading: false,
    );
  }
}