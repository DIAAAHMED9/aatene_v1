import '../../../general_index.dart';

class FollowersController extends GetxController {
  final pageController = PageController();
  final searchController = TextEditingController();

  final selectedTab = 0.obs;

  final followingList = <FollowerModel>[].obs;
  final followersList = <FollowerModel>[].obs;

  final filteredFollowing = <FollowerModel>[].obs;
  final filteredFollowers = <FollowerModel>[].obs;

  FollowerModel? _lastRemoved;
  int? _lastRemovedIndex;

  @override
  void onInit() {
    super.onInit();

    followingList.addAll([
      FollowerModel(
        id: 1,
        name: 'Ahmed Ali',
        avatar: 'https://i.pravatar.cc/150?img=3',
        followersCount: 1200,
      ),
      FollowerModel(
        id: 6,
        name: 'Ahmed Ali',
        avatar: 'https://i.pravatar.cc/150?img=3',
        followersCount: 1200,
      ),
    ]);

    followersList.addAll([
      FollowerModel(
        id: 2,
        name: 'Mohamed Noor',
        avatar: 'https://i.pravatar.cc/150?img=5',
        followersCount: 850,
      ),
      FollowerModel(
        id: 9,
        name: 'Mohamed Noor',
        avatar: 'https://i.pravatar.cc/150?img=5',
        followersCount: 850,
      ),
    ]);

    filteredFollowing.assignAll(followingList);
    filteredFollowers.assignAll(followersList);
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

  void unfollow(FollowerModel model) {
    Get.defaultDialog(
      title: 'تأكيد',
      middleText: 'هل تريد إلغاء متابعة ${model.name}؟',
      // textConfirm: 'نعم',
      actions: [
        AateneButton(
          onTap: () {
            _lastRemovedIndex = followingList.indexOf(model);
            _lastRemoved = model;
            followingList.remove(model);
            onSearch(searchController.text);
            Get.back();
            Get.snackbar(
              'تم إلغاء المتابعة',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4),
              model.name,
              mainButton: TextButton(
                onPressed: undoUnfollow,
                child: Text(
                  'تراجع',
                  style: getBold(color: AppColors.primary500),
                ),
              ),
            );
          },
          buttonText: "نعم",
          color: AppColors.primary400,
          textColor: AppColors.light1000,
          borderColor: AppColors.primary400,
        ),
        SizedBox(height: 10),
        AateneButton(
          onTap: () => Get.back(result: false),
          buttonText: "إلغاء",
          color: AppColors.light1000,
          textColor: AppColors.primary400,
          borderColor: AppColors.primary400,
        ),
      ],
      //
      // textCancel: 'إلغاء',
      // onConfirm: () {
      //   _lastRemovedIndex = followingList.indexOf(model);
      //   _lastRemoved = model;
      //
      //   followingList.remove(model);
      //   onSearch(searchController.text);
      //
      //   Get.back();
      //
      //   Get.snackbar(
      //     'تم إلغاء المتابعة',
      //     snackPosition: SnackPosition.BOTTOM,
      //     duration: const Duration(seconds: 4),
      //     model.name,
      //     mainButton: TextButton(
      //       onPressed: undoUnfollow,
      //       child: Text('تراجع', style: getBold(color: AppColors.primary500)),
      //     ),
      //   );
      // },
    );
  }

  void undoUnfollow() {
    if (_lastRemoved != null && _lastRemovedIndex != null) {
      followingList.insert(_lastRemovedIndex!, _lastRemoved!);
      onSearch(searchController.text);
    }
  }

  void followBack(FollowerModel model) {
    followersList.remove(model);
    followingList.add(model);

    onSearch(searchController.text);

    Get.snackbar('تمت المتابعة', 'أصبحت تتابع ${model.name}');

    changeTab(0);
  }
}
