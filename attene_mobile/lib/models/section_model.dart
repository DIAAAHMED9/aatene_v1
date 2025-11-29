// lib/model/section_model.dart
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
      storeId: json['store_id']?.toString() ?? '',
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
    return 'Section(id: $id, name: $name)';
  }

  Section copyWith({
    int? id,
    String? name,
    String? image,
    String? imageUrl,
    String? storeId,
  }) {
    return Section(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      imageUrl: imageUrl ?? this.imageUrl,
      storeId: storeId ?? this.storeId,
    );
  }
}