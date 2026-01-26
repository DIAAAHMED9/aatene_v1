import 'dart:async';

import '../../../general_index.dart';

class BlockEntry {
  final String type; // "user" | "store"
  final String id; // participant_id
  final String? name;
  final String? slug;
  final String? avatar;

  BlockEntry({
    required this.type,
    required this.id,
    this.name,
    this.slug,
    this.avatar,
  });

  String get key => '${type.toLowerCase()}:$id';

  String get displayName {
    final n = (name ?? '').trim();
    if (n.isNotEmpty) return n;
    final s = (slug ?? '').trim();
    if (s.isNotEmpty) return s;
    return '${type.toUpperCase()} #$id';
  }

  factory BlockEntry.fromParticipantJson(Map<String, dynamic> participant) {
    final pd = participant['participant_data'];
    final m = (pd is Map) ? Map<String, dynamic>.from(pd) : <String, dynamic>{};

    return BlockEntry(
      type: (m['type'] ?? '').toString(),
      id: (m['id'] ?? '').toString(),
      name: m['name']?.toString(),
      slug: m['slug']?.toString(),
      avatar: m['avatar']?.toString(),
    );
  }
}

class BlockController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;

  final RxBool isLoading = true.obs;

  /// القوائم الأساسية (بدون فلترة)
  final RxList<BlockEntry> blockedUsers = <BlockEntry>[].obs;
  final RxList<BlockEntry> blockedStores = <BlockEntry>[].obs;

  /// القوائم بعد البحث
  final RxList<BlockEntry> filteredUsers = <BlockEntry>[].obs;
  final RxList<BlockEntry> filteredStores = <BlockEntry>[].obs;

  Timer? _undoTimer;
  BlockEntry? _lastRemoved;
  int? _lastRemovedIndex;
  int? _lastRemovedTab;

  @override
  void onInit() {
    super.onInit();
    fetchBlocked();
  }

  void changeTab(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) => currentIndex.value = index;

  Future<void> fetchBlocked() async {
    try {
      isLoading.value = true;

      final res = await ApiHelper.get(
        path: '/blocks/blocked-users',
        withLoading: false,
        shouldShowMessage: false,
      );

      final list = (res is Map && res['participants'] is List)
          ? (res['participants'] as List)
          : const [];

      final Map<String, BlockEntry> uniq = {};

      for (final raw in list) {
        if (raw is! Map) continue;
        final entry = BlockEntry.fromParticipantJson(
          Map<String, dynamic>.from(raw),
        );
        if (entry.type.isEmpty || entry.id.isEmpty) continue;
        uniq[entry.key] = entry;
      }

      final users = <BlockEntry>[];
      final stores = <BlockEntry>[];

      for (final e in uniq.values) {
        final t = e.type.toLowerCase();
        if (t == 'store') {
          stores.add(e);
        } else if (t == 'user') {
          users.add(e);
        }
      }

      users.sort((a, b) => a.displayName.compareTo(b.displayName));
      stores.sort((a, b) => a.displayName.compareTo(b.displayName));

      blockedUsers.assignAll(users);
      blockedStores.assignAll(stores);

      filteredUsers.assignAll(users);
      filteredStores.assignAll(stores);
    } catch (e) {
      // ignore: avoid_print
      print('❌ fetchBlocked: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔍 بحث
  void onSearch(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      filteredUsers.assignAll(blockedUsers);
      filteredStores.assignAll(blockedStores);
      return;
    }

    bool match(BlockEntry e) =>
        e.displayName.toLowerCase().contains(q) || e.id.contains(q);

    filteredUsers.assignAll(blockedUsers.where(match));
    filteredStores.assignAll(blockedStores.where(match));
  }

  /// ✅ هل هذا الحساب محظور؟
  bool isBlocked({required String type, required String id}) {
    final key = '${type.toLowerCase()}:$id';
    return blockedUsers.any((e) => e.key == key) ||
        blockedStores.any((e) => e.key == key);
  }

  Future<bool> block({
    required String blockedType,
    required String blockedId,
    String? reason,
  }) async {
    try {
      final form = FormData();
      form.fields.add(MapEntry('blocked_type', blockedType));
      form.fields.add(MapEntry('blocked_id', blockedId));
      if (reason != null && reason.trim().isNotEmpty) {
        form.fields.add(MapEntry('reason', reason.trim()));
      }

      final res = await ApiHelper.post(
        path: '/blocks/block',
        body: form,
        withLoading: true,
        shouldShowMessage: true,
      );

      final ok = (res is Map && res['status'] == true);
      if (ok) {
        await fetchBlocked(); // تحديث القائمة مباشرة
      }
      return ok;
    } catch (e) {
      // ignore: avoid_print
      print('❌ block: $e');
      return false;
    }
  }

  /// ✅ DELETE /blocks/unblock  (FormData: blocked_type, blocked_id)
  Future<bool> unblockDirect({
    required String blockedType,
    required String blockedId,
  }) async {
    try {
      final form = FormData();
      form.fields.add(MapEntry('blocked_type', blockedType));
      form.fields.add(MapEntry('blocked_id', blockedId));

      final res = await ApiHelper.delete(
        path: '/blocks/unblock',
        body: form,
        withLoading: true,
        shouldShowMessage: true,
      );

      final ok = (res is Map && res['status'] == true);
      if (ok) {
        await fetchBlocked();
      }
      return ok;
    } catch (e) {
      // ignore: avoid_print
      print('❌ unblockDirect: $e');
      return false;
    }
  }

  Future<void> unblock({required int tab, required int index}) async {
    _undoTimer?.cancel();

    _lastRemovedTab = tab;
    _lastRemovedIndex = index;

    late BlockEntry removed;
    if (tab == 0) {
      removed = filteredUsers[index];
      blockedUsers.removeWhere((e) => e.key == removed.key);
      filteredUsers.removeAt(index);
    } else {
      removed = filteredStores[index];
      blockedStores.removeWhere((e) => e.key == removed.key);
      filteredStores.removeAt(index);
    }

    _lastRemoved = removed;
    _showUndoSnackbar();

    final ok = await unblockDirect(
      blockedType: removed.type,
      blockedId: removed.id,
    );
    if (!ok) {
      undo();
      return;
    }

    _undoTimer = Timer(const Duration(seconds: 4), _clearUndo);
  }

  void undo() {
    if (_lastRemoved == null ||
        _lastRemovedIndex == null ||
        _lastRemovedTab == null)
      return;

    if (_lastRemovedTab == 0) {
      blockedUsers.insert(_lastRemovedIndex!, _lastRemoved!);
      filteredUsers.assignAll(blockedUsers);
    } else {
      blockedStores.insert(_lastRemovedIndex!, _lastRemoved!);
      filteredStores.assignAll(blockedStores);
    }
    _clearUndo();
  }

  void _clearUndo() {
    _lastRemoved = null;
    _lastRemovedIndex = null;
    _lastRemovedTab = null;
  }

  void _showUndoSnackbar() {
    Get.snackbar(
      'تم إلغاء الحظر',
      'يمكنك التراجع',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      mainButton: TextButton(onPressed: undo, child: const Text('تراجع')),
    );
  }
}
