import '../../general_index.dart';

class FlashSaleController extends GetxController {

  final RxInt _selectedIndex = 1.obs;

  int get selectedIndex => _selectedIndex.value;

  final List<String> tabs = ["الجميع", "10%", "20%", "30%", "40%", "50%"];

  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void changeTab(int index) {
    _selectedIndex.value = index;

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    _fetchProductsForTab(tabs[index]);
  }

  void onPageChanged(int index) {
    _selectedIndex.value = index;
  }

  void _fetchProductsForTab(String tab) {
    print("جلب المنتجات للتبويب: $tab");
  }

  String get currentTab => tabs[selectedIndex];
}