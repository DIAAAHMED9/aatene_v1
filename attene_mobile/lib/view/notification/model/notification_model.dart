class NotificationModel {
  final int id;
  final String notificationId;
  final String title;
  final String body;
  final List<dynamic> media;
  final dynamic payload;
  final dynamic data;
  final bool isRead;
  final DateTime? seenAt;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.notificationId,
    required this.title,
    required this.body,
    required this.media,
    this.payload,
    this.data,
    required this.isRead,
    this.seenAt,
    this.createdAt,
  });

  /// ================== FROM JSON ==================
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      notificationId: json['notification_id']?.toString() ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      media: json['media'] ?? [],
      payload: json['payload'],
      data: json['data'],
      isRead: json['seen'] ?? false,
      seenAt: json['seen_at'] != null
          ? DateTime.tryParse(json['seen_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  /// ================== TO JSON ==================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notification_id': notificationId,
      'title': title,
      'body': body,
      'media': media,
      'payload': payload,
      'data': data,
      'seen': isRead,
      'seen_at': seenAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// ================== COPY WITH ==================
  NotificationModel copyWith({
    int? id,
    String? notificationId,
    String? title,
    String? body,
    List<dynamic>? media,
    dynamic payload,
    dynamic data,
    bool? isRead,
    DateTime? seenAt,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      body: body ?? this.body,
      media: media ?? this.media,
      payload: payload ?? this.payload,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      seenAt: seenAt ?? this.seenAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
