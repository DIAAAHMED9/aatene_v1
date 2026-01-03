import '../../../general_index.dart';


class AddStoryScreen extends StatelessWidget {
  AddStoryScreen({super.key});

  final urlController = TextEditingController();
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoryController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Story')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Story Text',
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final story = StoryItem(
                  type: StoryType.image,
                  url: urlController.text,
                  duration: const Duration(seconds: 5),
                  text: textController.text,
                );

                controller.stories.add(story);
                StoryAnalytics.storyAdded(story);

                Get.back();
              },
              child: const Text('Publish'),
            )
          ],
        ),
      ),
    );
  }
}