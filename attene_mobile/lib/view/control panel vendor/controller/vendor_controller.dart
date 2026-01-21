import 'package:get/get.dart';

class DashboardController extends GetxController {
  final favoritesCount = 0.obs;
  final productsCount = 0.obs;
  final points = 4685.obs;

  final selectedMonth = 'الشهر الحالي'.obs;

  void changeMonth(String value) {
    selectedMonth.value = value;
  }
}
