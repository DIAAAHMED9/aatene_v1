import '../../../general_index.dart';

class SupportController extends GetxController
    with GetTickerProviderStateMixin {
  List<dynamic> termsAndConditions = [];
  List<dynamic> privacyPolicy = [];

  Map<String, dynamic> safetyRules = {};
  Map<String, dynamic> aboutUs = {};
  List<dynamic> faqSections = [];

  TabController? tabController;

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void onReady() {
    super.onReady();
    fetchTermsAndConditions();

    fetchPrivacyPolicy();

    fetchFaqs();

    fetchSafetyRules();
    fetchAboutUs();

    update();
  }

  Future<void> fetchAboutUs() async {
    try {
      isLoading = true;
      hasError = false;
      update();

      final res = await ApiHelper.aboutUs();

      if (res != null && res['status'] == true) {
        aboutUs = res['aboutUs'] ?? {};
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
  Future<void> fetchSafetyRules() async {
    try {
      isLoading = true;
      hasError = false;
      update();

      final res = await ApiHelper.safetyRules();

      if (res != null && res['status'] == true) {
        safetyRules = res['safetyRules'] ?? {};
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

  Future<void> fetchFaqs() async {
    try {
      isLoading = true;
      hasError = false;
      update();

      final response = await ApiHelper.faqs();

      if (response != null && response['status'] == true) {
        faqSections = response['faqs'] ?? [];

        _initTabs();
      } else {
        hasError = true;
        errorMessage = response['message'] ?? 'Error';
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  void _initTabs() {
    tabController?.dispose();

    tabController = TabController(length: faqSections.length, vsync: this);

    update();
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }
}