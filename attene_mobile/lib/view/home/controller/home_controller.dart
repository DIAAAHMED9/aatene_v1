import '../../../general_index.dart';

class HomeController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;
  final RxInt indexForAdds = 0.obs;

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

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startAutoSlide();
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    indexForAdds.value = index;
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (images.isEmpty) return;
      if (!pageController.hasClients) return;

      final nextPage = (currentIndex.value + 1) % images.length;
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
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
    Get.toNamed(AppRoutes.video, arguments: model);
  }

  final service = ServiceModel(name: 'EtnixByron', rating: 5.0).obs;

  void toggleFollow() {
    service.update((val) {
      val!.isFollowed = !val.isFollowed;
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}

class AppRoutes {
  static const video = '/video';
}