import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../model/story_model.dart';
import 'home_controller.dart';

class VideoPlayerControllerX extends GetxController {
  late VideoPlayerController controller;

  @override
  void onInit() {
    super.onInit();
    final PromoVideoModel model = Get.arguments;

    controller = VideoPlayerController.network(model.videoUrl)
      ..initialize().then((_) {
        controller.play();
        update();
      });
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
