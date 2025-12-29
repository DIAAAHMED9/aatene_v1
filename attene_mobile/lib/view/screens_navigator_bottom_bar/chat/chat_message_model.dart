int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  return int.tryParse(v.toString());
}

class ParticipantData {
  final String? id;
  final String? name;
  final String? avatar;
  final String? type;

  const ParticipantData({this.id, this.name, this.avatar, this.type});

  factory ParticipantData.fromJson(Map<String, dynamic> json) => ParticipantData(
        id: json['id']?.toString(),
        name: json['name']?.toString(),
        avatar: json['avatar']?.toString(),
        type: json['type']?.toString(),
      );
}

class ChatParticipant {
  final int id;
  final String? conversationId;

  final ParticipantData? participantData;

  final int? unreadMessagesCount;
  final String? createdAt;
  final String? updatedAt;

  final String? participantType;
  final String? participantId;

  const ChatParticipant({
    required this.id,
    this.conversationId,
    this.participantData,
    this.unreadMessagesCount,
    this.createdAt,
    this.updatedAt,
    this.participantType,
    this.participantId,
  });

  String? get name => participantData?.name;
  String? get avatar => participantData?.avatar;
  String? get type => participantData?.type;

  factory ChatParticipant.fromJson(Map<String, dynamic> json) => ChatParticipant(
        id: _toInt(json['id']) ?? 0,
        conversationId: json['conversation_id']?.toString(),
        participantData: (json['participant_data'] is Map)
            ? ParticipantData.fromJson(Map<String, dynamic>.from(json['participant_data']))
            : null,
        unreadMessagesCount: _toInt(json['unread_messages_count']),
        createdAt: json['created_at']?.toString(),
        updatedAt: json['updated_at']?.toString(),
        participantType: json['participant_type']?.toString(),
        participantId: json['participant_id']?.toString(),
      );
}

class ChatConversation {
  final int id;
  final String type;
  final String? name;
  final String? ownerType;
  final String? ownerId;
  final int participantsCount;
  final List<ChatParticipant> participants;

  final dynamic lastMessage;

  final String? createdAt;
  final String? updatedAt;

  const ChatConversation({
    required this.id,
    required this.type,
    required this.name,
    required this.ownerType,
    required this.ownerId,
    required this.participantsCount,
    required this.participants,
    required this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) => ChatConversation(
        id: _toInt(json['id']) ?? 0,
        type: (json['type'] ?? '').toString(),
        name: json['name']?.toString(),
        ownerType: json['owner_type']?.toString(),
        ownerId: json['owner_id']?.toString(),
        participantsCount: _toInt(json['participants_count']) ?? 0,
        participants: (json['participants'] is List)
            ? (json['participants'] as List)
                .whereType<Map>()
                .map((e) => ChatParticipant.fromJson(Map<String, dynamic>.from(e)))
                .toList()
            : <ChatParticipant>[],
        lastMessage: json['last_message'],
        createdAt: json['created_at']?.toString(),
        updatedAt: json['updated_at']?.toString(),
      );

  int get totalUnread =>
      participants.fold<int>(0, (sum, p) => sum + (p.unreadMessagesCount ?? 0));

  String displayName({String? myOwnerType, String? myOwnerId}) {
    if (type == 'group') return (name?.trim().isNotEmpty ?? false) ? name!.trim() : 'مجموعة';

    for (final p in participants) {
      final d = p.participantData;
      if (d == null) continue;
      final isMe = (myOwnerType != null &&
          myOwnerId != null &&
          d.type == myOwnerType &&
          d.id == myOwnerId);
      if (!isMe) return d.name ?? 'محادثة';
    }
    return name ?? 'محادثة';
  }

  String? displayAvatar({String? myOwnerType, String? myOwnerId}) {
    if (type == 'group') return null;
    for (final p in participants) {
      final d = p.participantData;
      if (d == null) continue;
      final isMe = (myOwnerType != null &&
          myOwnerId != null &&
          d.type == myOwnerType &&
          d.id == myOwnerId);
      if (!isMe) return d.avatar;
    }
    return null;
  }
}

class SenderData {
  final String? id;
  final String? name;
  final String? avatar;
  final String? type;

  const SenderData({this.id, this.name, this.avatar, this.type});

  factory SenderData.fromJson(Map<String, dynamic> json) => SenderData(
        id: json['id']?.toString(),
        name: json['name']?.toString(),
        avatar: json['avatar']?.toString(),
        type: json['type']?.toString(),
      );
}

class ChatMessage {
  final int id;
  final String? conversationId;

  final String? body;

  String? get messageContent => body;

  final dynamic files;
  final dynamic filesUrl;

  final String? senderId;

  final int? productId;
  final int? variationId;
  final int? serviceId;

  final SenderData? senderData;

  final String? createdAt;
  final String? updatedAt;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.body,
    required this.files,
    required this.filesUrl,
    required this.senderId,
    required this.productId,
    required this.variationId,
    required this.serviceId,
    required this.senderData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: _toInt(json['id']) ?? 0,
        conversationId: json['conversation_id']?.toString(),
        body: json['body']?.toString(),
        files: json['files'],
        filesUrl: json['files_url'],
        senderId: json['sender_id']?.toString(),
        productId: _toInt(json['product_id']),
        variationId: _toInt(json['variation_id'] ?? json['varation_id']),
        serviceId: _toInt(json['service_id']),
        senderData: (json['sender_data'] is Map)
            ? SenderData.fromJson(Map<String, dynamic>.from(json['sender_data']))
            : null,
        createdAt: json['created_at']?.toString(),
        updatedAt: json['updated_at']?.toString(),
      );

  List<String> get attachmentUrls {
    final urls = <String>[];
    if (filesUrl is List) {
      for (final v in (filesUrl as List)) {
        if (v == null) continue;
        urls.add(v.toString());
      }
    }
    if (urls.isEmpty && files is List) {
      for (final v in (files as List)) {
        if (v == null) continue;
        if (v is String) urls.add(v);
        if (v is Map && v['url'] != null) urls.add(v['url'].toString());
      }
    }
    return urls;
  }
}