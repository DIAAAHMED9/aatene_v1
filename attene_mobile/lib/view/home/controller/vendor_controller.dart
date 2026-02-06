import '../../../general_index.dart';

class ServiceController extends GetxController {
  final service = ServiceModel(name: 'EtnixByron', rating: 5.0).obs;

  void toggleFollow() {
    service.update((val) {
      val!.isFollowed = !val.isFollowed;
    });
  }
}
