import 'package:get/get.dart';



class PaginationController<T> extends GetxController {
  final RxList<T> items = <T>[].obs;
  final RxInt currentPage = 1.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final int itemsPerPage;

  PaginationController({this.itemsPerPage = 10});

  Future<void> loadInitialData() async {
    isLoading.value = true;
    currentPage.value = 1;
    try {
      final newItems = await fetchData(page: currentPage.value);
      items.assignAll(newItems);
      hasMore.value = newItems.length >= itemsPerPage;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreData() async {
    if (isLoading.value || !hasMore.value) return;
    isLoading.value = true;
    currentPage.value++;
    try {
      final newItems = await fetchData(page: currentPage.value);
      items.addAll(newItems);
      hasMore.value = newItems.length >= itemsPerPage;
    } catch (e) {
      currentPage.value--;
      Get.snackbar('Error', 'Failed to load more data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<T>> fetchData({required int page}) async {
    return [];
  }

  Future<void> refreshData() async {
    await loadInitialData();
  }

  void clearData() {
    items.clear();
    currentPage.value = 1;
    hasMore.value = true;
  }
}