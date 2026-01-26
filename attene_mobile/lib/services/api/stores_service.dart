import 'package:dio/dio.dart';
import 'package:attene_mobile/services/api/api_guard.dart';
import 'package:attene_mobile/services/api/api_client.dart';

class StoresService {
  StoresService._();

  static Future<Response> getMerchantStores({bool showLoading = true}) {
    return ApiGuard.run(
      () => ApiClient.I.dio.get('/merchants/stores'),
      showLoading: showLoading,
      loadingText: 'جاري تحميل المتاجر...',
    );
  }
}
