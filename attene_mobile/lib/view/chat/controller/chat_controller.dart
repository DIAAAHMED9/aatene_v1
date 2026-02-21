import '../../../general_index.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/platform/dio_multipart.dart';

enum ChatTab { all, unread, active, notActive, interested, groub }

class ChatController extends GetxController {
  static ChatController get to => Get.find();

  String? myOwnerType;
  String? myOwnerId;

  final Rx<ChatTab> currentTab = ChatTab.all.obs;
  final RxString searchQuery = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMessages = false.obs;

  final RxList<ChatConversation> allConversations = <ChatConversation>[].obs;
  final RxList<ChatConversation> unreadConversations = <ChatConversation>[].obs;
  final RxList<ChatConversation> interestedConversations =
      <ChatConversation>[].obs;
  final RxList<ChatConversation> groubConversations = <ChatConversation>[].obs;
  final RxList<ChatConversation> filteredConversations =
      <ChatConversation>[].obs;

  final RxList<Map<String, dynamic>> previousParticipants =
      <Map<String, dynamic>>[].obs;

  final Rxn<ChatConversation> currentConversation = Rxn<ChatConversation>();
  final RxList<ChatMessage> currentMessages = <ChatMessage>[].obs;

  Timer? _pollTimer;
  int? _pollConversationId;

  bool _messagesFetchInFlight = false;
  DateTime? _lastMessagesFetchAt;
  final Map<int, DateTime> _openedAt = <int, DateTime>{};

  final Set<String> _blockedKeySet = <String>{};
  final RxInt blockedVersion = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _resolveIdentity();
    if (!ApiHelper.hasAuthToken) {
      print('ℹ️ [CHAT] Guest mode: skipping chat initialization');
      return;
    }

    loadInitialData();
    refreshBlockedCache(silent: true);
  }

  @override
  void onClose() {
    _stopPolling();
    super.onClose();
  }

  Future<void> loadInitialData() async {
    await Future.wait([loadConversations(), loadPreviousParticipants()]);
  }

  Future<void> refreshBlockedCache({bool silent = false}) async {
    try {
      final res = await ApiHelper.get(
        path: '/blocks/blocked-users',
        withLoading: false,
        shouldShowMessage: false,
      );

      final Set<String> next = <String>{};
      if (res is Map && res['status'] == true && res['participants'] is List) {
        for (final p in (res['participants'] as List)) {
          if (p is! Map) continue;
          final pd = (p['participant_data'] is Map)
              ? Map<String, dynamic>.from(p['participant_data'])
              : <String, dynamic>{};
          final t = (pd['type'] ?? '').toString().toLowerCase();
          final id = (pd['id'] ?? '').toString();
          if (t.isEmpty || id.isEmpty) continue;

          if (myOwnerType != null &&
              myOwnerId != null &&
              t == myOwnerType &&
              id == myOwnerId)
            continue;

          next.add('$t:$id');
        }
      }

      _blockedKeySet
        ..clear()
        ..addAll(next);
      blockedVersion.value++;
    } catch (e) {
      if (!silent) {
        print('❌ refreshBlockedCache: $e');
      }
    }
  }

  bool isBlockedEntity({required String type, required String id}) {
    return _blockedKeySet.contains('${type.toLowerCase()}:$id');
  }

  Map<String, String>? otherSideOfDirect(ChatConversation conv) {
    if ((conv.type ?? '').toLowerCase() != 'direct') return null;
    for (final p in conv.participants) {
      final d = p.participantData;
      if (d == null) continue;
      final t = (d.type ?? '').toString();
      final id = (d.id ?? '').toString();
      if (t.isEmpty || id.isEmpty) continue;
      if (myOwnerType != null &&
          myOwnerId != null &&
          t == myOwnerType &&
          id == myOwnerId)
        continue;
      return {'type': t, 'id': id};
    }
    return null;
  }

  bool isConversationBlocked(ChatConversation conv) {
    final other = otherSideOfDirect(conv);
    if (other == null) return false;
    return isBlockedEntity(type: other['type']!, id: other['id']!);
  }

  Future<bool> blockEntity({
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
        await refreshBlockedCache(silent: true);
        if (Get.isRegistered<BlockController>()) {
          await Get.find<BlockController>().fetchBlocked();
        }
      }
      return ok;
    } catch (e) {
      print('❌ blockEntity: $e');
      return false;
    }
  }

  Future<bool> unBlockEntity({
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
        await refreshBlockedCache(silent: true);
        if (Get.isRegistered<BlockController>()) {
          await Get.find<BlockController>().fetchBlocked();
        }
      }
      return ok;
    } catch (e) {
      print('❌ unBlockEntity: $e');
      return false;
    }
  }

  void _resolveIdentity() {
    try {
      if (!Get.isRegistered<MyAppController>()) return;
      final c = Get.find<MyAppController>();

      final ud = (c.userData is Map)
          ? Map<String, dynamic>.from(c.userData)
          : <String, dynamic>{};

      final type = (ud['type'] ?? ud['owner_type'] ?? ud['user_type'])
          ?.toString();

      if (type == 'store') {
        myOwnerType = 'store';
        myOwnerId = (ud['store_id'] ?? ud['id'] ?? ud['owner_id'])?.toString();
        return;
      }
      if (type == 'user') {
        myOwnerType = 'user';
        myOwnerId = (ud['user_id'] ?? ud['id'] ?? ud['owner_id'])?.toString();
        return;
      }

      if (ud['store_id'] != null) {
        myOwnerType = 'store';
        myOwnerId = (ud['store_id'] ?? ud['id'])?.toString();
        return;
      }

      final sid = ApiHelper.getStoreIdOrNull();
      if (sid != null) {
        myOwnerType = 'store';
        myOwnerId = sid.toString();
        return;
      }

      if (ud['id'] != null) {
        myOwnerType = 'user';
        myOwnerId = ud['id']?.toString();
      }
    } catch (_) {}
  }

  ChatConversation? _findConversation(int id) {
    final idx = allConversations.indexWhere((c) => c.id == id);
    if (idx >= 0) return allConversations[idx];
    return null;
  }

  ChatParticipant? _myParticipantForConversation(ChatConversation conv) {
    for (final p in conv.participants) {
      final d = p.participantData;
      if (d == null) continue;
      final isMe =
          (myOwnerType != null &&
          myOwnerId != null &&
          d.type == myOwnerType &&
          d.id == myOwnerId);
      if (isMe) return p;
    }
    return null;
  }

  Future<void> refreshConversations() async {
    await loadConversations();
    await loadPreviousParticipants();
  }

  Future<void> loadConversations({bool silent = false}) async {
    try {
      if (!silent) isLoading.value = true;

      final res = await ApiHelper.get(
        path: '/conversations',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (res is Map && res['status'] == true) {
        final raw = res['conversations'] ?? res['data'];
        if (raw is List) {
          final list = raw
              .whereType<Map>()
              .map(
                (e) => ChatConversation.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList();

          allConversations.assignAll(list);

          unreadConversations.assignAll(
            list.where((c) => c.totalUnread > 0).toList(),
          );

          interestedConversations.assignAll(
            list
                .where((c) => (c.type == 'direct' || c.type == 'group'))
                .toList(),
          );
          groubConversations.assignAll(
            list.where((c) => (c.type == 'group')).toList(),
          );
          _applyFilters();
        }
      }
    } catch (e) {
      print('❌ loadConversations: $e');
    } finally {
      if (!silent) isLoading.value = false;
    }
  }

  void _applyFilters() {
    final q = searchQuery.value.trim().toLowerCase();

    List<ChatConversation> base;
    switch (currentTab.value) {
      case ChatTab.unread:
        base = unreadConversations.toList();
        break;
      case ChatTab.interested:
        base = interestedConversations.toList();
        break;
      case ChatTab.groub:
        base = groubConversations.toList();
        break;
      case ChatTab.active:
        base = allConversations.where((c) => c.lastMessage != null).toList();
        break;
      case ChatTab.notActive:
        base = allConversations.where((c) => c.lastMessage == null).toList();
        break;
      case ChatTab.all:
      default:
        base = allConversations.toList();
        break;
    }

    if (q.isNotEmpty) {
      base = base.where((c) {
        final name = c
            .displayName(myOwnerType: myOwnerType, myOwnerId: myOwnerId)
            .toLowerCase();
        return name.contains(q);
      }).toList();
    }

    filteredConversations.assignAll(base);
  }

  void setSearch(String v) {
    searchQuery.value = v;
    _applyFilters();
  }

  void setTab(ChatTab tab) {
    currentTab.value = tab;
    _applyFilters();
  }

  Future<void> loadPreviousParticipants() async {
    try {
      final res = await ApiHelper.get(
        path: '/conversations/prev_participants',
        withLoading: false,
        shouldShowMessage: false,
      );
      if (res is Map && res['status'] == true && res['participants'] is List) {
        previousParticipants.assignAll(
          (res['participants'] as List)
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList(),
        );
      }
    } catch (e) {
      print('❌ loadPreviousParticipants: $e');
    }
  }

  Future<void> loadUnreadCounts() async {
    await loadConversations();
  }

  Future<void> openConversation(ChatConversation conversation) async {
    currentConversation.value = conversation;

    // Remember open time (used to do a one-shot delayed refresh).
    _openedAt[conversation.id] = DateTime.now();

    await loadConversationMessages(conversation.id);

    // Some backends may not surface the first message immediately.
    // Do a single delayed refresh if the list is still empty.
    if (currentConversation.value?.id == conversation.id &&
        currentMessages.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        if (currentConversation.value?.id != conversation.id) return;
        await loadConversationMessages(conversation.id, silent: true);
      });
    }

    _startPolling(conversation.id);
  }

  void _startPolling(int conversationId) {
    // Prevent creating multiple timers for the same conversation.
    if (_pollConversationId == conversationId && _pollTimer != null) return;

    _stopPolling();
    _pollConversationId = conversationId;

    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      if (currentConversation.value?.id != conversationId) return;
      await loadConversationMessages(conversationId, silent: true);
    });
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _pollConversationId = null;
  }

  /// Call this when leaving the chat detail page.
  void leaveConversation(int conversationId) {
    if (currentConversation.value?.id == conversationId) {
      _stopPolling();
      currentConversation.value = null;
      currentMessages.clear();
    }
  }

  Future<ChatConversation?> loadConversationDetails(int conversationId) async {
    final local = _findConversation(conversationId);
    if (local != null) return local;

    await loadConversations();
    return _findConversation(conversationId);
  }

  Future<void> loadConversationMessages(
    int conversationId, {
    bool silent = false,
  }) async {
    try {
      // Avoid overlapping fetches (polling + screen refresh).
      if (_messagesFetchInFlight) return;

      // Throttle silent polling bursts.
      if (silent && _lastMessagesFetchAt != null) {
        final diff = DateTime.now().difference(_lastMessagesFetchAt!);
        if (diff.inMilliseconds < 500) return;
      }

      _messagesFetchInFlight = true;
      _lastMessagesFetchAt = DateTime.now();

      if (!silent) isLoadingMessages.value = true;

      final res = await ApiHelper.get(
        path: '/conversations/$conversationId/messages',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (res is Map && res['status'] == true) {
        final raw = res['messages'] ?? res['data'];
        if (raw is List) {
          final list = raw
              .whereType<Map>()
              .map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          list.sort((a, b) {
            final aa = a.createdAt ?? '';
            final bb = b.createdAt ?? '';
            return aa.compareTo(bb);
          });

          currentMessages.assignAll(list);
        }
      }
    } catch (e) {
      print('❌ loadConversationMessages: $e');
    } finally {
      _messagesFetchInFlight = false;
      if (!silent) isLoadingMessages.value = false;
    }
  }

  Future<ChatMessage?> sendTextMessage({
    required int conversationId,
    required String text,
  }) async {
    return sendMessage(conversationId: conversationId, body: text);
  }

  Future<ChatMessage?> sendFilesMessage({
    required int conversationId,
    required List<XFile> files,
    String? text,
  }) async {
    final paths = files.map((f) => f.path).toList();
    return sendMessage(
      conversationId: conversationId,
      body: text,
      filePaths: paths,
    );
  }

  Future<ChatMessage?> sendMessage({
    required int conversationId,
    String? body,
    List<String>? filePaths,
    int? productId,
    int? serviceId,
    int? varationId,
  }) async {
    try {
      final conv =
          _findConversation(conversationId) ?? currentConversation.value;
      if (conv == null) {
        throw 'Conversation not found locally';
      }

      final ownerType = myOwnerType;
      final ownerId = myOwnerId ?? ApiHelper.getStoreIdOrNull();
      if (ownerType == null || ownerId == null) {
        throw 'Cannot determine my participant identity (type/id)';
      }

      // ✅ Optimistic UI: insert a pending message locally.
      final int pendingId = -DateTime.now().millisecondsSinceEpoch;
      final String pendingText = (body ?? '').trim();
      final bool hasAnyText = pendingText.isNotEmpty;
      final bool hasAnyFiles = filePaths != null && filePaths.isNotEmpty;
      ChatMessage? pending;

      if (currentConversation.value?.id == conversationId &&
          (hasAnyText || hasAnyFiles)) {
        try {
          final myName = () {
            try {
              if (Get.isRegistered<MyAppController>()) {
                final ud = Get.find<MyAppController>().userData;
                if (ud is Map) {
                  return (ud['fullname'] ?? ud['name'] ?? ud['email'])?.toString();
                }
              }
            } catch (_) {}
            return null;
          }();

          pending = ChatMessage(
            id: pendingId,
            conversationId: conversationId.toString(),
            body: pendingText.isNotEmpty ? pendingText : '...',
            files: null,
            filesUrl: null,
            senderId: _myParticipantForConversation(conv)?.id.toString(),
            productId: productId,
            variationId: varationId,
            serviceId: serviceId,
            senderData: SenderData(
              id: ownerId.toString(),
              type: ownerType,
              name: myName,
              avatar: null,
            ),
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
          );
          currentMessages.add(pending);
        } catch (_) {}
      }

      final form = FormData();

      form.fields.add(MapEntry('conversation_id', conversationId.toString()));
      form.fields.add(MapEntry('participant_type', ownerType));
      form.fields.add(MapEntry('participant_id', ownerId.toString()));
      if (body != null && body.trim().isNotEmpty) {
        form.fields.add(MapEntry('body', body.trim()));
      }
      if (productId != null)
        form.fields.add(MapEntry('product_id', productId.toString()));
      if (serviceId != null)
        form.fields.add(MapEntry('service_id', serviceId.toString()));
      if (varationId != null)
        form.fields.add(MapEntry('varation_id', varationId.toString()));

      if (filePaths != null && filePaths.isNotEmpty) {
        for (final p in filePaths) {
          final mf = await dioMultipartFromLocalPath(p);
          if (mf != null) {
            form.files.add(MapEntry('files[]', mf));
          }
        }
      }

      final res = await ApiHelper.post(
        path: '/messages',
        body: form,
        withLoading: true,
        shouldShowMessage: false,
      );

      if (res is Map && res['status'] == true && res['message'] is Map) {
        final msg = ChatMessage.fromJson(
          Map<String, dynamic>.from(res['message']),
        );

        if (currentConversation.value?.id == conversationId) {
          // Replace pending message if exists.
          if (pending != null) {
            final idx = currentMessages.indexWhere((m) => m.id == pendingId);
            if (idx >= 0) {
              currentMessages[idx] = msg;
            } else {
              currentMessages.add(msg);
            }
          } else {
            currentMessages.add(msg);
          }

          // One-shot delayed sync to ensure backend catches up.
          Future.delayed(const Duration(milliseconds: 400), () {
            if (currentConversation.value?.id == conversationId) {
              loadConversationMessages(conversationId, silent: true);
            }
          });
        }

        final convJson = (res['message'] as Map)['conversation'];
        if (convJson is Map) {
          final updated = ChatConversation.fromJson(
            Map<String, dynamic>.from(convJson),
          );
          _upsertConversation(updated);
        } else {
          final idx = allConversations.indexWhere(
            (c) => c.id == conversationId,
          );
          if (idx >= 0) {
            final c0 = allConversations.removeAt(idx);
            allConversations.insert(0, c0);
          }
        }
        _applyFilters();
        return msg;
      }

      // If request failed, remove pending message.
      if (pending != null && currentConversation.value?.id == conversationId) {
        currentMessages.removeWhere((m) => m.id == pendingId);
      }
    } catch (e) {
      print('❌ sendMessage: $e');

      // Cleanup pending in case of exceptions.
      try {
        currentMessages.removeWhere(
          (m) => m.id < 0 && (m.conversationId ?? '') == conversationId.toString(),
        );
      } catch (_) {}
    }
    return null;
  }

  /// Start (or reuse) a direct conversation by sending a first context message.
  ///
  /// This matches the Postman flow you verified:
  /// POST /messages with participant_type + participant_id (no conversation_id)
  /// and optionally product_id/service_id.
  Future<ChatConversation?> startDirectChatByFirstMessage({
    required String participantType,
    required String participantId,
    String? body,
    int? productId,
    int? serviceId,
    int? varationId,
  }) async {
    try {
      final pt = participantType.trim();
      final pid = participantId.trim();
      if (pt.isEmpty || pid.isEmpty) {
        throw 'participant_type/participant_id are required';
      }

      final form = FormData();
      form.fields.add(MapEntry('participant_type', pt));
      form.fields.add(MapEntry('participant_id', pid));

      final text = (body ?? '').trim();
      // Many backends require body; send a safe default if empty.
      form.fields.add(MapEntry('body', text.isNotEmpty ? text : 'مرحباً'));

      if (productId != null) {
        form.fields.add(MapEntry('product_id', productId.toString()));
      }
      if (serviceId != null) {
        form.fields.add(MapEntry('service_id', serviceId.toString()));
      }
      if (varationId != null) {
        form.fields.add(MapEntry('varation_id', varationId.toString()));
      }

      final res = await ApiHelper.post(
        path: '/messages',
        body: form,
        withLoading: true,
        shouldShowMessage: true,
      );

      if (res is Map && res['status'] == true) {
        final msgJson = (res['message'] is Map)
            ? Map<String, dynamic>.from(res['message'] as Map)
            : null;

        Map<String, dynamic>? convJson;
        if (msgJson != null && msgJson['conversation'] is Map) {
          convJson = Map<String, dynamic>.from(msgJson['conversation'] as Map);
        } else if (res['conversation'] is Map) {
          convJson = Map<String, dynamic>.from(res['conversation'] as Map);
        }

        if (convJson != null) {
          final conv = ChatConversation.fromJson(convJson);
          _upsertConversation(conv);
          _applyFilters();

          // If chat is already open on this conversation, append the message.
          if (msgJson != null) {
            try {
              final msg = ChatMessage.fromJson(msgJson);
              if (currentConversation.value?.id == conv.id) {
                currentMessages.add(msg);
              }
            } catch (_) {}
          }

          return conv;
        }
      }
    } catch (e) {
      print('❌ startDirectChatByFirstMessage: $e');
    }
    return null;
  }

  void _upsertConversation(ChatConversation conv) {
    final idx = allConversations.indexWhere((c) => c.id == conv.id);
    if (idx < 0) {
      allConversations.insert(0, conv);
    } else {
      allConversations[idx] = conv;
      final c0 = allConversations.removeAt(idx);
      allConversations.insert(0, c0);
    }
  }

  Future<bool> markMessageSeen(int messageId) async {
    try {
      final res = await ApiHelper.post(
        path: '/messages/$messageId/seen',
        body: {},
        withLoading: false,
        shouldShowMessage: false,
      );
      return (res is Map && res['status'] == true);
    } catch (_) {}
    return false;
  }

  Future<ChatConversation?> createConversation({
    required String type,
    String? name,
    required List<Map<String, dynamic>> participants,
    String? storeId,
    Map<String, dynamic>? headers,
  }) async {
    try {
      for (final p in participants) {
        final t = (p['type'] ?? '').toString();
        final id = (p['id'] ?? '').toString();
        if (t.isEmpty || id.isEmpty) continue;
        if (isBlockedEntity(type: t, id: id)) {
          Get.snackbar('غير مسموح', 'لا يمكنك بدء محادثة/إضافة شخص محظور');
          return null;
        }
      }

      final body = <String, dynamic>{
        'type': type,
        if (name != null) 'name': name,
        'participants': participants,
      };

      final _headers = <String, dynamic>{
        ...?headers,
        if (storeId != null && storeId.trim().isNotEmpty) 'storeId': storeId.trim(),
      };

      final res = await ApiHelper.post(
        path: '/conversations',
        body: body,
        headers: _headers.isEmpty ? null : _headers,
        withLoading: true,
        shouldShowMessage: true,
      );

      if (res is Map && res['status'] == true && res['conversation'] is Map) {
        final conv = ChatConversation.fromJson(
          Map<String, dynamic>.from(res['conversation']),
        );
        _upsertConversation(conv);
        _applyFilters();
        return conv;
      }
    } catch (e) {
      print('❌ createConversation: $e');
    }
    return null;
  }

  Future<bool> updateGroupName({
    required int conversationId,
    required String name,
  }) async {
    try {
      final res = await ApiHelper.patch(
        path: '/conversations/$conversationId',
        body: {'name': name},
        withLoading: true,
        shouldShowMessage: true,
      );

      if (res is Map && res['status'] == true) {
        await loadConversations(silent: true);

        if (currentConversation.value?.id == conversationId) {
          final idx = allConversations.indexWhere(
            (c) => c.id == conversationId,
          );
          if (idx >= 0) currentConversation.value = allConversations[idx];
        }
        _applyFilters();
        return true;
      }
    } catch (e) {
      print('❌ updateGroupName: $e');
    }
    return false;
  }

  Future<bool> deleteConversation(int conversationId) async {
    try {
      final res = await ApiHelper.delete(
        path: '/conversations/$conversationId',
        withLoading: true,
        shouldShowMessage: true,
      );

      if (res is Map && res['status'] == true) {
        allConversations.removeWhere((c) => c.id == conversationId);
        unreadConversations.removeWhere((c) => c.id == conversationId);
        interestedConversations.removeWhere((c) => c.id == conversationId);
        groubConversations.removeWhere((c) => c.id == conversationId);
        filteredConversations.removeWhere((c) => c.id == conversationId);

        if (currentConversation.value?.id == conversationId) {
          currentConversation.value = null;
          currentMessages.clear();
        }
        _applyFilters();
        return true;
      }
    } catch (e) {
      print('❌ deleteConversation: $e');
    }
    return false;
  }

  Future<bool> addParticipant({
    required int conversationId,
    required Map<String, dynamic> participant,
  }) async {
    try {
      final t = (participant['type'] ?? '').toString();
      final id = (participant['id'] ?? '').toString();
      if (t.isNotEmpty && id.isNotEmpty && isBlockedEntity(type: t, id: id)) {
        Get.snackbar('غير مسموح', 'لا يمكنك إضافة شخص محظور إلى المجموعة');
        return false;
      }

      final res = await ApiHelper.post(
        path: '/conversations/$conversationId/participants',
        body: participant,
        withLoading: true,
        shouldShowMessage: true,
      );

      if (res is Map && res['status'] == true) {
        await loadConversations();
        return true;
      }
    } catch (e) {
      print('❌ addParticipant: $e');
    }
    return false;
  }

  Future<bool> removeParticipant({
    required int conversationId,
    required int participantRecordId,
  }) async {
    try {
      final res = await ApiHelper.delete(
        path:
            '/conversations/$conversationId/participants/$participantRecordId',
        withLoading: true,
        shouldShowMessage: true,
      );

      if (res is Map && res['status'] == true) {
        await loadConversations();
        return true;
      }
    } catch (e) {
      print('❌ removeParticipant: $e');
    }
    return false;
  }
}