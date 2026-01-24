import '../../../general_index.dart';

class BlockTabs extends StatelessWidget {
  BlockTabs({super.key});

  final controller = Get.find<BlockController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Row(
            children: [
              _tab(
                text: 'مستخدمين',
                index: 0,
                selected: controller.currentIndex.value == 0,
              ),
              const SizedBox(width: 12),
              _tab(
                text: 'متاجر',
                index: 1,
                selected: controller.currentIndex.value == 1,
              ),
            ],
          ),
          const SizedBox(height: 6),

          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment: controller.currentIndex.value == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width / 2 - 30,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _tab({
    required String text,
    required int index,
    required bool selected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.customColor09 : AppColors.customColor10,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            text,
            style: getMedium(
              color: selected ? Colors.white : AppColors.customColor09,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
