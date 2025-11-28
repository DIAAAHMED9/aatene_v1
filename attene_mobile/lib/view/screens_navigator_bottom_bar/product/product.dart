// lib/view/screens_navigator_bottom_bar/product/product.dart
import 'package:attene_mobile/component/appBar/custom_appbar.dart';
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/view/media_library/media_library_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/product_controller.dart';

class ProductScreen extends GetView<ProductController> {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithTabs(
        isRTL: isRTL,
        config: AppBarConfig( // ✅ الآن AppBarConfig معروف
          title: 'المنتجات',
          actionText: ' + اضافة منتج جديد',
          onActionPressed: controller.openManageSections,
          tabs: controller.tabs, // ✅ لن يكون هناك تعارض الآن
          searchController: controller.searchTextController,
          onSearchChanged: (value) => controller.searchQuery.value = value,
          onFilterPressed:()=>Get.to(MediaLibraryScreen()),
          //  controller.openFilter,
          onSortPressed: controller.openSort,
          tabController: controller.tabController,
          onTabChanged: controller.changeTab,
          showSearch: true,
          showTabs: true,
        ),
      ),
      body: _buildBody(controller, isRTL),
    );
  }

  Widget _buildBody(ProductController controller, bool isRTL) {
    return TabBarView(
      controller: controller.tabController,
      children: controller.tabs.map((tab) => _buildTabContent(tab, controller, isRTL)).toList(),
    );
  }

  Widget _buildTabContent(TabData tab, ProductController controller, bool isRTL) {
    // محتوى التبويب
    return Container(
      child: Center(
        child: Text('محتوى ${tab.label}'),
      ),
    );
  }
}