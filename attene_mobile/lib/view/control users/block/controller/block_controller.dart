import 'dart:async';
import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;
  final RxBool isLoading = true.obs;

  /// Original data
  final RxList<String> blockedUsers = <String>[
    'Ahmed Ali',
    'Mohammed Sami',
    'Khaled Omar',
  ].obs;

  final RxList<String> blockedStores = <String>['Store One', 'Store Two'].obs;

  final RxList<String> blockedChats = <String>[
    'Chat with Sara',
    'Chat with Omar',
  ].obs;

  /// Filtered data
  final RxList<String> filteredUsers = <String>[].obs;
  final RxList<String> filteredStores = <String>[].obs;
  final RxList<String> filteredChats = <String>[].obs;

  /// Undo handling
  String? _lastRemovedItem;
  int? _lastRemovedIndex;
  int? _lastTab;
  Timer? _undoTimer;

  @override
  void onInit() {
    super.onInit();

    /// initial load simulation
    Future.delayed(const Duration(seconds: 2), () {
      filteredUsers.assignAll(blockedUsers);
      filteredStores.assignAll(blockedStores);
      filteredChats.assignAll(blockedChats);
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

  /// 🔍 Search per tab
  void onSearch(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(blockedUsers);
      filteredStores.assignAll(blockedStores);
      filteredChats.assignAll(blockedChats);
      return;
    }

    filteredUsers.assignAll(
      blockedUsers.where((e) => e.toLowerCase().contains(query.toLowerCase())),
    );
    filteredStores.assignAll(
      blockedStores.where((e) => e.toLowerCase().contains(query.toLowerCase())),
    );
    filteredChats.assignAll(
      blockedChats.where((e) => e.toLowerCase().contains(query.toLowerCase())),
    );
  }

  /// ❌ Unblock
  void unblock({required int tab, required int index}) {
    _undoTimer?.cancel();

    _lastTab = tab;
    _lastRemovedIndex = index;

    switch (tab) {
      case 0:
        _lastRemovedItem = filteredUsers[index];
        blockedUsers.remove(_lastRemovedItem);
        filteredUsers.removeAt(index);
        break;
      case 1:
        _lastRemovedItem = filteredStores[index];
        blockedStores.remove(_lastRemovedItem);
        filteredStores.removeAt(index);
        break;
      case 2:
        _lastRemovedItem = filteredChats[index];
        blockedChats.remove(_lastRemovedItem);
        filteredChats.removeAt(index);
        break;
    }

    _showUndoSnackbar();

    /// timeout
    _undoTimer = Timer(const Duration(seconds: 4), () {
      _clearUndo();
    });
  }

  void undo() {
    if (_lastRemovedItem == null) return;

    switch (_lastTab) {
      case 0:
        blockedUsers.insert(_lastRemovedIndex!, _lastRemovedItem!);
        filteredUsers.assignAll(blockedUsers);
        break;
      case 1:
        blockedStores.insert(_lastRemovedIndex!, _lastRemovedItem!);
        filteredStores.assignAll(blockedStores);
        break;
      case 2:
        blockedChats.insert(_lastRemovedIndex!, _lastRemovedItem!);
        filteredChats.assignAll(blockedChats);
        break;
    }

    _clearUndo();
  }

  void _clearUndo() {
    _lastRemovedItem = null;
    _lastRemovedIndex = null;
    _lastTab = null;
  }

  void _showUndoSnackbar() {
    Get.snackbar(
      'تم إلغاء الحظر',
      'يمكنك التراجع',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      mainButton: TextButton(
        onPressed: undo,
        child: Text('تراجع', style: getBold(color: AppColors.primary300)),
      ),
    );
  }
}
