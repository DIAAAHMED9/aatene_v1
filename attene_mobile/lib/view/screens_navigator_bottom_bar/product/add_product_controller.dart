// lib/controllers/add_product_controller.dart
import 'package:attene_mobile/view/media_library/media_library_controller.dart';
import 'package:attene_mobile/view/media_library/media_model.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  final RxList<MediaItem> selectedMediaList = <MediaItem>[].obs;
  
  void updateSelectedMedia(List<MediaItem> mediaList) {
    selectedMediaList.assignAll(mediaList);
  }
  
  void removeMedia(int index) {
    if (index >= 0 && index < selectedMediaList.length) {
      selectedMediaList.removeAt(index);
    }
  }
}