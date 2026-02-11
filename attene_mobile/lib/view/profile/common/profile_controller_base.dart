import 'package:attene_mobile/general_index.dart';

class BaseProfileController extends GetxController {
  final isFollowing = false.obs;
  final currentTab = 0.obs;

  void toggleFollow() => isFollowing.toggle();

  void changeTab(int index) => currentTab.value = index;
}