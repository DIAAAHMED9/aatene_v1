import '../../../general_index.dart';

class ProfileCotrolController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  /// 🔐 Password Controllers
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// ================= EMAIL =================
  Future<bool> updateEmail(String newEmail) async {
    try {
      final response = await ApiHelper.post(
        path: '/auth/account/update_email',
        body: {'email': newEmail},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('updateEmail exception: $e');
      return false;
    }
  }

  /// ================= PHONE =================
  Future<bool> updatePhone(String newPhone) async {
    try {
      final response = await ApiHelper.post(
        path: '/auth/account/update_phone',
        body: {'phone': newPhone},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('updatePhone exception: $e');
      return false;
    }
  }

  /// ================= PASSWORD =================
  Future<bool> updatePassword() async {
    try {
      final response = await ApiHelper.post(
        path: '/auth/account/update_password',
        body: {
          'old_password': oldPasswordController.text.trim(),
          'password': newPasswordController.text.trim(),
          'password_confirmation':
          confirmPasswordController.text.trim(),
        },
      );

      debugPrint('StatusCode: ${response.statusCode}');
      debugPrint('Response: ${response.data}');

      /// ✅ أي رد بدون Exception = نجاح
      return true;
    } catch (e) {
      debugPrint('updatePassword exception: $e');
      return false;
    }
  }
}
