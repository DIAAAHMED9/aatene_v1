import 'package:get/get.dart';

class MyAppController extends GetxController {
  var userData = <String, dynamic>{}.obs;
  var isInternetConnect = true.obs;
  var noInternetWaitingRequests = <Map<String, dynamic>>[].obs;

  void updateUserData(Map<String, dynamic> data) {
    userData.value = data;
  }

  void updateInternetStatus(bool status) {
    isInternetConnect.value = status;
  }

  void onSignOut() {
    userData.value = {};
    noInternetWaitingRequests.clear();
  }

  String? get token => userData['token'];

  bool get isLoggedIn => userData.isNotEmpty && userData['token'] != null;

  @override
  void onClose() {
    noInternetWaitingRequests.clear();
    super.onClose();
  }
}
