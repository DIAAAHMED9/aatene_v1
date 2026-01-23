class StoryCircleModel {
  final String id;
  final String name;
  final String? avatarUrl;

  /// هل هذه دائرة الإضافة (+)؟
  final bool isAddButton;

  /// هل يوجد قصص غير مشاهدة؟
  final bool hasUnseen;

  StoryCircleModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.isAddButton = false,
    this.hasUnseen = false,
  });
}
