import '../../../general_index.dart';

class FavoriteCardAdapter {
  static Widget buildCard(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'product':
        return ProductCard(product: data, showFavoriteButton: true);
      case 'service':
        return ServicesCard(service: data, showFavoriteButton: true);
      case 'store':
        return VendorCard(store: data, showFavoriteButton: true);
      case 'blog':
        return Container();
      default:
        return Container();
    }
  }
}