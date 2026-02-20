import 'package:attene_mobile/services/follow_state_controller.dart';
import 'package:attene_mobile/general_index.dart';

class BaseProfileController extends GetxController {
  final isFollowing = false.obs;
  final currentTab = 0.obs;

  late FollowStateController _followController;

  String followedType = 'user';
  String followedId = '';

  @override
  void onInit() {
    super.onInit();
    _followController = Get.isRegistered<FollowStateController>()
        ? Get.find<FollowStateController>()
        : Get.put(FollowStateController(), permanent: true);
  }

  void initFollowTarget({required String type, required String id, bool? initial}) {
    followedType = type;
    followedId = id;
    final persisted = _followController.isFollowing(followedType: type, followedId: id);
    isFollowing.value = persisted || (initial == true);
  }

  Future<void> toggleFollow() async {
    if (followedId.isEmpty) return;
    final newState = !isFollowing.value;
    isFollowing.value = newState;

    final ok = newState
        ? await _followController.follow(followedType: followedType, followedId: followedId)
        : await _followController.unfollow(followedType: followedType, followedId: followedId);

    if (!ok) {
      isFollowing.value = !newState;
      Get.snackbar('خطأ', 'فشل تحديث المتابعة');
    }
  }

  void changeTab(int index) => currentTab.value = index;
}