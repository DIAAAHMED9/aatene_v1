// lib/api/api_request.dart
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:attene_mobile/my_app/my_app_controller.dart';
import 'package:attene_mobile/utlis/language/language_controller.dart';

const String postMethod = 'POST';
const String getMethod = 'GET';
const String putMethod = 'PUT';
const String deleteMethod = 'DELETE';
const String patchMethod = 'PATCH';

enum AppMode { dev, staging, production }
const AppMode currentMode = AppMode.dev;

class ApiHelper {
  // ==================== وظائف الرؤوس ====================
  
  static Map<String, dynamic> _getBaseHeaders() {
    try {
      // الرؤوس الأساسية
      Map<String, dynamic> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Device-Type': 'MOBILE',
        'Accept-Language': 'ar',
      };
      
      // إضافة التوكن إذا كان المستخدم مسجل دخول
      if (Get.isRegistered<MyAppController>()) {
        final myAppController = Get.find<MyAppController>();
        
        if (myAppController.isLoggedIn.value && 
            myAppController.token != null &&
            myAppController.token!.isNotEmpty) {
          headers['Authorization'] = 'Bearer ${myAppController.token}';
        }
        
        // إضافة storeId من MyAppController
        headers['storeId'] = myAppController.selectedStoreId.value.toString();
      } else {
        // القيمة الافتراضية إذا لم يكن المتحكم مسجلاً
        // headers['storeId'] = '41';
      }
      
      // إضافة اللغة إذا كان المتحكم مسجلاً
      if (Get.isRegistered<LanguageController>()) {
        final languageController = Get.find<LanguageController>();
        headers['Accept-Language'] = languageController.appLocale.value;
      }
      
      return headers;
    } catch (e) {
      print('❌ [API] خطأ في الحصول على رؤوس الطلب: $e');
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Device-Type': 'MOBILE',
        'Accept-Language': 'ar',
        'storeId': '41',
      };
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
  
  // ==================== وظائف الطلبات الأساسية ====================
  
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
  
  // ==================== وظيفة الطلب الرئيسية ====================
  
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
    
    // التحقق من اتصال الإنترنت
    if (Get.isRegistered<MyAppController>()) {
      final myAppController = Get.find<MyAppController>();
      if (!myAppController.isInternetConnect.value) {
        _showNoInternetError(shouldShowMessage);
        return null;
      }
    }
    
    try {
      if (withLoading) {
        _startLoading();
      }
      
      // دمج الرؤوس
      final requestHeaders = {..._getBaseHeaders(), ...?headers};
      
      // إزالة التوكن من طلبات تسجيل الدخول
      if (method.toUpperCase() == 'POST' && path.contains('/auth/login')) {
        requestHeaders.removeWhere((key, value) => key.toLowerCase() == 'authorization');
      }
      
      print('''
🎯 [API REQUEST] $method ${_getBaseUrl()}$path
📦 Headers: ${requestHeaders.keys.map((k) => '$k: ${k == 'Authorization' ? 'Bearer ***' : requestHeaders[k]}').join(', ')}
📤 Body: ${body != null ? jsonEncode(body) : 'null'}
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
      
      stopwatch.stop();
      print('''
🚀 [API SUCCESS] $method $path
⏱️  Time: ${stopwatch.elapsedMilliseconds}ms
📦 Response: ${_formatJson(response.data)}
    ''');
      
      if (withLoading) {
        _dismissLoading();
      }
      
      return response.data;
    } catch (error) {
      _dismissLoading();
      return _handleError(error, method, path, stopwatch, shouldShowMessage);
    }
  }
  
  // ==================== وظائف المساعدة ====================
  
  static void _startLoading() {
    if (Get.isDialogOpen ?? false) return;
    
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Column(
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
        duration: const Duration(seconds: 3),
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
      final errorData = error.response?.data ?? {'message': 'حدث خطأ غير متوقع'};
      
      print('''
❌ [API ERROR] $method $path
⏱️  Time: ${stopwatch.elapsedMilliseconds}ms
📊 Status Code: ${error.response?.statusCode}
📦 Error: ${_formatJson(errorData)}
    ''');
      
      if (shouldShowMessage) {
        final errorMessage = parseApiError(error, StackTrace.current);
        _showErrorMessage(errorMessage);
      }
      
      _handleSpecificErrors(error);
      
      return errorData;
    } else {
      print('''
❌ [API ERROR] $method $path
⏱️  Time: ${stopwatch.elapsedMilliseconds}ms
📦 Error: $error
    ''');
      
      if (shouldShowMessage) {
        _showGenericError();
      }
      
      return {'message': error.toString()};
    }
  }
  
  static void _showErrorMessage(String errorMessage) {
    Get.snackbar(
      'خطأ',
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
  
  static void _showGenericError() {
    Get.snackbar(
      'خطأ',
      'حدث خطأ أثناء الاتصال بالخادم',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
  
  static void _handleSpecificErrors(DioException error) {
    if (!Get.isRegistered<MyAppController>()) return;
    
    final myAppController = Get.find<MyAppController>();
    
    switch (error.response?.statusCode) {
      case 401:
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
        Get.snackbar(
          'غير موجود',
          'المورد المطلوب غير موجود',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        break;
      case 422:
        // لا نعرض رسالة هنا لأنها ستعرض في الـsnackbar الرئيسي
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
            return errorMessages.isNotEmpty ? errorMessages.first : 'بيانات غير صحيحة';
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
  
  // ==================== وظائف المصادقة ====================
  
  static Future<dynamic> login({
    required String email,
    required String password,
    bool withLoading = true,
  }) async {
    Map<String, dynamic> body = {
      'password': password,
    };
    body['login'] = email;
    
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
    return await post(
      path: '/auth/register',
      body: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
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
  
  // ==================== وظائف الوسائط ====================
  
  static Future<dynamic> uploadMedia({
    required File file,
    required String type,
    bool withLoading = false,
    Function(int, int)? onSendProgress,
  }) async {
    try {
      if (withLoading) {
        _startLoading();
      }
      
      final String fileName = file.path.split('/').last;
      final FormData formData = FormData.fromMap({
        'type': type,
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });
      
      final requestHeaders = _getBaseHeaders();
      requestHeaders.remove('Content-Type');
      
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
      
      return response.data;
    } catch (error) {
      _dismissLoading();
      return _handleError(error, 'POST', '/media-center/add-new', Stopwatch()..start(), true);
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
  
  // ==================== وظائف المتاجر ====================
  
  static Future<dynamic> getStores({Map<String, dynamic>? queryParameters}) async {
    return await get(
      path: '/merchants/stores',
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
  
  static Future<dynamic> updateStore(int storeId, Map<String, dynamic> data) async {
    return await post(
      path: '/merchants/mobile/stores/$storeId',
      body: data,
      withLoading: true,
      shouldShowMessage: true,
    );
  }
  
  static Future<dynamic> deleteStore(int storeId) async {
    return await delete(
      path: '/merchants/mobile/stores/$storeId',
      withLoading: true,
      shouldShowMessage: true,
    );
  }
  
  // ==================== وظائف البيانات العامة ====================
  
  static Future<dynamic> getCities({Map<String, dynamic>? queryParameters}) async {
    return await get(
      path: '/merchants/cities',
      queryParameters: queryParameters,
      withLoading: false,
      shouldShowMessage: false,
    );
  }
  
  static Future<dynamic> getDistricts({Map<String, dynamic>? queryParameters}) async {
    return await get(
      path: '/merchants/districts',
      queryParameters: queryParameters,
      withLoading: false,
      shouldShowMessage: false,
    );
  }
  
  static Future<dynamic> getCurrencies({Map<String, dynamic>? queryParameters}) async {
    return await get(
      path: '/merchants/currencies',
      queryParameters: queryParameters,
      withLoading: false,
      shouldShowMessage: false,
    );
  }
  
  static Future<dynamic> getProducts({
    int? sectionId,
    Map<String, dynamic>? queryParameters,
  }) async {
    String path = '/merchants/products';
    final Map<String, dynamic> params = queryParameters ?? {};
    if (sectionId != null) {
      params['section_id'] = sectionId;
    }
    
    return await get(
      path: path,
      queryParameters: params,
      withLoading: false,
    );
  }
  
  static String getBaseUrl() {
    return _getBaseUrl().replaceAll('/api', '');
  }
}