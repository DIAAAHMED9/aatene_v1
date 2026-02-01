import 'dart:async';

import '../../../../general_index.dart';

class VerificationController extends GetxController {
  static const int otpLength = 4;

  late final String sessionId;

  final RxList<String> codes = List<String>.filled(otpLength, '').obs;

  late final List<TextEditingController> textControllers;
  late final List<FocusNode> focusNodes;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxInt resendCountdown = 0.obs;
  final RxBool canResend = true.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    String? id;
    if (args is String) {
      id = args;
    } else if (args is Map) {
      final m = Map<String, dynamic>.from(args as Map);
      id = (m['id'] ?? m['sessionId'] ?? m['otp_id'] ?? m['otpId'])?.toString();
    }
    sessionId = (id ?? '').trim();

    textControllers = List.generate(otpLength, (_) => TextEditingController());
    focusNodes = List.generate(otpLength, (_) => FocusNode());

    ever<int>(resendCountdown, (v) => canResend.value = v <= 0);

    startResendCountdown(seconds: 60);
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (final c in textControllers) {
      c.dispose();
    }
    for (final n in focusNodes) {
      n.dispose();
    }
    super.onClose();
  }

  void updateCode(int index, String value) {
    if (index < 0 || index >= codes.length) return;

    var v = value;
    if (v.length > 1) v = v.substring(v.length - 1);

    if (v.isNotEmpty && !RegExp(r'^\d$').hasMatch(v)) {
      textControllers[index].text = codes[index];
      return;
    }

    codes[index] = v;
    if (textControllers[index].text != v) {
      textControllers[index].text = v;
      textControllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: textControllers[index].text.length),
      );
    }
    errorMessage.value = '';
  }

  String get joinedCode => codes.join();

  bool get isCodeComplete =>
      joinedCode.length == otpLength && codes.every((c) => c.isNotEmpty);

  Future<void> verifyCode() async {
    if (!isCodeComplete) {
      errorMessage.value = 'يرجى إدخال رمز التحقق بالكامل';
      return;
    }
    if (sessionId.isEmpty) {
      errorMessage.value = 'معرّف الجلسة غير موجود. أعد طلب الرمز.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final res = await ApiHelper.verifyOtp(
        id: sessionId,
        code: joinedCode,
        withLoading: false,
        shouldShowMessage: true,
      );

      final ok = (res is Map) && ((res['status'] == true) || (res['success'] == true));
      if (!ok) {
        errorMessage.value = (res is Map && res['message'] != null)
            ? '${res['message']}'
            : 'فشل التحقق';
        return;
      }

      Get.offAllNamed(
        '/set_new_password',
        arguments: {
          'id': sessionId,
          'code': joinedCode,
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendCode() async {
    if (!canResend.value) return;
    if (sessionId.isEmpty) {
      errorMessage.value = 'معرّف الجلسة غير موجود. أعد طلب الرمز.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      await ApiHelper.resendOtp(
        id: sessionId,
        withLoading: false,
        shouldShowMessage: true,
      );

      startResendCountdown(seconds: 60);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void startResendCountdown({required int seconds}) {
    _timer?.cancel();
    resendCountdown.value = seconds;
    canResend.value = seconds <= 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final next = resendCountdown.value - 1;
      resendCountdown.value = next;
      if (next <= 0) {
        resendCountdown.value = 0;
        canResend.value = true;
        t.cancel();
      }
    });
  }

  void moveNextFocus(BuildContext context, int index) {
    if (index < otpLength - 1) {
      FocusScope.of(context).nextFocus();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  void movePrevFocus(BuildContext context, int index) {
    if (index > 0) {
      FocusScope.of(context).previousFocus();
    }
  }
}