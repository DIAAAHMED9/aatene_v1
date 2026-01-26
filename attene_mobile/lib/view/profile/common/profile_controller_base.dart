import 'package:attene_mobile/general_index.dart';

/// Shared controller base for profile pages (user/vendor).
///
/// Keeping common reactive state here allows widgets like [SilverTabs]
/// and other profile UI components to work with either controller.
class BaseProfileController extends GetxController {
  final isFollowing = false.obs;
  final currentTab = 0.obs;

  void toggleFollow() => isFollowing.toggle();

  void changeTab(int index) => currentTab.value = index;
}
