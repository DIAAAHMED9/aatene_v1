import '../../../general_index.dart';

class AddTextStoryController extends GetxController {
  final RxString text = ''.obs;

  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final Rx<Color> backgroundColor = AppColors.neutral1000.obs;

  final RxBool showColors = false.obs;

  List<Color> get colors => [
        AppColors.primary400,
        AppColors.primary300,
        AppColors.neutral1000,
        AppColors.neutral900,
        AppColors.neutral800,
        AppColors.neutral700,
        Colors.deepPurple,
        Colors.pinkAccent,
        Colors.orange,
        Colors.teal,
        Colors.blue,
        Colors.green,
        Colors.redAccent,
      ];

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      text.value = textController.text;
    });

    Future.delayed(const Duration(milliseconds: 120), () {
      if (!focusNode.hasFocus) {
        focusNode.requestFocus();
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void toggleColors() {
    showColors.value = !showColors.value;
    if (!showColors.value) {
      focusNode.requestFocus();
    }
  }

  void setColor(Color c) {
    backgroundColor.value = c;
  }

  void onDone() {
    showColors.value = false;

    // TODO: ربط النشر/التأكيد لاحقاً
    Get.back();
  }
}
