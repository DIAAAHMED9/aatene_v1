import 'package:get/get.dart';

import '../../../general_index.dart';

class HomeController extends GetxController {
  final RxInt currentPage = 0.obs;
  late PageController pageController; // للتبديل بين المنتجات والخدمات
  
  final RxInt imageSliderCurrentIndex = 0.obs;
  final RxInt adsCurrentIndex = 0.obs;

  final List<String> images = [
    "assets/images/png/closed-store.png",
    "assets/images/png/closed-store.png",
    "assets/images/png/closed-store.png",
    "assets/images/png/closed-store.png",
    "assets/images/png/closed-store.png",
    "assets/images/png/closed-store.png",
  ];

  final ads = <AdModel>[
    AdModel(image: "assets/images/png/closed-store.png"),
    AdModel(image: "assets/images/png/closed-store.png"),
    AdModel(image: "assets/images/png/closed-store.png"),
    AdModel(image: "assets/images/png/closed-store.png"),
  ].obs;

  Timer? _imageSliderTimer;
  Timer? _adsTimer;
  
  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentPage.value);
    _startImageSliderAutoSlide();
    _startAdsAutoSlide();
  }

  void onAdsPageChanged(int index) {
    adsCurrentIndex.value = index;
  }

  void onImageSliderPageChanged(int index) {
    imageSliderCurrentIndex.value = index;
  }

  void _startImageSliderAutoSlide() {
    _imageSliderTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (images.isEmpty) return;

      final nextPage = (imageSliderCurrentIndex.value + 1) % images.length;
      imageSliderCurrentIndex.value = nextPage;
    });
  }

  void _startAdsAutoSlide() {
    _adsTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (ads.isEmpty) return;

      final nextPage = (adsCurrentIndex.value + 1) % ads.length;
      adsCurrentIndex.value = nextPage;
    });
  }

  final List<PromoVideoModel> videos = [
    PromoVideoModel(
      id: '1',
      image: 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
      avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
  ];

  void openVideo(PromoVideoModel model) {
    // Get.toNamed(AppRoutes.video, arguments: model);
  }

  final service = ServiceModel(name: 'EtnixByron', rating: 5.0).obs;

  void toggleFollow() {
    service.update((val) {
      val!.isFollowed = !val.isFollowed;
    });
  }

  @override
  void onClose() {
    _imageSliderTimer?.cancel();
    _adsTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}