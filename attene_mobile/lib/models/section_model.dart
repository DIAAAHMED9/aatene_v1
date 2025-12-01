// lib/models/section_model.dart
class Section {
  final int id;
  final String name;
  final String? image;
  final String? imageUrl;
  final String storeId;

  Section({
    required this.id,
    required this.name,
    this.image,
    this.imageUrl,
    required this.storeId,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      imageUrl: json['image_url'],
      storeId: json['store_id']?.toString() ?? json['storeId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'image_url': imageUrl,
      'store_id': storeId,
    };
  }

  @override
  String toString() {
    return 'Section{id: $id, name: $name, storeId: $storeId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Section &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}