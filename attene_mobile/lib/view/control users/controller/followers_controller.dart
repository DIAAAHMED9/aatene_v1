

import '../../../general_index.dart';

class FollowersController extends GetxController {
  var selectedTab = 0.obs;
  var searchQuery = ''.obs;

  final followers = <FollowerModel>[
    FollowerModel(
      name: 'SideLimited',
      avatar: 'https://i.pravatar.cc/150?img=3',
      followersCount: 249000,
    ),
    FollowerModel(
      name: 'SideLimited Dev',
      avatar: 'https://i.pravatar.cc/150?img=5',
      followersCount: 249000,
    ),
  ].obs;

  /// 🧠 متغيرات التراجع
  FollowerModel? _lastRemovedFollower;
  int? _lastRemovedIndex;

  List<FollowerModel> get filteredFollowers {
    if (searchQuery.value.isEmpty) return followers;
    return followers
        .where(
          (f) => f.name.toLowerCase().contains(
        searchQuery.value.toLowerCase(),
      ),
    )
        .toList();
  }

  void onSearch(String value) {
    searchQuery.value = value;
  }

  /// 🔴 إلغاء المتابعة + حذف العنصر
  void unfollow(FollowerModel model) {
    _lastRemovedIndex = followers.indexOf(model);
    _lastRemovedFollower = model;

    followers.remove(model);

    Get.snackbar(
      'تم إلغاء المتابعة',
      'تم حذف ${model.name} من القائمة',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      mainButton: TextButton(
        onPressed: undoUnfollow,
        child: const Text(
          'تراجع',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// 🔄 التراجع عن الحذف
  void undoUnfollow() {
    if (_lastRemovedFollower == null || _lastRemovedIndex == null) return;

    followers.insert(_lastRemovedIndex!, _lastRemovedFollower!);

    _lastRemovedFollower = null;
    _lastRemovedIndex = null;

    Get.closeCurrentSnackbar();
  }
}
