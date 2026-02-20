import 'package:attene_mobile/api/api_request.dart';

class SupportController extends GetxController {
  List<dynamic> termsAndConditions = [];
  List<dynamic> privacyPolicy = [];
  List<dynamic> faqs = [];

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void onReady() {
    super.onReady();
    fetchTermsAndConditions();

    fetchPrivacyPolicy();

    fetchfaqs();

    update();
  }

  Future<void> fetchTermsAndConditions() async {
    try {
      isLoading = true;
      hasError = false;
      update();

      final res = await ApiHelper.termsAndConditions();

      if (res != null && res['status'] == true) {
        termsAndConditions = res['termsAndConditions'] ?? [];
      } else {
        hasError = true;
        errorMessage = res?['message'] ?? 'حدث خطأ أثناء جلب البيانات';
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  String getTitleTerms(Map<String, dynamic> item) {
    final locale = Get.locale?.languageCode ?? 'ar';
    return item['title']?[locale] ?? item['title']?['ar'] ?? '';
  }

  String getContentTerms(Map<String, dynamic> item) {
    final locale = Get.locale?.languageCode ?? 'ar';
    return item['content']?[locale] ?? item['content']?['ar'] ?? '';
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading = true;
      hasError = false;
      update();

      final res = await ApiHelper.privacyPolicy();
      if (res != null && res['status'] == true) {
        privacyPolicy = res['privacyPolicy'] ?? [];
      } else {
        hasError = true;
        errorMessage = res?['message'] ?? 'حدث خطأ أثناء جلب البيانات';
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  String getTitlePolicy(Map<String, dynamic> item) {
    final locale = Get.locale?.languageCode ?? 'ar';
    return item['title']?[locale] ?? item['title']?['ar'] ?? '';
  }

  String getContentPolicy(Map<String, dynamic> item) {
    final locale = Get.locale?.languageCode ?? 'ar';
    return item['content']?[locale] ?? item['content']?['ar'] ?? '';
  }

  Future<void> fetchfaqs() async {
    try {
      isLoading = true;
      hasError = false;
      update();

      final res = await ApiHelper.faqs();
      if (res != null && res['status'] == true) {
        faqs = res['faqs'] ?? [];
      } else {
        hasError = true;
        errorMessage = res?['message'] ?? 'حدث خطأ أثناء جلب البيانات';
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }
}