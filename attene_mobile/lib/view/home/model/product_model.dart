/// Model يمثل المنتج
class ProductModel {
  final String title;
  final double price;
  final List<String> images;
  final bool isSponsored;

  ProductModel({
    required this.title,
    required this.price,
    required this.images,
    this.isSponsored = false,
  });
}
