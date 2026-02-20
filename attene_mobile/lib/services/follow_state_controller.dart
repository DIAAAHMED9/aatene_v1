import 'package:attene_mobile/general_index.dart';

class FollowStateController extends GetxController {
  static const _kUserKey = 'followed_user_ids';
  static const _kStoreKey = 'followed_store_ids';

  final _box = GetStorage();

  final followedUserIds = <String>{}.obs;
  final followedStoreIds = <String>{}.obs;

  final isSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
    _refreshFromApi();
  }

  void _loadFromStorage() {
    final users = (_box.read<List<dynamic>>(_kUserKey) ?? []).map((e) => e.toString()).toSet();
    final stores = (_box.read<List<dynamic>>(_kStoreKey) ?? []).map((e) => e.toString()).toSet();
    followedUserIds.assignAll(users);
    followedStoreIds.assignAll(stores);
  }

  void _persist() {
    _box.write(_kUserKey, followedUserIds.toList());
    _box.write(_kStoreKey, followedStoreIds.toList());
  }

  bool isFollowing({required String followedType, required String followedId}) {
    final id = followedId.toString();
    if (followedType == 'store' || followedType == 'stores') {
      return followedStoreIds.contains(id);
    }
    return followedUserIds.contains(id);
  }

  Future<void> _refreshFromApi() async {
    if (isSyncing.value) return;
    isSyncing.value = true;
    try {
      final res = await ApiHelper.get(path: '/followings');
      if (res.statusCode == 200 && res.data != null) {
        final List data = (res.data['data'] ?? []) as List;
        final users = <String>{};
        final stores = <String>{};

        for (final item in data) {
          final m = Map<String, dynamic>.from(item as Map);
          final followed = (m['followed'] is Map) ? Map<String, dynamic>.from(m['followed']) : m;
          final id = (followed['id'] ?? '').toString();
          final type = (followed['type'] ?? followed['followed_type'] ?? 'user').toString();

          if (id.isEmpty) continue;
          if (type == 'store' || type == 'stores') {
            stores.add(id);
          } else {
            users.add(id);
          }
        }

        followedUserIds.assignAll(users);
        followedStoreIds.assignAll(stores);
        _persist();
      }
    } catch (_) {
    } finally {
      isSyncing.value = false;
    }
  }

  Future<bool> follow({required String followedType, required String followedId}) async {
    final id = followedId.toString();
    final wasFollowing = isFollowing(followedType: followedType, followedId: id);
    _setFollowing(followedType: followedType, followedId: id, value: true);

    try {
      final res = await ApiHelper.post(
        path: '/followings',
        body: {'followed_type': followedType, 'followed_id': id},
      );
      final ok = res.statusCode == 200;
      if (!ok) {
        _setFollowing(followedType: followedType, followedId: id, value: wasFollowing);
      } else {
        _persist();
      }
      return ok;
    } catch (_) {
      _setFollowing(followedType: followedType, followedId: id, value: wasFollowing);
      return false;
    }
  }

  Future<bool> unfollow({required String followedType, required String followedId}) async {
    final id = followedId.toString();
    final wasFollowing = isFollowing(followedType: followedType, followedId: id);
    _setFollowing(followedType: followedType, followedId: id, value: false);

    try {
      final res = await ApiHelper.post(
        path: '/followings/unfollow',
        body: {'followed_type': followedType, 'followed_id': id},
      );
      final ok = res.statusCode == 200;
      if (!ok) {
        _setFollowing(followedType: followedType, followedId: id, value: wasFollowing);
      } else {
        _persist();
      }
      return ok;
    } catch (_) {
      _setFollowing(followedType: followedType, followedId: id, value: wasFollowing);
      return false;
    }
  }

  void _setFollowing({required String followedType, required String followedId, required bool value}) {
    final id = followedId.toString();
    if (followedType == 'store' || followedType == 'stores') {
      if (value) {
        followedStoreIds.add(id);
      } else {
        followedStoreIds.remove(id);
      }
    } else {
      if (value) {
        followedUserIds.add(id);
      } else {
        followedUserIds.remove(id);
      }
    }
  }
}