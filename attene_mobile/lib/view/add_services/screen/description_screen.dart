import 'dart:convert';
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:attene_mobile/utils/colors/app_color.dart';
import '../../../utils/responsive/index.dart';
import '../index.dart';

class DescriptionScreen extends StatefulWidget {
  const DescriptionScreen({super.key});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  final ServiceController controller = Get.find<ServiceController>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDescriptionInfo(),

            _buildEnhancedEditor(),

            _buildFAQsSection(),

            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.responsiveWidth(16),
        vertical: ResponsiveDimensions.responsiveHeight(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'وصف مفصل للخدمة',
                style: getBold(
                  fontSize: ResponsiveDimensions.responsiveFontSize(20),
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.debugDescription();
                },
                icon: Icon(Icons.edit_note_rounded),
                tooltip: 'تصحيح الوصف',
              ),
            ],
          ),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
          Obx(() {
            final hasError =
                controller.isDescriptionError.value &&
                controller.hasUserTypedInDescription.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'يجب أن يكون الوصف واضحاً ومفصلاً لمساعدة العملاء على فهم الخدمة بشكل أفضل.',
                  style: getRegular(
                    fontSize: ResponsiveDimensions.responsiveFontSize(12),
                    color: Color(0xFF757575),
                  ),
                ),
                if (hasError)
                  Padding(
                    padding: EdgeInsets.only(
                      top: ResponsiveDimensions.responsiveHeight(4),
                    ),
                    child: Text(
                      '⚠️ الرجاء إضافة وصف مفصل للخدمة',
                      style: TextStyle(
                        fontFamily: "PingAR",
                        fontSize: ResponsiveDimensions.responsiveFontSize(12),
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEnhancedEditor() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.responsiveWidth(16),
        vertical: ResponsiveDimensions.responsiveHeight(8),
      ),
      child: Column(
        children: [
          Container(
            height: ResponsiveDimensions.responsiveHeight(300),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    controller.isDescriptionError.value &&
                        controller.hasUserTypedInDescription.value
                    ? Colors.red
                    : Colors.grey[300]!,
                width:
                    controller.isDescriptionError.value &&
                        controller.hasUserTypedInDescription.value
                    ? 2
                    : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildEnhancedToolbar(),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(
                      ResponsiveDimensions.responsiveWidth(12),
                    ),
                    child: Obx(() {
                      final showPlaceholder =
                          controller.showDescriptionPlaceholder.value &&
                          !controller.editorFocusNode.hasFocus;

                      return Stack(
                        children: [
                          QuillEditor(
                            controller: controller.quillController,
                            focusNode: controller.editorFocusNode,
                            scrollController: controller.editorScrollController,
                          ),

                          if (showPlaceholder)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: IgnorePointer(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.editorFocusNode.requestFocus();
                                    setState(() {
                                      controller
                                              .showDescriptionPlaceholder
                                              .value =
                                          false;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(
                                      ResponsiveDimensions.responsiveWidth(8),
                                    ),
                                    child: Text(
                                      ServiceController
                                          .defaultDescriptionPlaceholder,
                                      style: TextStyle(
                                        fontFamily: "PingAR",
                                        fontSize:
                                            ResponsiveDimensions.responsiveFontSize(
                                              16,
                                            ),
                                        color: Colors.grey[400],
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedToolbar() {
    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(8)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasicFormattingRow(),
          Divider(color: Colors.grey.shade300),

          _buildAdvancedFormattingRow(),
          Divider(color: Colors.grey.shade300),

          _buildHeadingsAndSpecialRow(),
        ],
      ),
    );
  }

  Widget _buildBasicFormattingRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildToolbarButton(
            icon: Icons.format_bold,
            tooltip: 'عريض',
            isActive: false,
            onPressed: () => _toggleFormat('bold'),
          ),
          _buildToolbarButton(
            icon: Icons.format_italic,
            tooltip: 'مائل',
            isActive: false,
            onPressed: () => _toggleFormat('italic'),
          ),
          _buildToolbarButton(
            icon: Icons.format_underlined,
            tooltip: 'تحته خط',
            isActive: false,
            onPressed: () => _toggleFormat('underline'),
          ),
          _buildToolbarButton(
            icon: Icons.strikethrough_s,
            tooltip: 'يتوسطه خط',
            isActive: false,
            onPressed: () => _toggleFormat('strikethrough'),
          ),
          SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
          _buildToolbarButton(
            icon: Icons.format_color_text,
            tooltip: 'لون النص',
            isActive: false,
            onPressed: () => _showColorPickerDialog(isTextColor: true),
          ),
          _buildToolbarButton(
            icon: Icons.format_color_fill,
            tooltip: 'لون الخلفية',
            isActive: false,
            onPressed: () => _showColorPickerDialog(isTextColor: false),
          ),
          _buildFontSizeDropdown(),
        ],
      ),
    );
  }

  Widget _buildAdvancedFormattingRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildAlignmentButtons(),
          SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
          _buildHeadingButton(1, 'H1'),
          _buildHeadingButton(2, 'H2'),
          _buildHeadingButton(3, 'H3'),
          _buildHeadingButton(4, 'H4'),
          _buildHeadingButton(5, 'H5'),
        ],
      ),
    );
  }

  Widget _buildHeadingsAndSpecialRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildToolbarButton(
            icon: Icons.format_list_bulleted,
            tooltip: 'قائمة نقطية',
            isActive: false,
            onPressed: () => _toggleFormat('bullet'),
          ),
          _buildToolbarButton(
            icon: Icons.format_list_numbered,
            tooltip: 'قائمة رقمية',
            isActive: false,
            onPressed: () => _toggleFormat('ordered'),
          ),
          SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
          _buildToolbarButton(
            icon: Icons.image,
            tooltip: 'إدراج صورة',
            isActive: false,
            onPressed: _showImageInsertDialog,
          ),
          _buildToolbarButton(
            icon: Icons.code,
            tooltip: 'كتلة كود',
            isActive: false,
            onPressed: _insertCodeBlock,
          ),
          _buildToolbarButton(
            icon: Icons.attach_file,
            tooltip: 'إرفاق ملف',
            isActive: false,
            onPressed: _pickFile,
          ),
        ],
      ),
    );
  }

  Widget _buildHeadingButton(int level, String label) {
    return Tooltip(
      message: 'عنوان $level',
      child: Material(
        borderRadius: BorderRadius.circular(6),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () => _toggleHeading(level),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            child: Text(
              label,
              style: getRegular(
                fontSize: ResponsiveDimensions.responsiveFontSize(14),
                fontWeight: FontWeight.w500,
                color: Color(0xFF303030),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFontSizeDropdown() {
    final List<Map<String, dynamic>> fontSizes = [
      {'value': 10.0, 'label': '10px'},
      {'value': 12.0, 'label': '12px'},
      {'value': 14.0, 'label': '14px'},
      {'value': 16.0, 'label': '16px'},
      {'value': 18.0, 'label': '18px'},
      {'value': 20.0, 'label': '20px'},
      {'value': 24.0, 'label': '24px'},
      {'value': 28.0, 'label': '28px'},
      {'value': 32.0, 'label': '32px'},
      {'value': 36.0, 'label': '36px'},
    ];

    return PopupMenuButton<double>(
      tooltip: 'حجم الخط',
      onSelected: (value) {
        _setFontSize(value);
      },
      itemBuilder: (context) {
        return fontSizes.map((size) {
          return PopupMenuItem<double>(
            value: size['value'],
            child: Text(
              size['label'],
              style: TextStyle(fontSize: size['value']),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Icon(
              Icons.text_fields,
              size: ResponsiveDimensions.responsiveFontSize(18),
              color: Colors.grey[700],
            ),
            SizedBox(width: ResponsiveDimensions.responsiveWidth(4)),
            Text(
              '16',
              style: TextStyle(
                fontSize: ResponsiveDimensions.responsiveFontSize(14),
                color: Colors.grey[700],
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: ResponsiveDimensions.responsiveFontSize(18),
              color: Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlignmentButtons() {
    return Row(
      children: [
        _buildAlignmentButton(Icons.format_align_left, 'يسار', 'left'),
        _buildAlignmentButton(Icons.format_align_center, 'وسط', 'center'),
        _buildAlignmentButton(Icons.format_align_right, 'يمين', 'right'),
      ],
    );
  }

  Widget _buildAlignmentButton(
    IconData icon,
    String tooltip,
    String alignment,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.responsiveWidth(2),
      ),
      child: Tooltip(
        message: tooltip,
        child: Material(
          borderRadius: BorderRadius.circular(4),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () => _setAlignment(alignment),
            child: Container(
              width: ResponsiveDimensions.responsiveWidth(36),
              height: ResponsiveDimensions.responsiveHeight(36),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: ResponsiveDimensions.responsiveFontSize(18),
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String tooltip,
    required bool isActive,
    required VoidCallback? onPressed,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.responsiveWidth(2),
      ),
      child: Tooltip(
        message: tooltip,
        child: Material(
          borderRadius: BorderRadius.circular(4),
          color: isActive ? AppColors.primary400 : Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: onPressed,
            child: Container(
              width: ResponsiveDimensions.responsiveWidth(36),
              height: ResponsiveDimensions.responsiveHeight(36),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: ResponsiveDimensions.responsiveFontSize(18),
                color: isActive ? Colors.white : Colors.grey[700],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQsSection() {
    return Padding(
      padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveDimensions.responsiveHeight(7)),
          Text(
            'الأسئلة الشائعة (اختياري)',
            style: getBold(
              fontSize: ResponsiveDimensions.responsiveFontSize(18),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(4)),

          Text(
            'اكتب إجابات للأسئلة الشائعة التي يطرحها عميلك. أضف حتى خمسة أسئلة.',
            style: getRegular(
              fontSize: ResponsiveDimensions.responsiveFontSize(10),
              fontWeight: FontWeight.w300,
              color: Colors.grey.shade500,
            ),
          ),

          SizedBox(height: ResponsiveDimensions.responsiveHeight(12)),
          Obx(() {
            final canAdd = controller.faqs.length < ServiceController.maxFAQs;
            return InkWell(
              onTap: canAdd ? _showAddFAQDialog : null,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveDimensions.responsiveWidth(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: ResponsiveDimensions.responsiveWidth(24),
                      height: ResponsiveDimensions.responsiveWidth(24),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: canAdd
                              ? AppColors.primary400
                              : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.add,
                        color: canAdd ? AppColors.primary400 : Colors.grey[300],
                        size: ResponsiveDimensions.responsiveFontSize(16),
                      ),
                    ),
                    SizedBox(width: ResponsiveDimensions.responsiveWidth(12)),
                    Text(
                      'أضف  سؤال',
                      style: getMedium(
                        color: canAdd
                            ? AppColors.primary400
                            : Color(0xFFE0E0E0),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          Obx(() {
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.faqs.length,
              separatorBuilder: (context, index) => Divider(
                height: ResponsiveDimensions.responsiveHeight(24),
                color: Colors.grey[300],
              ),
              itemBuilder: (context, index) {
                final faq = controller.faqs[index];
                return _buildFAQItem(faq, index);
              },
            );
          }),

          SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),
        ],
      ),
    );
  }

  Widget _buildFAQItem(FAQ faq, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _showEditFAQDialog(faq),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: GestureDetector(
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primary500.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        SizedBox(height: 15),
                        Icon(
                          Icons.edit,
                          size: ResponsiveDimensions.responsiveFontSize(32),
                          color: AppColors.primary500,
                        ),
                        Text(
                          'تعديل السؤال',
                          style: getMedium(
                            fontSize: 14,
                            color: AppColors.primary500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => _showEditFAQDialog(faq),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.error300.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        SizedBox(height: 15),
                        Icon(
                          Icons.delete_outline,
                          size: ResponsiveDimensions.responsiveFontSize(32),
                          color: AppColors.error300,
                        ),
                        Text(
                          'حذف السؤال',
                          style: getMedium(
                            fontSize: 14,
                            color: AppColors.error300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => _showDeleteFAQDialog(faq.id),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.responsiveWidth(16),
        vertical: ResponsiveDimensions.responsiveHeight(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  controller.goToPreviousStep();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveDimensions.responsiveHeight(16),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.grey[700],
                        size: ResponsiveDimensions.responsiveFontSize(20),
                      ),
                      SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
                      Text(
                        'السابق',
                        style: getMedium(
                          fontSize: ResponsiveDimensions.responsiveFontSize(16),
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: ResponsiveDimensions.responsiveWidth(16)),

          Expanded(
            child: Obx(() {
              bool shouldValidate = controller.hasUserTypedInDescription.value;
              bool isValid = shouldValidate
                  ? controller.validateDescriptionForm()
                  : true;

              print('🔍 حالة الوصف في زر التالي:');
              print(
                '- hasUserTypedInDescription: ${controller.hasUserTypedInDescription.value}',
              );
              print('- isEditorEmpty: ${controller.isEditorEmpty.value}');
              print(
                '- Plain text length: ${controller.serviceDescriptionPlainText.value.length}',
              );

              return Material(
                color: isValid ? AppColors.primary500 : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: isValid
                      ? () {
                          print('✅ التحقق النهائي قبل الانتقال:');

                          final plainText = controller.quillController.document
                              .toPlainText();
                          final richText = controller.getQuillContentAsJson();

                          controller.serviceDescriptionPlainText.value =
                              plainText;
                          controller.serviceDescriptionRichText.value =
                              richText;

                          print('📝 النص العادي: $plainText');
                          print('📝 طول النص العادي: ${plainText.length}');

                          if (controller.validateDescriptionForm()) {
                            print('✅ الوصف صالح، الانتقال إلى الخطوة التالية');
                            Get.to(() => const ImagesScreen());
                          } else {
                            print('❌ الوصف غير صالح');
                            Get.snackbar(
                              'خطأ',
                              'الرجاء إضافة وصف مفصل للخدمة',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        }
                      : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveDimensions.responsiveHeight(16),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'التالي',
                          style: getRegular(color: AppColors.light1000),
                        ),
                        SizedBox(
                          width: ResponsiveDimensions.responsiveWidth(8),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: isValid ? Colors.white : Colors.grey[600],
                          size: ResponsiveDimensions.responsiveFontSize(20),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _toggleFormat(String format) {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
      switch (format) {
        case 'bold':
          controller.quillController.formatSelection(Attribute.bold);
          break;
        case 'italic':
          controller.quillController.formatSelection(Attribute.italic);
          break;
        case 'underline':
          controller.quillController.formatSelection(Attribute.underline);
          break;
        case 'strikethrough':
          controller.quillController.formatSelection(Attribute.strikeThrough);
          break;
        case 'bullet':
          controller.quillController.formatSelection(Attribute.ul);
          break;
        case 'ordered':
          controller.quillController.formatSelection(Attribute.ol);
          break;
      }
    }
  }

  void _toggleHeading(int level) {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
      controller.quillController.formatSelection(HeaderAttribute(level: level));
    }
  }

  void _setTextColor(Color color) {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
      final hexColor = '#${color.value.toRadixString(16).substring(2)}';
      controller.quillController.formatSelection(ColorAttribute(hexColor));
    }
  }

  void _setHighlightColor(Color color) {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
      final hexColor = '#${color.value.toRadixString(16).substring(2)}';
      controller.quillController.formatSelection(BackgroundAttribute(hexColor));
    }
  }

  void _setFontSize(double size) {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
      controller.quillController.formatSelection(
        SizeAttribute(size.toString()),
      );
    }
  }

  void _setAlignment(String alignment) {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
      Attribute? alignAttr;

      switch (alignment) {
        case 'right':
          alignAttr = Attribute.rightAlignment;
          break;
        case 'center':
          alignAttr = Attribute.centerAlignment;
          break;
        case 'left':
          alignAttr = Attribute.leftAlignment;
          break;
      }

      if (alignAttr != null) {
        controller.quillController.formatSelection(alignAttr);
      }
    }
  }

  void _insertCodeBlock() {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
      controller.quillController.formatSelection(Attribute.codeBlock);
    }
  }

  void _showColorPickerDialog({bool isTextColor = true}) {
    final List<Color> colors = [
      Colors.black,
      Colors.white,
      Colors.red[300]!,
      Colors.red[500]!,
      Colors.green[300]!,
      Colors.green[500]!,
      Colors.blue[300]!,
      Colors.blue[500]!,
      Colors.yellow[300]!,
      Colors.yellow[500]!,
      Colors.orange[300]!,
      Colors.orange[500]!,
      Colors.purple[300]!,
      Colors.purple[500]!,
      Colors.teal[300]!,
      Colors.teal[500]!,
      Colors.pink[300]!,
      Colors.pink[500]!,
      Colors.brown[300]!,
      Colors.brown[500]!,
      Colors.grey[300]!,
      Colors.grey[500]!,
      AppColors.primary300,
      AppColors.primary500,
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isTextColor ? 'اختر لون النص' : 'اختر لون الخلفية',
                style: getBold(
                  fontSize: ResponsiveDimensions.responsiveFontSize(18),
                ),
              ),
              SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),
              Wrap(
                spacing: ResponsiveDimensions.responsiveWidth(8),
                runSpacing: ResponsiveDimensions.responsiveHeight(8),
                children: colors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      if (isTextColor) {
                        _setTextColor(color);
                      } else {
                        _setHighlightColor(color);
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: ResponsiveDimensions.responsiveWidth(40),
                      height: ResponsiveDimensions.responsiveHeight(40),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImageInsertDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'إدراج صورة',
                style: getBold(
                  fontSize: ResponsiveDimensions.responsiveFontSize(18),
                ),
              ),
              SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOptionButton(
                    icon: Icons.photo_library,
                    label: 'المعرض',
                    onTap: () async {
                      Navigator.pop(context);
                      await _pickImageFromGallery();
                    },
                  ),
                  _buildImageOptionButton(
                    icon: Icons.camera_alt,
                    label: 'الكاميرا',
                    onTap: () async {
                      Navigator.pop(context);
                      await _pickImageFromCamera();
                    },
                  ),
                  _buildImageOptionButton(
                    icon: Icons.link,
                    label: 'رابط',
                    onTap: () {
                      Navigator.pop(context);
                      _showImageLinkDialog();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Material(
          color: AppColors.primary50,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: ResponsiveDimensions.responsiveWidth(60),
              height: ResponsiveDimensions.responsiveHeight(60),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: ResponsiveDimensions.responsiveFontSize(24),
                color: AppColors.primary500,
              ),
            ),
          ),
        ),
        SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
        Text(
          label,
          style: getRegular(
            fontSize: ResponsiveDimensions.responsiveFontSize(14),
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final XFile file = XFile(result.files.first.path!);
        final bytes = await file.readAsBytes();
        final base64Image = 'data:image/png;base64,${base64Encode(bytes)}';

        final index = controller.quillController.selection.start;
        controller.quillController.document.insert(index, {
          'insert': {'image': base64Image},
        });

        Get.snackbar(
          'نجاح',
          'تم إدراج الصورة من المعرض',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في اختيار الصورة: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        final XFile file = XFile(pickedFile.path);
        final bytes = await file.readAsBytes();
        final base64Image = 'data:image/png;base64,${base64Encode(bytes)}';

        final index = controller.quillController.selection.start;
        controller.quillController.document.insert(index, {
          'insert': {'image': base64Image},
        });

        Get.snackbar(
          'نجاح',
          'تم إدراج الصورة من الكاميرا',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في التقاط الصورة: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showImageLinkDialog() {
    TextEditingController linkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إدراج صورة من رابط'),
          content: TextField(
            controller: linkController,
            decoration: const InputDecoration(
              labelText: 'رابط الصورة',
              border: OutlineInputBorder(),
              hintText: 'https://example.com/image.jpg',
            ),
            keyboardType: TextInputType.url,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                final link = linkController.text.trim();
                if (link.isNotEmpty) {
                  final fullLink = link.startsWith('http')
                      ? link
                      : 'https://$link';
                  final index = controller.quillController.selection.start;
                  controller.quillController.document.insert(index, {
                    'insert': {'image': fullLink},
                  });

                  Get.snackbar(
                    'نجاح',
                    'تم إدراج الصورة من الرابط',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('إدراج'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        Get.snackbar(
          'نجاح',
          'تم إرفاق الملف: ${file.name}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        final index = controller.quillController.selection.start;
        controller.quillController.document.insert(index, {
          'insert': '📎 ${file.name}\n',
        });
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في إرفاق الملف: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showAddFAQDialog() {
    Get.bottomSheet(const FAQBottomSheet(), isScrollControlled: true);
  }

  void _showEditFAQDialog(FAQ faq) {
    TextEditingController questionController = TextEditingController(
      text: faq.question,
    );
    TextEditingController answerController = TextEditingController(
      text: faq.answer,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تعديل السؤال الشائع'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(
                  labelText: 'السؤال',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(
                  labelText: 'الجواب',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            AateneButton(
              onTap: () => Navigator.pop(context),
              buttonText: "الغاء",
              color: AppColors.light1000,
              textColor: AppColors.light1000,
              borderColor: AppColors.primary400,
            ),

            AateneButton(
              onTap: () {
                final newQuestion = questionController.text.trim();
                final newAnswer = answerController.text.trim();

                if (newQuestion.isNotEmpty && newAnswer.isNotEmpty) {
                  controller.updateFAQ(faq.id??0, newQuestion, newAnswer);
                  Navigator.pop(context);

                  Get.snackbar(
                    'نجاح',
                    'تم تحديث السؤال بنجاح',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
              },
              buttonText: "حفظ",
              color: AppColors.primary400,
              textColor: AppColors.light1000,
              borderColor: AppColors.primary400,
            ),
          ],
        );
      },
    );
  }

  void _showDeleteFAQDialog(int id) {
    Get.defaultDialog(
      title: 'حذف السؤال',
      middleText: 'هل أنت متأكد من حذف هذا السؤال؟',
      // textConfirm: '',
      // textCancel: '',
      actions: [
        AateneButton(
          onTap: () {
            controller.removeFAQ(id);
            Get.back();

            Get.snackbar(
              'نجاح',
              'تم حذف السؤال بنجاح',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          },
          buttonText: "نعم، احذف",
          color: AppColors.primary400,
          textColor: AppColors.light1000,
          borderColor: AppColors.primary400,
        ),
        SizedBox(height: 10),
        AateneButton(
          onTap: () => Get.back(),
          buttonText: "لا",
          color: AppColors.light1000,
          textColor: AppColors.primary400,
          borderColor: AppColors.primary400,
        ),
      ],

      // confirmTextColor: Colors.white,
      // onConfirm: () {
      //   controller.removeFAQ(id);
      //   Get.back();
      //
      //   Get.snackbar(
      //     'نجاح',
      //     'تم حذف السؤال بنجاح',
      //     backgroundColor: Colors.green,
      //     colorText: Colors.white,
      //   );
      // },
      // onCancel: () => Get.back(),
    );
  }
}
