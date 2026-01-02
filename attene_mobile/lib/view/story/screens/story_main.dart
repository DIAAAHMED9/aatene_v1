
import '../../../general_index.dart';


class StoryScreen extends StatelessWidget {
  StoryScreen({super.key});

  final stories = [
    StoryItem(
      type: StoryType.image,
      url: 'https://picsum.photos/600/900',
      duration: const Duration(seconds: 5),
    ),
    StoryItem(
      type: StoryType.video,
      url:
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      duration: const Duration(seconds: 8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StoryController());

    // controller.start(stories.first.duration);

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final index = controller.currentIndex.value.clamp(0, stories.length - 1);

          // controller.start(stories[index].duration);

          return Stack(
            children: [
              if (stories[index].text != null)
                Positioned(
                  bottom: 40,
                  left: 16,
                  right: 16,
                  child: Text(
                    stories[index].text!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              Positioned.fill(
                child: StoryMedia(item: stories[index]),
              ),
              Positioned(
                top: 10,
                left: 8,
                right: 8,
                child: StoryProgressBar(total: stories.length),
              ),
              const Positioned.fill(
                child: StoryGestures(),
              ),
            ],
          );
        }),
      ),
    );
  }
}