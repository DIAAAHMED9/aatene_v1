import '../../../general_index.dart';

class VideoView extends StatelessWidget {
  const VideoView({super.key});

  @override
  Widget build(BuildContext context) {
    final PromoVideoModel model = Get.arguments;

    return GetBuilder<VideoPlayerControllerX>(
      init: VideoPlayerControllerX(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Hero(
              tag: model.id,
              child: controller.controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: controller.controller.value.aspectRatio,
                      child: VideoPlayer(controller.controller),
                    )
                  : const CircularProgressIndicator(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
