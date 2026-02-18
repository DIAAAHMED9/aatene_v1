import 'package:get/get.dart';

import '../../../api/core/api_helper.dart';

class DashboardController extends GetxController {
  final favoritesCount = 0.obs;
  final productsCount = 0.obs;
  final points = 4685.obs;

  final selectedMonth = 'الشهر الحالي'.obs;



  void changeMonth(String value) {
    selectedMonth.value = value;
  }
  final isLoading = false.obs;
  final hasError = false.obs;
  String errorMessage = '';

  /// الرصيد الحالي
  // final points = 0.obs;

  /// الباقات
  final packages = [].obs;

  /// ==============================
  /// Fetch Balance
  /// ==============================
  Future<void> fetchBalance() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('fetchBalance called');

      final res = await ApiHelper.get(path: '/merchants/coins/balance');
      print('response balance: $res');

      if (res != null && res['status'] == true) {
        points.value = int.tryParse(res['balance'].toString()) ?? 0;
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Failed to load balance';
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in fetchBalance: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// ==============================
  /// Fetch Packages
  /// ==============================
  Future<void> fetchPackages() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final res = await ApiHelper.get(path: '/merchants/coins/packages');
      print('response packages: $res');

      if (res != null && res['status'] == true) {
        packages.value = res['packages'] ?? [];
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Failed to load packages';
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in fetchPackages: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// ==============================
  /// Purchase Coins (POST)
  /// ==============================
  Future<void> purchaseCoins(int packageId) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('purchaseCoins called');

      final res = await ApiHelper.post(path: '/merchants/coins/general');
      print('response purchase: $res');

      if (res != null && res['status'] == true) {
        await fetchBalance(); // تحديث الرصيد بعد الشراء
        Get.snackbar("نجاح", "تمت عملية الشراء بنجاح");
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Purchase failed';
        Get.snackbar("خطأ", errorMessage);
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in purchaseCoins: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onInit() {
    fetchBalance();
    fetchPackages();
    super.onInit();
  }
}
