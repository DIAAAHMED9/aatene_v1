import '../../../general_index.dart';


class StoryGestures extends StatelessWidget {
  const StoryGestures({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoryController>();

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: controller.previous,
            onLongPress: controller.pause,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: controller.next,
            onLongPress: controller.pause,
          ),
        ),
      ],
    );
  }
}