import '../../../general_index.dart';
import '../../../utlis/responsive/index.dart';
import '../index.dart';

class AddProductStorySheet extends StatelessWidget {
  AddProductStorySheet({super.key});

  final AddProductStorySheetController controller =
      Get.put(AddProductStorySheetController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.88,
        padding: EdgeInsets.only(
          top: ResponsiveDimensions.h(10),
          left: ResponsiveDimensions.w(12),
          right: ResponsiveDimensions.w(12),
          bottom: ResponsiveDimensions.h(12) + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.bottomSheetBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ResponsiveDimensions.w(18)),
          ),
        ),
        child: Column(
          children: [
            _handle(),
            SizedBox(height: ResponsiveDimensions.h(8)),
            _title(),
            SizedBox(height: ResponsiveDimensions.h(12)),
            StoryProductSearchBar(
              controller: controller.searchController,
              onFilterTap: controller.onOpenFilters,
            ),
            SizedBox(height: ResponsiveDimensions.h(12)),
            _grid(),
            SizedBox(height: ResponsiveDimensions.h(10)),
            _publishButton(),
          ],
        ),
      ),
    );
  }

  Widget _handle() {
    return Container(
      width: ResponsiveDimensions.w(42),
      height: ResponsiveDimensions.h(5),
      decoration: BoxDecoration(
        color: AppColors.neutral900,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _title() {
    return Center(
      child: Text(
        'عرض المنتج',
        style: TextStyle(
          fontSize: ResponsiveDimensions.f(15),
          fontWeight: FontWeight.bold,
          color: AppColors.neutral200,
        ),
      ),
    );
  }

  Widget _grid() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return Center(
            child: Text(
              'لا يوجد منتجات',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(13),
                fontWeight: FontWeight.w600,
                color: AppColors.neutral600,
              ),
            ),
          );
        }

        final selected = controller.selectedProduct.value;

        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: ResponsiveDimensions.w(10),
            crossAxisSpacing: ResponsiveDimensions.w(10),
            childAspectRatio: 0.90,
          ),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final p = controller.products[index];
            final bool isSelected = selected == p;

            return StoryProductGridItem(
              product: p,
              selected: isSelected,
              onTap: () => controller.select(p),
            );
          },
        );
      }),
    );
  }

  Widget _publishButton() {
    return Obx(() {
      final enabled = controller.selectedProduct.value != null;

      return SizedBox(
        width: double.infinity,
        height: ResponsiveDimensions.h(48),
        child: ElevatedButton(
          onPressed: enabled ? controller.onPublish : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled ? AppColors.primary400 : AppColors.neutral900,
            disabledBackgroundColor: AppColors.neutral900,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveDimensions.w(12)),
            ),
          ),
          child: Text(
            'نشر',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(14),
              fontWeight: FontWeight.bold,
              color: enabled ? AppColors.neutral1000 : AppColors.neutral600,
            ),
          ),
        ),
      );
    });
  }
}
