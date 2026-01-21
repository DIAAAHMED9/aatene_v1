import '../../../general_index.dart';

/// Controller مسؤول عن منطق المتابعة
class ServiceController extends GetxController {
  /// بيانات وهمية
  final service = ServiceModel(
    name: 'EtnixByron',
    rating: 5.0,
  ).obs;

  /// تبديل حالة المتابعة
  void toggleFollow() {
    service.update((val) {
      val!.isFollowed = !val.isFollowed;
    });
  }
}
