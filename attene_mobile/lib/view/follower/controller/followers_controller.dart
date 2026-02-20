import '../../../general_index.dart';

class FollowersController extends GetxController {
  final pageController = PageController();
  final searchController = TextEditingController();

  final selectedTab = 0.obs;

  final followingList = <FollowerModel>[].obs;
  final followersList = <FollowerModel>[].obs;

  final filteredFollowing = <FollowerModel>[].obs;
  final filteredFollowers = <FollowerModel>[].obs;

  final isLoadingFollowings = false.obs;
  final isLoadingFollowers = false.obs;

  FollowerModel? _lastRemoved;
  int? _lastRemovedIndex;

  @override
  void onInit() {
    super.onInit();
    loadFollowings();
    loadFollowers();
  }

  Future<void> loadFollowings() async {
    isLoadingFollowings.value = true;

    try {
      final response = await ApiHelper.get(path: '/followings');

      if (response.statusCode == 200 && response.data != null) {
        final List data = response.data['data'] ?? [];

        final list = data.map((item) {
          final userJson = item['followed'] ?? item;
          return FollowerModel.fromJson(userJson);
        }).toList();

        followingList.assignAll(list);
        filteredFollowing.assignAll(list);
      } else {
        Get.snackbar('خطأ', 'فشل تحميل قائمة المتابَعين');
      }
    } catch (e) {
      debugPrint('loadFollowings error: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء تحميل البيانات');
    } finally {
      isLoadingFollowings.value = false;
    }
  }

  Future<void> loadFollowers() async {
    isLoadingFollowers.value = true;

    try {
      final response = await ApiHelper.get(path: '/followers');

      if (response.statusCode == 200 && response.data != null) {
        final List data = response.data['data'] ?? [];

        final list = data.map((item) {
          final userJson = item['follower'] ?? item['followed'] ?? item;
          return FollowerModel.fromJson(userJson);
        }).toList();

        followersList.assignAll(list);
        filteredFollowers.assignAll(list);
      } else {
        Get.snackbar('خطأ', 'فشل تحميل قائمة المتابعين');
      }
    } catch (e) {
      debugPrint('loadFollowers error: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء تحميل البيانات');
    } finally {
      isLoadingFollowers.value = false;
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onSearch(String value) {
    final query = value.toLowerCase();

    filteredFollowing.assignAll(
      query.isEmpty
          ? followingList
          : followingList.where((e) => e.name.toLowerCase().contains(query)),
    );

    filteredFollowers.assignAll(
      query.isEmpty
          ? followersList
          : followersList.where((e) => e.name.toLowerCase().contains(query)),
    );
  }

  Future<void> unfollow(FollowerModel model) async {
    _lastRemovedIndex = followingList.indexOf(model);
    _lastRemoved = model;

    final success = await _performUnfollow(model);

    if (success) {
      followingList.remove(model);
      onSearch(searchController.text);

      Get.snackbar(
        'تم إلغاء المتابعة',
        model.name,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        mainButton: TextButton(
          onPressed: undoUnfollow,
          child: Text('تراجع', style: getBold(color: AppColors.primary500)),
        ),
      );
    } else {
      Get.snackbar('خطأ', 'فشل إلغاء المتابعة');
    }
  }

  Future<bool> _performUnfollow(FollowerModel model) async {
    try {
      final response = await ApiHelper.post(
        path: '/followings/unfollow',
        body: {'followed_type': model.followedType, 'followed_id': model.id},
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> undoUnfollow() async {
    if (_lastRemoved == null || _lastRemovedIndex == null) return;

    final success = await _performFollow(_lastRemoved!);

    if (success) {
      followingList.insert(_lastRemovedIndex!, _lastRemoved!);
      onSearch(searchController.text);
    }
  }

  Future<void> followBack(FollowerModel model) async {
    final success = await _performFollow(model);

    if (success) {
      followersList.remove(model);
      followingList.add(model);
      onSearch(searchController.text);
      changeTab(0);
      Get.snackbar('تمت المتابعة', 'أصبحت تتابع ${model.name}');
    }
  }

  Future<bool> _performFollow(FollowerModel model) async {
    try {
      final response = await ApiHelper.post(
        path: '/followings',
        body: {'followed_type': model.followedType, 'followed_id': model.id},
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    searchController.dispose();
    super.onClose();
  }
}