import 'package:attene_mobile/general_index.dart';

class ProfileController extends GetxController {
  final isFollowing = false.obs;
  final currentTab = 0.obs;
  Map<String, dynamic> profileData = {};
  final MyAppController myAppController = Get.find<MyAppController>();

  // @override
  // onInit() {
  //   super.onInit();
  // }

  // Future<void> getPtofileData() async {
  //   ApiHelper response = ApiHelper();
  //   final responseData = await ApiHelper.get(
  //     path: "/profile/${myAppController.userId}",
  //   );
  //   update(['profileController']);
  //
  //   if (responseData != null && responseData['status'] == true) {
  //     profileData = responseData['data']['user'];
  //     print('profileData $profileData');
  //     update(['profileController']);
  //     print("تم استخراج معلومات المستخدم $responseData");
  //   } else {
  //     print("فشل في استخراج معلومات المستخدم");
  //   }
  // }

  void toggleFollow() {
    isFollowing.toggle();
  }

  void changeTab(int index) {
    currentTab.value = index;
  }
}
