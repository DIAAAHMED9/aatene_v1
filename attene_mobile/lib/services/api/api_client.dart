import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient I = ApiClient._();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://aatene.dev/api',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void setStoreId(String storeId) {
    dio.options.headers['storeId'] = storeId;
  }

  void setLanguage(String langCode) {
    dio.options.headers['Accept-Language'] = langCode;
  }

  void setDeviceType(String deviceType) {
    dio.options.headers['Device-Type'] = deviceType;
  }
}
