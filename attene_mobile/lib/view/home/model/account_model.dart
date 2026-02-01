import '../../../general_index.dart';

class DrawerAccount {
  final int id;
  final String name;

  final String type;

  final String storeType;

  DrawerAccount({
    required this.id,
    required this.name,
    required this.type,
    required this.storeType,
  });

  String get normalizedMode {
    final t = (storeType.isNotEmpty ? storeType : type).toLowerCase().trim();
    if (t == 'services' || t.contains('service') || t.contains('خدمات')) return 'services';
    if (t == 'mixed' || t == 'both') return 'mixed';
    return 'products';
  }

  static DrawerAccount fromStoreJson(Map<String, dynamic> json) {
    final rawType = (json['type'] ?? '').toString();
    final rawStoreType = (json['store_type'] ?? json['storeType'] ?? '').toString();

    final id = int.tryParse('${json['id'] ?? ''}') ?? 0;
    final name = (json['name'] ?? json['title'] ?? '').toString();

    final type = rawType.isNotEmpty ? rawType : rawStoreType;
    final storeType = rawStoreType.isNotEmpty ? rawStoreType : rawType;

    return DrawerAccount(
      id: id,
      name: name,
      type: type,
      storeType: storeType,
    );
  }
}