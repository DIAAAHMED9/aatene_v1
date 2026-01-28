import '../../../general_index.dart';
import 'home_product.dart';

class HomeServices extends StatelessWidget {
  const HomeServices({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeProduct(initialTab: 1);
  }
}