import '../../../../general_index.dart';
import '../../common/profile_controller_base.dart';

class ProfileController extends BaseProfileController {
  Map<String, dynamic> profileData = {};
  RxBool isLoading = RxBool(true);
  RxBool hasError = RxBool(false);
  String errorMessage = '';
  
  final MyAppController myAppController = Get.find<MyAppController>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAccountData();
    });
  }

  Future<void> fetchAccountData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      print('fetchAccountData called');
      final res = await ApiHelper.account();
      print('response account data: $res');
      
      if (res != null && res['status'] == true) {
        print('Account data fetched successfully');
        profileData = res['user'] ?? {};
        
        if (Get.isRegistered<MyAppController>()) {
          final myAppController = Get.find<MyAppController>();
          myAppController.updateUserData(profileData);
        }
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Failed to load profile data';
        print('Error: $errorMessage');
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in fetchAccountData: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void toggleFollow() {
    update();
  }
}