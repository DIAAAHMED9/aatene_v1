import '../../../general_index.dart';
import '../index.dart';

class StoriesController extends GetxController {
  final RxList<StoryCircleModel> circles = <StoryCircleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _seedDemo();
  }

  void _seedDemo() {
    circles.assignAll([
      StoryCircleModel(
        id: 'add',
        name: 'جديد',
        isAddButton: true,
      ),
      StoryCircleModel(
        id: '1',
        name: 'متجر 1',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        hasUnseen: true,
      ),
      StoryCircleModel(
        id: '2',
        name: 'متجر 2',
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        hasUnseen: true,
      ),
      StoryCircleModel(
        id: '3',
        name: 'متجر 3',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        hasUnseen: false,
      ),
      StoryCircleModel(
        id: '4',
        name: 'متجر 4',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        hasUnseen: false,
      ),
    ]);
  }

  Future<void> onAddStory() async {
    final type = await Get.bottomSheet<StoryPublishType>(
      AddStoryTypeSheet(
        onSelect: (t) => Get.back(result: t),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    if (type == null) return;

    switch (type) {
      case StoryPublishType.text:
        Get.to(() => AddTextStoryScreen());
        break;

      case StoryPublishType.image:
        final result = await Get.bottomSheet(
          AddImageStorySheet(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );

        if (result is StoryMediaPickResult) {
          // TODO: نشر قصة صورة عبر API
          print('✅ picked file: ${result.file.path} from tab: ${result.tab}');
        }
        break;

      case StoryPublishType.product:
        final result = await Get.bottomSheet(
          AddProductStorySheet(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );

        if (result is StoryProductPickResult) {
          // TODO: نشر قصة منتج عبر API
          print('✅ picked product id: ${result.productId}');
        }
        break;

      case StoryPublishType.video:
        // TODO: سيتم ربطه لاحقاً (اختيار فيديو + معاينة + نشر)
        break;
    }
  }

  void onOpenStory(StoryCircleModel item) {
    // TODO: فتح عارض القصص لاحقاً
  }
}
