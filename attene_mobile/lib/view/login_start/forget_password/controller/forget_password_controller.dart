

import '../../../../general_index.dart';

class ForgetPasswordController extends GetxController {
  var email = ''.obs;
  var isLoading = false.obs;
  var emailError = RxString('');

  void updateEmail(String value) {
    email.value = value;
    emailError.value = '';
  }

  bool validateFields() {
    bool isValid = true;
    if (email.value.isEmpty) {
      emailError.value = 'يرجى إدخال البريد الإلكتروني';
      isValid = false;
    } else if (!isValidEmail(email.value)) {
      emailError.value = 'يرجى إدخال بريد إلكتروني صحيح';
      isValid = false;
    } else {
      emailError.value = '';
    }
    return isValid;
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> sendPasswordReset() async {
    if (!validateFields()) {
      return;
    }

    isLoading.value = true;

    try {
      print('📧 إرسال طلب إعادة تعيين كلمة المرور لـ: ${email.value}');

      final response = await ApiHelper.post(
        path: '/auth/password/send_code',
        body: {'identifier': email.value.trim()},
        withLoading: false,
      );

      print('📄 استجابة الخادم: $response');

      if (response != null &&
          (response['status'] == true || response['success'] == true)) {
        Get.snackbar(
          'نجاح',
          response['message'] ?? 'تم إرسال رمز التحقق إلى بريدك الإلكتروني',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );

        Get.toNamed(
          '/verification',
          arguments: {
            'email': email.value,
            'isForgetPassword': true,
            'verificationType': 'password_reset',
          },
        );
      } else {
        _handleApiError(response);
      }
    } catch (error) {
      print('❌ خطأ في إرسال طلب إعادة التعيين: $error');
      _handleGeneralError(error);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleApiError(dynamic response) {
    String errorMessage =
        'فشل إرسال طلب إعادة التعيين. يرجى المحاولة مرة أخرى.';

    if (response != null) {
      if (response['message'] != null) {
        errorMessage = response['message'];
      }

      if (response['errors'] != null) {
        final errors = response['errors'];
        if (errors['identifier'] != null) {
          if (errors['identifier'] is List) {
            emailError.value = errors['identifier'][0];
          } else {
            emailError.value = errors['identifier'].toString();
          }
        } else if (errors['email'] != null) {
          if (errors['email'] is List) {
            emailError.value = errors['email'][0];
          } else {
            emailError.value = errors['email'].toString();
          }
        }
      }
    }

    _showErrorSnackbar(errorMessage);
  }

  void _handleGeneralError(dynamic error) {
    String errorMessage = 'حدث خطأ أثناء إرسال طلب إعادة التعيين. ';

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage += 'انتهت مهلة الاتصال. يرجى التحقق من اتصال الإنترنت.';
          break;
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 404) {
            errorMessage = 'البريد الإلكتروني غير مسجل في النظام.';
          } else if (statusCode == 422) {
            errorMessage =
                'بيانات غير صالحة. يرجى التحقق من البريد الإلكتروني.';
          } else if (statusCode == 429) {
            errorMessage =
                'لقد تجاوزت عدد المحاولات المسموح بها. يرجى الانتظار قليلاً.';
          } else if (statusCode == 500) {
            errorMessage = 'خطأ في الخادم الداخلي. يرجى المحاولة لاحقاً.';
          } else {
            errorMessage += 'استجابة غير صالحة من الخادم (كود: $statusCode).';
          }
          break;
        case DioExceptionType.cancel:
          errorMessage += 'تم إلغاء الطلب.';
          break;
        case DioExceptionType.unknown:
          if (error.error?.toString().contains('SocketException') == true) {
            errorMessage = 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الاتصال.';
          } else {
            errorMessage += 'خطأ غير معروف في الاتصال.';
          }
          break;
        default:
          errorMessage += 'خطأ غير متوقع.';
      }
    } else {
      errorMessage += error.toString();
    }

    _showErrorSnackbar(errorMessage);
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'خطأ',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
    );
  }

  void goBack() {
    Get.back();
  }

  void clearForm() {
    email.value = '';
    emailError.value = '';
  }

  @override
  void onClose() {
    clearForm();
    super.onClose();
  }
}