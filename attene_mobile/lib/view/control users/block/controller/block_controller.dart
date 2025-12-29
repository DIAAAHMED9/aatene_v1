import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;
  final RxBool isLoading = true.obs;

  final RxList<String> blockedUsers = <String>[
    'Ahmed Ali',
    'Mohammed Sami',
    'Khaled Omar',
  ].obs;

  final RxList<String> blockedStores = <String>['Store One', 'Store Two'].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
    });
  }

  void changeTab(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void unblockUser(int index) {
    blockedUsers.removeAt(index);
  }

  void unblockStore(int index) {
    blockedStores.removeAt(index);
  }
}