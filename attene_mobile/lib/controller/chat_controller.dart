import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:attene_mobile/models/chat_models.dart';


import '../api/api_request.dart';
import '../my_app/my_app_controller.dart';
import '../utlis/connection_status.dart';

enum ChatTab { all, unread, interested }

class ChatController extends GetxController {
  static ChatController get to => Get.find();
  
  // WebSocket connection
  WebSocketChannel? _channel;
  Rx<ConnectionStatus> connectionStatus = ConnectionStatus.disconnected.obs;
  StreamSubscription? _webSocketSubscription;
  
  // القوائم القابلة للملاحظة
  RxList<ChatConversation> allConversations = <ChatConversation>[].obs;
  RxList<ChatConversation> unreadConversations = <ChatConversation>[].obs;
  RxList<ChatConversation> interestedConversations = <ChatConversation>[].obs;
  RxList<ChatMessage> currentMessages = <ChatMessage>[].obs;
  RxList<ChatBlock> blocks = <ChatBlock>[].obs;
  
  // حالة التبويب الحالي
  Rx<ChatTab> currentTab = ChatTab.all.obs;
  
  // التحميل والحالة
  RxBool isLoading = false.obs;
  RxBool isLoadingMessages = false.obs;
  RxString searchQuery = ''.obs;
  RxInt totalUnreadCount = 0.obs;
  
  // المحادثة الحالية
  Rx<ChatConversation?> currentConversation = Rx<ChatConversation?>(null);
  
  // Reconnection logic
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;
  
  @override
  void onInit() {
    super.onInit();
    // تحميل البيانات الأولية
    loadInitialData();
    // الاتصال بالـ WebSocket
    _connectToWebSocket();
  }
  
  @override
  void onClose() {
    _disconnectWebSocket();
    _reconnectTimer?.cancel();
    super.onClose();
  }
  
  // --- إضافة الدوال المفقودة ---
  
  Future<void> refreshConversations() async {
    try {
      isLoading.value = true;
      await Future.wait([
        loadConversations(),
        loadUnreadCount(),
      ]);
      update(); // تحديث واجهة المستخدم
    } catch (e) {
      print('خطأ في تحديث المحادثات: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> refreshAllData() async {
    try {
      await Future.wait([
        loadConversations(),
        loadUnreadCount(),
        loadBlocks(),
      ]);
      update();
    } catch (e) {
      print('خطأ في تحديث جميع البيانات: $e');
    }
  }
  
  void _connectToWebSocket() async {
    try {
      // الحصول على التوكن
      if (!Get.isRegistered<MyAppController>()) {
        print('❌ MyAppController غير مسجل');
        connectionStatus.value = ConnectionStatus.error;
        return;
      }
      
      final MyAppController myAppController = Get.find<MyAppController>();
      String? token;
      
      if (myAppController.isLoggedIn.value && 
          myAppController.userData.isNotEmpty && 
          myAppController.userData['token'] != null) {
        token = myAppController.userData['token'];
      }
      
      if (token == null) {
        print('❌ لا يوجد توكن للاتصال بـ WebSocket');
        connectionStatus.value = ConnectionStatus.error;
        return;
      }
      
      // بناء رابط WebSocket
      final baseUrl = ApiHelper.getBaseUrl().replaceAll('https://', 'wss://').replaceAll('http://', 'ws://');
      final wsUrl = '$baseUrl/ws/chat?token=$token';
      
      print('🔌 محاولة الاتصال بـ WebSocket: $wsUrl');
      
      connectionStatus.value = ConnectionStatus.connecting;
      
      _channel = IOWebSocketChannel.connect(
        wsUrl,
        pingInterval: const Duration(seconds: 30),
      );
      
      _webSocketSubscription = _channel!.stream.listen(
        _handleWebSocketMessage,
        onError: (error) {
          print('❌ خطأ في WebSocket: $error');
          connectionStatus.value = ConnectionStatus.error;
          _scheduleReconnection();
        },
        onDone: () {
          print('🔌 تم إغلاق اتصال WebSocket');
          connectionStatus.value = ConnectionStatus.disconnected;
          _scheduleReconnection();
        },
      );
      
      connectionStatus.value = ConnectionStatus.connected;
      _reconnectAttempts = 0;
      print('✅ تم الاتصال بنجاح بـ WebSocket');
      
    } catch (e) {
      print('❌ فشل الاتصال بـ WebSocket: $e');
      connectionStatus.value = ConnectionStatus.error;
      _scheduleReconnection();
    }
  }
  
  void _disconnectWebSocket() {
    _webSocketSubscription?.cancel();
    _channel?.sink.close();
    connectionStatus.value = ConnectionStatus.disconnected;
    print('🔌 تم قطع اتصال WebSocket');
  }
  
  void _scheduleReconnection() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      print('⏰ تجاوزت الحد الأقصى لمحاولات إعادة الاتصال');
      return;
    }
    
    _reconnectTimer?.cancel();
    
    // زيادة التأخير مع كل محاولة (أسي)
    final delay = Duration(seconds: 2 << _reconnectAttempts);
    _reconnectAttempts++;
    
    print('⏰ إعادة الاتصال بعد $delay (المحاولة $_reconnectAttempts)');
    
    _reconnectTimer = Timer(delay, () {
      _connectToWebSocket();
    });
  }
  
  void _handleWebSocketMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      final eventType = data['event'];
      final payload = data['data'];
      
      print('📨 حدث WebSocket: $eventType');
      
      switch (eventType) {
        case 'new_message':
          _handleNewMessage(payload);
          break;
        case 'message_read':
          _handleMessageRead(payload);
          break;
        case 'conversation_updated':
          _handleConversationUpdated(payload);
          break;
        case 'user_online':
          _handleUserOnline(payload);
          break;
        case 'user_offline':
          _handleUserOffline(payload);
          break;
        case 'typing':
          _handleTyping(payload);
          break;
        case 'message_deleted':
          _handleMessageDeleted(payload);
          break;
        case 'conversation_created':
          _handleConversationCreated(payload);
          break;
        case 'block_update':
          _handleBlockUpdate(payload);
          break;
        default:
          print('⚠️ حدث غير معروف: $eventType');
      }
    } catch (e) {
      print('❌ خطأ في معالجة رسالة WebSocket: $e');
    }
  }
  
  void _handleNewMessage(Map<String, dynamic> payload) {
    final message = ChatMessage.fromJson(payload['message']);
    final conversationId = payload['conversation_id'];
    
    // إذا كنا في المحادثة الحالية، نضيف الرسالة
    if (currentConversation.value?.id == conversationId) {
      currentMessages.add(message);
      // إشعار القراءة
      _sendReadReceipt(conversationId);
    }
    
    // تحديث قائمة المحادثات
    _updateConversationLastMessage(conversationId, message.content);
    
    // تحديث العداد
    if (currentConversation.value?.id != conversationId) {
      totalUnreadCount.value = totalUnreadCount.value + 1;
    }
    
    // إشعار للمستخدم
    if (currentConversation.value?.id != conversationId) {
      _showMessageNotification(message);
    }
  }
  
  void _handleMessageRead(Map<String, dynamic> payload) {
    final conversationId = payload['conversation_id'];
    final userId = payload['user_id'];
    
    // تحديث حالة القراءة للرسائل
    for (var i = 0; i < currentMessages.length; i++) {
      if (currentMessages[i].messageType == 'receiver') {
        currentMessages[i] = ChatMessage(
          id: currentMessages[i].id,
          content: currentMessages[i].content,
          messageType: currentMessages[i].messageType,
          timestamp: currentMessages[i].timestamp,
          isRead: true,
          conversationId: currentMessages[i].conversationId,
          senderName: currentMessages[i].senderName,
          senderAvatar: currentMessages[i].senderAvatar,
        );
      }
    }
    
    // تحديث قائمة المحادثات
    _updateConversationUnreadCount(conversationId, 0);
  }
  
  void _handleConversationUpdated(Map<String, dynamic> payload) {
    final conversation = ChatConversation.fromJson(payload);
    
    // تحديث في القائمة الرئيسية
    final index = allConversations.indexWhere((c) => c.id == conversation.id);
    if (index != -1) {
      allConversations[index] = conversation;
    } else {
      allConversations.add(conversation);
    }
    
    // تحديث القوائم الفرعية
    updateFilteredLists();
  }
  
  void _handleUserOnline(Map<String, dynamic> payload) {
    final userId = payload['user_id'];
    
    // تحديث حالة الاتصال للمحادثات
    for (var i = 0; i < allConversations.length; i++) {
      if (allConversations[i].participantType == 'user' && 
          allConversations[i].participantId == userId) {
        allConversations[i] = ChatConversation(
          id: allConversations[i].id,
          name: allConversations[i].name,
          lastMessage: allConversations[i].lastMessage,
          lastMessageTime: allConversations[i].lastMessageTime,
          avatar: allConversations[i].avatar,
          isOnline: true,
          unreadCount: allConversations[i].unreadCount,
          isInterested: allConversations[i].isInterested,
          participantType: allConversations[i].participantType,
          participantId: allConversations[i].participantId,
          isGroup: allConversations[i].isGroup,
        );
      }
    }
    
    updateFilteredLists();
  }
  
  void _handleUserOffline(Map<String, dynamic> payload) {
    final userId = payload['user_id'];
    
    for (var i = 0; i < allConversations.length; i++) {
      if (allConversations[i].participantType == 'user' && 
          allConversations[i].participantId == userId) {
        allConversations[i] = ChatConversation(
          id: allConversations[i].id,
          name: allConversations[i].name,
          lastMessage: allConversations[i].lastMessage,
          lastMessageTime: allConversations[i].lastMessageTime,
          avatar: allConversations[i].avatar,
          isOnline: false,
          unreadCount: allConversations[i].unreadCount,
          isInterested: allConversations[i].isInterested,
          participantType: allConversations[i].participantType,
          participantId: allConversations[i].participantId,
          isGroup: allConversations[i].isGroup,
        );
      }
    }
    
    updateFilteredLists();
  }
  
  void _handleTyping(Map<String, dynamic> payload) {
    // يمكن إضافة مؤشر الكتابة
    final conversationId = payload['conversation_id'];
    final userId = payload['user_id'];
    final isTyping = payload['is_typing'];
    
    // تنفيذ منطق مؤشر الكتابة حسب الحاجة
  }
  
  void _handleMessageDeleted(Map<String, dynamic> payload) {
    final messageId = payload['message_id'];
    final conversationId = payload['conversation_id'];
    
    // حذف الرسالة من القائمة الحالية
    currentMessages.removeWhere((msg) => msg.id == messageId);
    
    // تحديث آخر رسالة في المحادثة
    if (currentMessages.isNotEmpty) {
      final lastMessage = currentMessages.last;
      _updateConversationLastMessage(conversationId, lastMessage.content);
    }
  }
  
  void _handleConversationCreated(Map<String, dynamic> payload) {
    final conversation = ChatConversation.fromJson(payload);
    allConversations.add(conversation);
    updateFilteredLists();
  }
  
  void _handleBlockUpdate(Map<String, dynamic> payload) {
    final isBlocked = payload['is_blocked'];
    final blockedId = payload['blocked_id'];
    final blockedType = payload['blocked_type'];
    
    if (isBlocked) {
      // إضافة للحظر
      final block = ChatBlock(
        id: payload['id'],
        blockedType: blockedType,
        blockedId: blockedId,
        blockedAt: DateTime.parse(payload['blocked_at']),
      );
      blocks.add(block);
    } else {
      // إزالة من الحظر
      blocks.removeWhere((b) => 
        b.blockedType == blockedType && b.blockedId == blockedId);
    }
  }
  
  void _updateConversationLastMessage(int conversationId, String lastMessage) {
    final index = allConversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final updated = allConversations[index];
      allConversations[index] = ChatConversation(
        id: updated.id,
        name: updated.name,
        lastMessage: lastMessage,
        lastMessageTime: DateTime.now(),
        avatar: updated.avatar,
        isOnline: updated.isOnline,
        unreadCount: updated.unreadCount + (currentConversation.value?.id == conversationId ? 0 : 1),
        isInterested: updated.isInterested,
        participantType: updated.participantType,
        participantId: updated.participantId,
        isGroup: updated.isGroup,
      );
      
      updateFilteredLists();
    }
  }
  
  void _updateConversationUnreadCount(int conversationId, int unreadCount) {
    final index = allConversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final updated = allConversations[index];
      allConversations[index] = ChatConversation(
        id: updated.id,
        name: updated.name,
        lastMessage: updated.lastMessage,
        lastMessageTime: updated.lastMessageTime,
        avatar: updated.avatar,
        isOnline: updated.isOnline,
        unreadCount: unreadCount,
        isInterested: updated.isInterested,
        participantType: updated.participantType,
        participantId: updated.participantId,
        isGroup: updated.isGroup,
      );
      
      updateFilteredLists();
    }
  }
  
  void _sendReadReceipt(int conversationId) {
    if (_channel != null && connectionStatus.value == ConnectionStatus.connected) {
      final message = jsonEncode({
        'event': 'message_read',
        'data': {
          'conversation_id': conversationId,
          'timestamp': DateTime.now().toIso8601String(),
        }
      });
      
      _channel!.sink.add(message);
    }
  }
  
  void _showMessageNotification(ChatMessage message) {
    // يمكن استخدام Flutter Local Notifications هنا
    Get.snackbar(
      'رسالة جديدة',
      message.content,
      duration: Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
    );
  }
  
  void sendTypingStatus(int conversationId, bool isTyping) {
    if (_channel != null && connectionStatus.value == ConnectionStatus.connected) {
      final message = jsonEncode({
        'event': 'typing',
        'data': {
          'conversation_id': conversationId,
          'is_typing': isTyping,
        }
      });
      
      _channel!.sink.add(message);
    }
  }
  
  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        loadConversations(),
        loadUnreadCount(),
        loadBlocks(),
      ]);
    } catch (e) {
      print('خطأ في تحميل البيانات الأولية: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> loadConversations() async {
    try {
      final response = await ApiHelper.get(
        path: '/conversations',
        withLoading: false,
        shouldShowMessage: false,
      );
      
      if (response != null && response['data'] is List) {
        final List conversations = response['data'];
        allConversations.assignAll(
          conversations.map((conv) => ChatConversation.fromJson(conv)).toList()
        );
        
        updateFilteredLists();
      }
    } catch (e) {
      print('خطأ في تحميل المحادثات: $e');
    }
  }
  
  Future<void> loadConversationMessages(int conversationId) async {
    try {
      isLoadingMessages.value = true;
      final response = await ApiHelper.get(
        path: '/conversations/$conversationId/messages',
        withLoading: false,
        shouldShowMessage: false,
      );
      
      if (response != null && response['data'] is List) {
        final List messages = response['data'];
        currentMessages.assignAll(
          messages.map((msg) => ChatMessage.fromJson(msg)).toList()
        );
        
        // إرسال إشعار قراءة
        _sendReadReceipt(conversationId);
      }
    } catch (e) {
      print('خطأ في تحميل الرسائل: $e');
    } finally {
      isLoadingMessages.value = false;
    }
  }
  
  Future<void> sendMessage(String message, int conversationId) async {
    try {
      final Map<String, dynamic> body = {
        'content': message,
        'conversation_id': conversationId,
      };
      
      final response = await ApiHelper.post(
        path: '/messages',
        body: body,
        withLoading: true,
        shouldShowMessage: true,
      );
      
      if (response != null) {
        // إضافة الرسالة الجديدة
        final ChatMessage newMessage = ChatMessage.fromJson(response['data']);
        currentMessages.add(newMessage);
        
        // تحديث عبر WebSocket
        if (_channel != null && connectionStatus.value == ConnectionStatus.connected) {
          final wsMessage = jsonEncode({
            'event': 'new_message',
            'data': {
              'message': newMessage.toJson(),
              'conversation_id': conversationId,
            }
          });
          
          _channel!.sink.add(wsMessage);
        }
      }
    } catch (e) {
      print('خطأ في إرسال الرسالة: $e');
      rethrow;
    }
  }
  
  Future<void> markMessagesAsRead(int conversationId) async {
    try {
      await ApiHelper.post(
        path: '/conversations/$conversationId/mark-as-read',
        withLoading: false,
        shouldShowMessage: false,
      );
      
      // إرسال عبر WebSocket
      if (_channel != null && connectionStatus.value == ConnectionStatus.connected) {
        final message = jsonEncode({
          'event': 'message_read',
          'data': {
            'conversation_id': conversationId,
            'user_id': Get.find<MyAppController>().userData['id'],
          }
        });
        
        _channel!.sink.add(message);
      }
    } catch (e) {
      print('خطأ في تحديث حالة القراءة: $e');
    }
  }
  
  Future<void> loadUnreadCount() async {
    try {
      final response = await ApiHelper.get(
        path: '/conversations/unread-count',
        withLoading: false,
        shouldShowMessage: false,
      );
      
      if (response != null && response['total_unread'] != null) {
        totalUnreadCount.value = response['total_unread'];
      }
    } catch (e) {
      print('خطأ في تحميل عدد الرسائل غير المقروءة: $e');
    }
  }
  
  Future<void> toggleInterest(int conversationId, bool isInterested) async {
    try {
      final response = await ApiHelper.post(
        path: '/conversations/$conversationId/toggle-interest',
        body: {'is_interested': isInterested},
        withLoading: true,
        shouldShowMessage: true,
      );
      
      if (response != null) {
        // إرسال عبر WebSocket
        if (_channel != null && connectionStatus.value == ConnectionStatus.connected) {
          final message = jsonEncode({
            'event': 'conversation_updated',
            'data': response['data']
          });
          
          _channel!.sink.add(message);
        }
      }
    } catch (e) {
      print('خطأ في تغيير حالة الاهتمام: $e');
    }
  }
  
  Future<void> blockUser(String blockedType, int blockedId) async {
    try {
      final response = await ApiHelper.post(
        path: '/blocks/block',
        body: {
          'blocked_type': blockedType,
          'blocked_id': blockedId,
        },
        withLoading: true,
        shouldShowMessage: true,
      );
      
      if (response != null) {
        // إرسال عبر WebSocket
        if (_channel != null && connectionStatus.value == ConnectionStatus.connected) {
          final message = jsonEncode({
            'event': 'block_update',
            'data': response['data']
          });
          
          _channel!.sink.add(message);
        }
      }
    } catch (e) {
      print('خطأ في حظر المستخدم: $e');
    }
  }
  
  Future<void> unblockUser(int blockId) async {
    try {
      final response = await ApiHelper.delete(
        path: '/blocks/unblock/$blockId',
        withLoading: true,
        shouldShowMessage: true,
      );
      
      if (response != null) {
        // إرسال عبر WebSocket
        if (_channel != null && connectionStatus.value == ConnectionStatus.connected) {
          final message = jsonEncode({
            'event': 'block_update',
            'data': response['data']
          });
          
          _channel!.sink.add(message);
        }
      }
    } catch (e) {
      print('خطأ في إلغاء حظر المستخدم: $e');
    }
  }
  
  Future<void> loadBlocks() async {
    try {
      final response = await ApiHelper.get(
        path: '/blocks',
        withLoading: false,
        shouldShowMessage: false,
      );
      
      if (response != null && response['data'] is List) {
        final List blocksData = response['data'];
        blocks.assignAll(
          blocksData.map((block) => ChatBlock.fromJson(block)).toList()
        );
      }
    } catch (e) {
      print('خطأ في تحميل قائمة المحظورين: $e');
    }
  }
  
  Future<void> createConversation(Map<String, dynamic> participantData) async {
    try {
      final response = await ApiHelper.post(
        path: '/conversations',
        body: participantData,
        withLoading: true,
        shouldShowMessage: true,
      );
      
      if (response != null) {
        // إرسال عبر WebSocket
        if (_channel != null && connectionStatus.value == ConnectionStatus.connected) {
          final message = jsonEncode({
            'event': 'conversation_created',
            'data': response['data']
          });
          
          _channel!.sink.add(message);
        }
      }
    } catch (e) {
      print('خطأ في إنشاء محادثة جديدة: $e');
    }
  }
  
  void updateFilteredLists() {
    // تحديث قائمة غير المقروء
    unreadConversations.assignAll(
      allConversations.where((conv) => conv.unreadCount > 0).toList()
    );
    
    // تحديث قائمة المهتمين
    interestedConversations.assignAll(
      allConversations.where((conv) => conv.isInterested).toList()
    );
    
    // تحديث العدد الإجمالي غير المقروء
    totalUnreadCount.value = allConversations.fold(
      0, (sum, conv) => sum + conv.unreadCount);
    
    update();
  }
  
  void setCurrentTab(ChatTab tab) {
    currentTab.value = tab;
    update();
  }
  
  void setCurrentConversation(ChatConversation conversation) {
    currentConversation.value = conversation;
  }
  
  void clearCurrentConversation() {
    currentConversation.value = null;
    currentMessages.clear();
  }
  
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    update();
  }
  
  List<ChatConversation> getFilteredConversations() {
    List<ChatConversation> sourceList;
    
    switch (currentTab.value) {
      case ChatTab.unread:
        sourceList = unreadConversations;
        break;
      case ChatTab.interested:
        sourceList = interestedConversations;
        break;
      default:
        sourceList = allConversations;
    }
    
    if (searchQuery.value.isEmpty) {
      return sourceList;
    }
    
    return sourceList.where((conv) {
      return conv.name?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false;
    }).toList();
  }
  
  void reconnectWebSocket() {
    _reconnectAttempts = 0;
    _connectToWebSocket();
  }
}