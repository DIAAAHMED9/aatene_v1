class ChatConversation {
  final int id;
  final String? name;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? avatar;
  final bool isOnline;
  final int unreadCount;
  final bool isInterested;
  final String participantType;
  final int participantId;
  final bool isGroup;

  ChatConversation({
    required this.id,
    this.name,
    this.lastMessage,
    this.lastMessageTime,
    this.avatar,
    this.isOnline = false,
    this.unreadCount = 0,
    this.isInterested = false,
    required this.participantType,
    required this.participantId,
    this.isGroup = false,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] ?? 0,
      name: json['name'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'] != null 
          ? DateTime.parse(json['last_message_time']) 
          : null,
      avatar: json['avatar'],
      isOnline: json['is_online'] ?? false,
      unreadCount: json['unread_count'] ?? 0,
      isInterested: json['is_interested'] ?? false,
      participantType: json['participant_type'] ?? 'user',
      participantId: json['participant_id'] ?? 0,
      isGroup: json['is_group'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime?.toIso8601String(),
      'avatar': avatar,
      'is_online': isOnline,
      'unread_count': unreadCount,
      'is_interested': isInterested,
      'participant_type': participantType,
      'participant_id': participantId,
      'is_group': isGroup,
    };
  }
}

class ChatMessage {
  final int id;
  final String content;
  final String messageType; // 'sender' or 'receiver'
  final DateTime timestamp;
  final bool isRead;
  final int? conversationId;
  final String? senderName;
  final String? senderAvatar;

  ChatMessage({
    required this.id,
    required this.content,
    required this.messageType,
    required this.timestamp,
    this.isRead = false,
    this.conversationId,
    this.senderName,
    this.senderAvatar,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      messageType: json['message_type'] ?? 'receiver',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : DateTime.now(),
      isRead: json['is_read'] ?? false,
      conversationId: json['conversation_id'],
      senderName: json['sender_name'],
      senderAvatar: json['sender_avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'message_type': messageType,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
      'conversation_id': conversationId,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
    };
  }
}

class ChatBlock {
  final int id;
  final String blockedType;
  final int blockedId;
  final DateTime blockedAt;

  ChatBlock({
    required this.id,
    required this.blockedType,
    required this.blockedId,
    required this.blockedAt,
  });

  factory ChatBlock.fromJson(Map<String, dynamic> json) {
    return ChatBlock(
      id: json['id'] ?? 0,
      blockedType: json['blocked_type'] ?? 'user',
      blockedId: json['blocked_id'] ?? 0,
      blockedAt: json['blocked_at'] != null 
          ? DateTime.parse(json['blocked_at']) 
          : DateTime.now(),
    );
  }
}