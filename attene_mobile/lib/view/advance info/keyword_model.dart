class Keyword {
  final String id;
  final String text;
  final String category;

  Keyword({required this.id, required this.text, required this.category});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Keyword && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}