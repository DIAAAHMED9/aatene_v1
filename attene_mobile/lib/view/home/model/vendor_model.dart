/// Model يمثل بيانات الشخص / الخدمة
class ServiceModel {
  final String name;
  final double rating;
  bool isFollowed;

  ServiceModel({
    required this.name,
    required this.rating,
    this.isFollowed = false,
  });
}
