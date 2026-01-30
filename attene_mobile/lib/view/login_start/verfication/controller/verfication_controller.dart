

import '../../../../general_index.dart';

class VerificationController extends GetxController {
  final int otpLength = 4;

  late final String sessionId;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxInt resendCountdown = 0.obs;
  final RxBool canResend = true.obs;

  late final List<TextEditingController> textControllers;
  late final List<FocusNode> focusNodes;

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

  void setDigit(int index, String value) {
    if (index < 0 || index >= otpLength) return;

    errorMessage.value = '';

    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleaned.length > 1) {
      _applyPaste(index, cleaned);
      return;
    }

    final v = cleaned;
    textControllers[index].text = v;
  }

  void _applyPaste(int startIndex, String digits) {
    var i = startIndex;
    for (int k = 0; k < digits.length && i < otpLength; k++, i++) {
      textControllers[i].text = digits[k];
    }
  }

  String joinedCode() => textControllers.map((c) => c.text.trim()).join();

  bool isCodeComplete() =>
      joinedCode().length == otpLength &&
      textControllers.every((c) => c.text.trim().isNotEmpty);

Future<void> verifyCode() async {
  final code = joinedCode();

  if (!isCodeComplete()) {
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

    Get.offAllNamed(
      '/ResetPassword',
      arguments: {'id': sessionId, 'code': code},
    );
  } catch (e) {
    errorMessage.value = e.toString();
  } finally {
    isLoading.value = false;
  }
}

  Future<void> resendCode() async => resend();

  Future<void> resend() async {
    if (!canResend.value) return;

    if (sessionId.isEmpty) {
      errorMessage.value = 'معرّف الجلسة غير موجود. أعد طلب الرمز.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      await Future.delayed(const Duration(milliseconds: 300));

      for (final c in textControllers) {
        c.clear();
      }

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
}