import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/profile/common/profile_controller_base.dart';

class VendorProfileController extends BaseProfileController {
  Map<String, dynamic> storeData = {};
  List<String> coverUrls = [];

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  int currentPage = 0;
  late PageController pageController;

  final MyAppController myAppController = Get.find<MyAppController>();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onReady() {
    super.onReady();
    fetchStoreData();
  }

  void changePage(int index) {
    currentPage = index;
    update();
  }

  Future<void> fetchStoreData() async {
    try {
      isLoading = true;
      hasError = false;
      update();

      final res =
      await ApiHelper.storeData(slug: 'abanob-magdy-hakeem');

      if (res != null && res['status'] == true) {
        storeData = res['store'] ?? {};

        coverUrls = List<String>.from(
          storeData['cover_urls'] ?? [],
        );
      } else {
        hasError = true;
        errorMessage =
            res?['message'] ?? 'حدث خطأ أثناء جلب البيانات';
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}