import 'package:get/get.dart';

class ProfileController extends GetxController {
  final isFollowing = false.obs;
  final currentTab = 0.obs;

  void toggleFollow() {
    isFollowing.toggle();
  }

  void changeTab(int index) {
    currentTab.value = index;
  }
}
