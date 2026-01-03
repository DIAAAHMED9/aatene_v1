import '../../../general_index.dart';


class StoryProgressBar extends StatelessWidget {
  final int total;

  const StoryProgressBar({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoryController>();

    return Obx(() {
      return Row(
        children: List.generate(total, (index) {
          double value = 0;
          if (index < controller.currentIndex.value) value = 1;
          if (index == controller.currentIndex.value) {
            value = controller.progress.value;
          }

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 3,
                backgroundColor: Colors.white24,
                valueColor:
                const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        }),
      );
    });
  }
}