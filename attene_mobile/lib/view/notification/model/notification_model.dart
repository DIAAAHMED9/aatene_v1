class NotificationModel {
  final String title;
  final String body;
  final String time;
  final String? image;
  final bool isRead;

  NotificationModel({
    required this.title,
    required this.body,
    required this.time,
    this.image,
    required this.isRead,
  });

  NotificationModel copyWith({
    String? title,
    String? body,
    String? time,
    String? image,
    bool? isRead,
  }) {
    return NotificationModel(
      title: title ?? this.title,
      body: body ?? this.body,
      time: time ?? this.time,
      image: image ?? this.image,
      isRead: isRead ?? this.isRead,
    );
  }
}