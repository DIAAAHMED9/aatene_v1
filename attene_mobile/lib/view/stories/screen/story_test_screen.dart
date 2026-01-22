import '../../../general_index.dart';


class StoryTestScreen extends StatefulWidget {
  const StoryTestScreen({super.key});

  @override
  State<StoryTestScreen> createState() => _StoryTestScreenState();
}

class _StoryTestScreenState extends State<StoryTestScreen> {
  late final StoriesController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<StoriesController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchStories(withLoading: true);
    });
  }

  Future<void> _openAddStory() async {
    final result = await Get.to<bool>(() => const AddStoryScreen());
    if (result == true) {
      await controller.fetchStories(withLoading: false);
      controller.stories.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stories Test'),
        actions: [
          IconButton(
            onPressed: () => controller.fetchStories(withLoading: true),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddStory,
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        final items = controller.stories;

        if (controller.isLoading.value && items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (items.isEmpty) {
          return Center(
            child: ElevatedButton(
              onPressed: () => controller.fetchStories(withLoading: true),
              child: const Text('تحميل القصص'),
            ),
          );
        }

        final thumbnail = items.first.imageUrl;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('قصص المتجر', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    StoryBubble(
                      imageUrl: thumbnail,
                      title: 'المتجر',
                      count: items.length,
                      onTap: () => Get.to(() => StoryViewerScreen(stories: items, initialIndex: 0)),
                    ),
                  ],
                ),
              ),
             
            ],
          ),
        );
      }),
    );
  }
}
