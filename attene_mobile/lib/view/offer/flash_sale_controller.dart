import '../../general_index.dart';

/// Controller لإدارة حالة صفحة Flash Sale
class FlashSaleController extends GetxController {
  // ==================== متغيرات الحالة ====================

  // Index التبويب المحدد
  final RxInt _selectedIndex = 1.obs;

  int get selectedIndex => _selectedIndex.value;

  // قائمة التبويبات
  final List<String> tabs = ["الجميع", "10%", "20%", "30%", "40%", "50%"];

  // Page Controller للتحكم في PageView
  late final PageController pageController;

  // ==================== دورة حياة الـ Controller ====================

  @override
  void onInit() {
    super.onInit();
    // تهيئة PageController
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void onClose() {
    // تنظيف الموارد عند إغلاق الـ Controller
    pageController.dispose();
    super.onClose();
  }

  // ==================== التوابع العامة ====================

  /// تغيير التبويب المحدد
  void changeTab(int index) {
    _selectedIndex.value = index;

    // تحريك PageView للصفحة المحددة
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // هنا يمكنك إضافة منطق جلب البيانات حسب التبويب
    _fetchProductsForTab(tabs[index]);
  }

  /// تغيير الصفحة عند تحريك PageView
  void onPageChanged(int index) {
    _selectedIndex.value = index;
  }

  /// جلب المنتجات حسب نوع الخصم
  void _fetchProductsForTab(String tab) {
    // TODO: تنفيذ منطق جلب البيانات من API
    print("جلب المنتجات للتبويب: $tab");
    // Example: await ApiService.getFlashSaleProducts(tab);
  }

  /// الحصول على التبويب الحالي
  String get currentTab => tabs[selectedIndex];
}
