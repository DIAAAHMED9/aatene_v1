import '../../../general_index.dart';
import '../../../utlis/responsive/index.dart';
import '../index.dart';

class StoriesHighlightsScreen extends StatelessWidget {
  StoriesHighlightsScreen({super.key});

  final StoriesController controller = Get.put(StoriesController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: ResponsiveDimensions.getSectionPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ابرز القصص و العروض',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(16),
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(12)),
                _buildStoriesList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoriesList() {
    final double height = ResponsiveDimensions.h(104);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Obx(() {
        final items = controller.circles;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(width: ResponsiveDimensions.w(10)),
          itemBuilder: (context, index) {
            final item = items[index];

            return StoryCircleItem(
              title: item.name,
              imageUrl: item.avatarUrl,
              isAddButton: item.isAddButton,
              hasUnseen: item.hasUnseen,
              onTap: () {
                if (item.isAddButton) {
                  controller.onAddStory();
                  return;
                }
                controller.onOpenStory(item);
              },
            );
          },
        );
      }),
    );
  }
}
