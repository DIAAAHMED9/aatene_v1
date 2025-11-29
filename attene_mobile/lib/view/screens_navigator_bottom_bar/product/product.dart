// lib/view/screens_navigator_bottom_bar/product/product.dart
import 'package:attene_mobile/component/appBar/custom_appbar.dart';
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/my_app/may_app_controller.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/view/media_library/media_library_screen.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductScreen extends GetView<ProductController> {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());
    final isRTL = LanguageUtils.isRTL;
    final MyAppController myAppController = Get.find<MyAppController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithTabs(
        isRTL: isRTL,
        config: AppBarConfig(
          title: 'المنتجات',
          actionText: ' + اضافة منتج جديد',
          onActionPressed: controller.navigateToAddProduct,
          tabs: controller.tabs,
          searchController: controller.searchTextController,
          onSearchChanged: (value) => controller.searchQuery.value = value,
          onFilterPressed: () => Get.to(() => MediaLibraryScreen()),
          onSortPressed: controller.openSort,
          tabController: controller.tabController,
          onTabChanged: controller.changeTab,
          showSearch: true,
          showTabs: true,
        ),
      ),
      body: Obx(() => _buildBody(controller, isRTL, myAppController)),
    );
  }

  Widget _buildBody(ProductController controller, bool isRTL, MyAppController myAppController) {
    // إذا لم يكن المستخدم مسجل دخول، عرض واجهة تسجيل الدخول
    if (!myAppController.isLoggedIn.value) {
      return _buildLoginRequiredView();
    }

    return Column(
      children: [
        // أزرار الإدارة
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: controller.openAddNewSection,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('إضافة قسم جديد'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.openManageSections,
                  icon: const Icon(Icons.manage_search_rounded),
                  label: const Text('إدارة الأقسام'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // محتوى التبويبات
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: controller.tabs.map((tab) => _buildTabContent(tab, controller)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginRequiredView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login_rounded,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'يجب تسجيل الدخول',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'يرجى تسجيل الدخول للوصول إلى إدارة المنتجات والأقسام',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed('/login');
              },
              icon: const Icon(Icons.login_rounded),
              label: const Text('تسجيل الدخول'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Get.toNamed('/register');
              },
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('إنشاء حساب جديد'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(TabData tab, ProductController controller) {
    final MyAppController myAppController = Get.find<MyAppController>();

    if (!myAppController.isLoggedIn.value) {
      return _buildEmptyTabContent(tab);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'محتوى ${tab.label}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'سيتم عرض المنتجات هنا',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTabContent(TabData tab) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              '${tab.label}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'تسجيل الدخول مطلوب لعرض المحتوى',
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}