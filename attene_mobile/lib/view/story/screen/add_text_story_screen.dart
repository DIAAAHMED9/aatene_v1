import '../../../general_index.dart';
import '../../../utlis/responsive/index.dart';
import '../index.dart';

class AddTextStoryScreen extends StatelessWidget {
  AddTextStoryScreen({super.key});

  final AddTextStoryController controller = Get.put(AddTextStoryController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Obx(() {
        return Scaffold(
          backgroundColor: controller.backgroundColor.value,
          body: SafeArea(
            child: Stack(
              children: [
                _buildCenterInput(context),
                _buildTopBar(),
                _buildColorPicker(context),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.w(12),
        vertical: ResponsiveDimensions.h(10),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: EdgeInsets.all(ResponsiveDimensions.w(10)),
              decoration: BoxDecoration(
                color: AppColors.neutral1000.withOpacity(0.25),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.neutral900.withOpacity(0.35),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: ResponsiveDimensions.w(18),
                color: AppColors.neutral50,
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: controller.toggleColors,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: EdgeInsets.all(ResponsiveDimensions.w(10)),
              decoration: BoxDecoration(
                color: AppColors.neutral1000.withOpacity(0.25),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.neutral900.withOpacity(0.35),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.palette_outlined,
                size: ResponsiveDimensions.w(20),
                color: AppColors.neutral50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterInput(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.w(24)),
        child: Obx(() {
          final bool isEmpty = controller.text.value.trim().isEmpty;

          return Stack(
            alignment: Alignment.center,
            children: [
              TextField(
                controller: controller.textController,
                focusNode: controller.focusNode,
                textAlign: TextAlign.center,
                maxLines: 8,
                minLines: 1,
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(22),
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral50,
                  height: 1.25,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
              ),
              if (isEmpty)
                IgnorePointer(
                  ignoring: true,
                  child: Text(
                    'اكتب ما تريد',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.f(20),
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral200.withOpacity(0.85),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildColorPicker(BuildContext context) {
    return Obx(() {
      if (!controller.showColors.value) return const SizedBox.shrink();

      return Positioned(
        left: ResponsiveDimensions.w(12),
        right: ResponsiveDimensions.w(12),
        bottom: ResponsiveDimensions.h(12),
        child: StoryColorPickerRow(
          colors: controller.colors,
          selected: controller.backgroundColor.value,
          onSelect: controller.setColor,
          onDone: controller.onDone,
        ),
      );
    });
  }
}
