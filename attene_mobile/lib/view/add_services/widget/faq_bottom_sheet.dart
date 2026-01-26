

import '../../../general_index.dart';
import '../../../utils/responsive/responsive_dimensions.dart';

class FAQBottomSheet extends StatefulWidget {
  final FAQ? faq;

  const FAQBottomSheet({super.key, this.faq});

  @override
  State<FAQBottomSheet> createState() => _FAQBottomSheetState();
}

class _FAQBottomSheetState extends State<FAQBottomSheet> {
  late TextEditingController questionController;
  late TextEditingController answerController;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(
      text: widget.faq?.question ?? '',
    );
    answerController = TextEditingController(text: widget.faq?.answer ?? '');
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceController>();

    return Container(
      height: ResponsiveDimensions.responsiveHeight(550),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.faq == null
                      ? 'إضافة سؤال شائع'
                      : 'تعديل السؤال الشائع',
                  style: getBold(
                    fontSize: ResponsiveDimensions.responsiveFontSize(18),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: ResponsiveDimensions.responsiveFontSize(24),
                  ),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveDimensions.responsiveWidth(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('السؤال', style: getBold()),
                  SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
                  TextField(
                    controller: questionController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'اكتب السؤال هنا',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(
                        ResponsiveDimensions.responsiveWidth(12),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),
                  Text('الجواب', style: getBold()),
                  SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
                  TextField(
                    controller: answerController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'اكتب الجواب هنا',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(
                        ResponsiveDimensions.responsiveWidth(12),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveDimensions.responsiveHeight(40)),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final question = questionController.text.trim();
                  final answer = answerController.text.trim();

                  if (question.isEmpty || answer.isEmpty) {
                    Get.snackbar(
                      'تنبيه',
                      'يرجى ملء جميع الحقول',
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  if (widget.faq == null) {
                    controller.addFAQ(question, answer);
                    Get.back();

                    Get.snackbar(
                      'تمت الإضافة',
                      'تم إضافة السؤال بنجاح',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } else {
                    controller.updateFAQ(widget.faq!.id??0, question, answer);
                    Get.back();

                    Get.snackbar(
                      'تم التحديث',
                      'تم تحديث السؤال بنجاح',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary400,
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveDimensions.responsiveHeight(16),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  widget.faq == null ? 'إضافة السؤال' : 'تحديث السؤال',
                  style: getMedium(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(20)),
        ],
      ),
    );
  }
}