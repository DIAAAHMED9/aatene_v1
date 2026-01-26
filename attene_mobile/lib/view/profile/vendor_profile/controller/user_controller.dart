import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/profile/common/profile_controller_base.dart';

class VendorProfileController extends BaseProfileController {
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

  // toggleFollow / changeTab come from BaseProfileController
}
