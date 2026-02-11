import 'package:attene_mobile/general_index.dart';
import '../flash_sale_controller.dart';
import '../widget/discount_tabs.dart';
import '../widget/flash_header.dart';
import '../widget/products_page_view.dart';

class FlashSaleView extends StatelessWidget {
  FlashSaleView({super.key});

  final FlashSaleController controller = Get.put(FlashSaleController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            const FlashHeader(),
            const SizedBox(height: 12),

            Obx(
              () => DiscountTabs(
                tabs: controller.tabs,
                selectedIndex: controller.selectedIndex,
                onTap: controller.changeTab,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ProductsPageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}