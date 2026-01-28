import 'package:dio/dio.dart';
import 'package:attene_mobile/services/api/api_client.dart';
import 'package:attene_mobile/services/api/api_guard.dart';

class HomeService {
  HomeService._();

  static Future<Response> getHomePage({bool showLoading = false}) {
    return ApiGuard.run(
      () => ApiClient.I.dio.get('/pages/home'),
      showLoading: showLoading,
      loadingText: 'جاري تحميل الرئيسية...',
    );
  }

  static Future<Response> searchProducts({
    int page = 1,
    Map<String, dynamic>? filters,
    bool showLoading = false,
  }) {
    final qp = <String, dynamic>{'page': page};
    if (filters != null) qp.addAll(filters);
    return ApiGuard.run(
      () => ApiClient.I.dio.get('/products/search', queryParameters: qp),
      showLoading: showLoading,
      loadingText: 'جاري تحميل المنتجات...',
    );
  }

  static Future<Response> searchStores({
    Map<String, dynamic>? filters,
    bool showLoading = false,
  }) {
    return ApiGuard.run(
      () => ApiClient.I.dio.get('/stores/search', queryParameters: filters),
      showLoading: showLoading,
      loadingText: 'جاري تحميل المتاجر...',
    );
  }
}