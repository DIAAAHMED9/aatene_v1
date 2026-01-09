import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // للتحكم في PageView
  late PageController pageController;

  // مؤشر التبويب الحالي
  var selectedTabIndex = 0.obs;

  // مؤشر البانر (السلايدر)
  var currentBannerIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // تهيئة PageController
    pageController = PageController(initialPage: 0);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // عند الضغط على التبويب
  void changeTab(int index) {
    selectedTabIndex.value = index;
    // تحريك الـ PageView للصفحة المختارة
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // عند السحب (Swipe) لتغيير التبويب العلوي تلقائياً
  void onPageChanged(int index) {
    selectedTabIndex.value = index;
  }

  // تحديث مؤشر البانر
  void updateBannerIndex(int index) {
    currentBannerIndex.value = index;
  }
}