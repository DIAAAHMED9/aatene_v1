import '../../../general_index.dart';

class ReportController extends GetxController {
  Map<String, dynamic> ProductDate = {};
  RxBool isLoading = RxBool(true);
  RxBool hasError = RxBool(false);
  String errorMessage = '';

  final MyAppController myAppController = Get.find<MyAppController>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProductDate();
    });
  }

  Future<void> fetchProductDate() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('fetchProductDate called');
      final res = await ApiHelper.get(
        path: "/products/search",
        withLoading: isLoading.value,
      );
      print('response product data: $res');

      if (res != null && res['status'] == true) {
        print('Product data fetched successfully');
        ProductDate = res['products'] ?? {};

        if (Get.isRegistered<MyAppController>()) {
          final myAppController = Get.find<MyAppController>();
          myAppController.updateProductData(ProductDate);
        }
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Failed to load Product data';
        print('Error: $errorMessage');
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in fetchProductData: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }
}