import 'package:get/get.dart';

enum SearchType {
  products,
  stores,
  services,
  users,
}

class SearchTypeController extends GetxController {
  final Rx<SearchType> selectedType = SearchType.products.obs;

  void selectType(SearchType type) {
    selectedType.value = type;
    Get.back(result: type); // إغلاق + إرجاع القيمة
  }
}
