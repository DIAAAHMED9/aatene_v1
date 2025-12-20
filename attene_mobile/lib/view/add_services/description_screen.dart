// description_screen.dart - إضافة ربط مع API
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/view/add_services/responsive_dimensions.dart';
import 'package:attene_mobile/view/add_services/faq_bottom_sheet.dart';
import 'package:attene_mobile/view/add_services/images_screen.dart';
import 'package:attene_mobile/view/add_services/service_controller.dart';
import 'models/models.dart';

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
    controller.quillController.addListener(_updateToolbarState);
  }

  void _updateToolbarState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.quillController.removeListener(_updateToolbarState);
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
            // معلومات عن قسم الوصف
            _buildDescriptionInfo(),
            
            // محرر النص الثري مع شريط الأدوات المحسّن
            _buildEnhancedEditor(),
            
            // عداد الأحرف
            // _buildCharacterCounter(),
            
            // قسم الأسئلة الشائعة
            _buildFAQsSection(),
            
            // أزرار التنقل
            // _buildNavigationButtons(),
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
      child: Text(
        'وصف مفصل للخدمة',
        style: TextStyle(
          fontSize: ResponsiveDimensions.responsiveFontSize(20),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEnhancedEditor() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.responsiveWidth(16),
        vertical: ResponsiveDimensions.responsiveHeight(8),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: controller.isDescriptionError.value
              ? Colors.red
              : Colors.grey[300]!,
          width: controller.isDescriptionError.value ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(25),
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
          // شريط الأدوات المتكامل
          _buildEnhancedToolbar(),
          // محرر Quill
          Container(
            height: ResponsiveDimensions.responsiveHeight(200),
            padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(12)),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: QuillEditor(
              controller: controller.quillController,
              focusNode: controller.editorFocusNode,
              scrollController: controller.editorScrollController,
              // scrollable: true,
              // autoFocus: false,
              // readOnly: false,
              // expands: false,
              // padding: EdgeInsets.zero,
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
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصف الأول: التنسيقات الأساسية
          _buildBasicFormattingRow(),
                    Divider(color: Colors.grey.shade300,),

          // SizedBox(height: ResponsiveDimensions.responsiveHeight(4)),
          
          // الصف الثاني: التنسيقات المتقدمة (الألوان والمحاذاة)
          _buildAdvancedFormattingRow(),
                    Divider(color: Colors.grey.shade300,),

          // SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
          
          // الصف الثالث: العناوين والكتل الخاصة
          _buildHeadingsAndSpecialRow(),
                    Divider(color: Colors.grey.shade300,),

          // SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
          
          // الصف الرابع: أدوات الإدراج
          // _buildInsertToolsRow(),
        ],
      ),
    );
  }

  Widget _buildBasicFormattingRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // التراجع والإعادة
          // _buildToolbarButton(
          //   icon: Icons.undo,
          //   tooltip: 'تراجع',
          //   isActive: false,
          //   onPressed: controller.canUndo ? () {
          //     controller.undo();
          //     _updateToolbarState();
          //   } : null,
          // ),
          
          // _buildToolbarButton(
          //   icon: Icons.redo,
          //   tooltip: 'إعادة',
          //   isActive: false,
          //   onPressed: controller.canRedo ? () {
          //     controller.redo();
          //     _updateToolbarState();
          //   } : null,
          // ),
          
          // SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
           _buildToolbarButton(
            icon: Icons.strikethrough_s,
            tooltip: 'يتوسطه خط',
            isActive: false,
            onPressed: () => _toggleFormat('strikethrough'),
          ),
            _buildToolbarButton(
            icon: Icons.format_underlined,
            tooltip: 'تحته خط',
            isActive: false,
            onPressed: () => _toggleFormat('underline'),
          ),
           _buildToolbarButton(
            icon: Icons.format_italic,
            tooltip: 'مائل',
            isActive: false,
            onPressed: () => _toggleFormat('italic'),
          ),
          // التنسيقات الأساسية
          _buildToolbarButton(
            icon: Icons.format_bold,
            tooltip: 'عريض',
            isActive: false,
            onPressed: () => _toggleFormat('bold'),
          ),
          
         _buildToolbarButton(
            icon: Icons.format_color_fill,
            tooltip: 'لون الخلفية',
            isActive: false,
            onPressed: () => _showColorPickerDialog(isTextColor: false),
          ),
          _buildToolbarButton(
            icon: Icons.format_color_text,
            tooltip: 'لون النص',
            isActive: false,
            onPressed: () => _showColorPickerDialog(isTextColor: true),
          ),  
          _buildFontSizeDropdown(),
        
         
          
          // SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
          
          // _buildToolbarButton(
          //   icon: Icons.format_clear,
          //   tooltip: 'مسح التنسيق',
          //   isActive: false,
          //   onPressed: _clearAllFormatting,
          // ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFormattingRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        
          
          // المحاذاة
          _buildAlignmentButtons(),
          _buildHeadingButton(5, 'H5'),
          _buildHeadingButton(4, 'H4'),
          _buildHeadingButton(3, 'H3'),
          _buildHeadingButton(2, 'H2'),
          _buildHeadingButton(1, 'H1'),
        ],
      ),
    );
  }

  Widget _buildHeadingsAndSpecialRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
   
          
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
          SizedBox(
            height: 30,
            child: VerticalDivider(color: Colors.grey.shade300,)),
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
          
          // خط أفقي
          // _buildToolbarButton(
          //   icon: Icons.horizontal_rule,
          //   tooltip: 'خط أفقي',
          //   isActive: false,
          //   onPressed: _insertHorizontalRule,
          // ),
          
          // كود بلوك
         
          
          // // كتلة اقتباس
          // _buildToolbarButton(
          //   icon: Icons.format_quote,
          //   tooltip: 'اقتباس',
          //   isActive: false,
          //   onPressed: _insertBlockQuote,
          // ),
          
          // إزالة المسافة
          // _buildToolbarButton(
          //   icon: Icons.space_bar,
          //   tooltip: 'مسافة بادئة',
          //   isActive: false,
          //   onPressed: _toggleIndent,
          // ),
        ],
      ),
    );
  }

  // Widget _buildInsertToolsRow() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         _buildToolbarButton(
  //           icon: Icons.format_list_bulleted,
  //           tooltip: 'قائمة نقطية',
  //           isActive: false,
  //           onPressed: () => _toggleFormat('bullet'),
  //         ),
          
  //         _buildToolbarButton(
  //           icon: Icons.format_list_numbered,
  //           tooltip: 'قائمة رقمية',
  //           isActive: false,
  //           onPressed: () => _toggleFormat('ordered'),
  //         ),
          
  //         SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
          
  //         _buildToolbarButton(
  //           icon: Icons.link,
  //           tooltip: 'إدراج رابط',
  //           isActive: false,
  //           onPressed: _showLinkDialog,
  //         ),
          
        
          
         
  //         _buildToolbarButton(
  //           icon: Icons.table_chart,
  //           tooltip: 'إدراج جدول',
  //           isActive: false,
  //           onPressed: _showTableDialog,
  //         ),
          
  //         _buildToolbarButton(
  //           icon: Icons.emoji_emotions,
  //           tooltip: 'إدراج إيموجي',
  //           isActive: false,
  //           onPressed: _showEmojiPicker,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildHeadingButton(int level, String label) {
    return Tooltip(
      message: 'عنوان $level',
      child: Material(
        borderRadius: BorderRadius.circular(6),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () => _toggleHeading(level),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveDimensions.responsiveFontSize(14),
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
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
double fontSelected=10.0;
    return PopupMenuButton<double>(
      tooltip: 'حجم الخط',
      onSelected: (value)  {
        setState(() {
        fontSelected==value;
          
        });
        _setFontSize(value);
        },
      itemBuilder: (context) {
        return fontSizes.map((size) {
          return PopupMenuItem<double>(
            value: size['value'],
            child:
             Text(
              size['label'],
              style: TextStyle(fontSize: size['value']),
            ),
          );
        }).toList();
      },
      child:  Row(
          children: [
            Icon(
              Icons.unfold_more_sharp,
              size: ResponsiveDimensions.responsiveFontSize(18),
              color: Colors.grey[700],
            ),
            SizedBox(width: ResponsiveDimensions.responsiveWidth(6)),
            Text(
              fontSelected.toString(),
              style: TextStyle(
                fontSize: ResponsiveDimensions.responsiveFontSize(14),
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      
    );
  }

  Widget _buildAlignmentButtons() {
    return Row(
      children: [
        _buildAlignmentButton(Icons.format_align_left, 'يسار', 'left'),
        _buildAlignmentButton(Icons.format_align_center, 'وسط', 'center'),
        _buildAlignmentButton(Icons.format_align_right, 'يمين', 'right'),
        // _buildAlignmentButton(Icons.format_align_justify, 'ضبط', 'justify'),
      ],
    );
  }

  Widget _buildAlignmentButton(IconData icon, String tooltip, String alignment) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.responsiveWidth(2)),
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
      margin: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.responsiveWidth(2)),
      child: Tooltip(
        message: tooltip,
        child: Material(
          borderRadius: BorderRadius.circular(6),
          color: isActive ? AppColors.primary400 : Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
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

  Widget _buildCharacterCounter() {
    return Obx(() {
      final text = controller.serviceDescriptionPlainText.value;
      final wordCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
      final charCount = text.length;
      final maxChars = 5000;
      
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveDimensions.responsiveWidth(16),
          vertical: ResponsiveDimensions.responsiveHeight(8),
        ),
        padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(12)),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'عدد الكلمات: $wordCount',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.responsiveFontSize(14),
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '$charCount / $maxChars',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.responsiveFontSize(14),
                    color: charCount > maxChars ? Colors.red : Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
            LinearProgressIndicator(
              value: charCount / maxChars,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                charCount > maxChars 
                    ? Colors.red 
                    : charCount > maxChars * 0.7 
                        ? Colors.orange 
                        : Colors.green,
              ),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            if (charCount > maxChars * 0.7)
              Padding(
                padding: EdgeInsets.only(top: ResponsiveDimensions.responsiveHeight(8)),
                child: Text(
                  charCount > maxChars
                      ? '⚠️ تجاوزت الحد الأقصى لعدد الأحرف'
                      : '⚠️ اقتربت من الحد الأقصى لعدد الأحرف',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.responsiveFontSize(12),
                    color: charCount > maxChars ? Colors.red : Colors.orange,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildFAQsSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveDimensions.responsiveHeight(7),),
            Text(
                'الأسئلة الشائعة (اختياري)',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.responsiveFontSize(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(4),),
      
        Text(
                'اكتب إجابات للأسئلة الشائعة التي يطرحها عميلك. أضف حتى خمسة أسئلة.',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.responsiveFontSize(10),
                  fontWeight: FontWeight.w300,
                  color: Colors.grey.shade500
                ),
              ),
      
          SizedBox(height: ResponsiveDimensions.responsiveHeight(12)),
            Obx(()
            {
                        final canAdd = controller.faqs.length < ServiceController.maxFAQs;
      
              return  InkWell(
              onTap:canAdd ? _showAddFAQDialog : null,
              child: Container(
                padding: EdgeInsets.symmetric(vertical:  ResponsiveDimensions.responsiveWidth(6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: ResponsiveDimensions.responsiveWidth(24),
                      height: ResponsiveDimensions.responsiveWidth(24),
                      decoration: BoxDecoration(
                        // color: AppColors.primary400,
                        border: Border.all(color: canAdd ? AppColors.primary400 : Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8)
                        // shape: BoxShape.tr,
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
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.responsiveFontSize(16),
                        fontWeight: FontWeight.w600,
                        color: canAdd ? AppColors.primary400 : Colors.grey[300]
                      ),
                    ),
                  ],
                ),
              ),
                      );}
            ),
        
         Obx(()=>   ListView.separated(
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
            )),
          
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
            children: [
           
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  Text(
                    '${index + 1}. ${faq.question}',
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.responsiveFontSize(15),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: ResponsiveDimensions.responsiveHeight(4)),
                  Text(
                    faq.answer,
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.responsiveFontSize(14),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Spacer(),
              IconButton(onPressed: (){
          Get.bottomSheet(
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25))
          
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
          onTap:()=> _showEditFAQDialog(faq),
          title: Text('تعديل السؤال'),
          leading: Icon(
                          Icons.edit,
                          size: ResponsiveDimensions.responsiveFontSize(18),
                          color: AppColors.primary500,
                        ),
                  ),
           ListTile(
          onTap:()=> _showDeleteFAQDialog(faq.id),
          title: Text('حذف السؤال'),
          leading: Icon(
                          Icons.delete_outline,
                          size: ResponsiveDimensions.responsiveFontSize(18),
                          color: Colors.red,
                        ),
                  )
          
                ],
              ),
            )
          );
          
              }, icon: Icon(Icons.more_horiz))
                       
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
          // زر الرجوع
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
                        style: TextStyle(
                          fontSize: ResponsiveDimensions.responsiveFontSize(16),
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(width: ResponsiveDimensions.responsiveWidth(16)),
          
          // زر التالي
          Expanded(
            child: Obx(() {
              final isValid = controller.serviceDescriptionPlainText.value.isNotEmpty;
              return Material(
                color: isValid ? AppColors.primary500 : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: isValid ? () {
                    Get.to(() => const ImagesScreen());
                  } : null,
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
                          style: TextStyle(
                            fontSize: ResponsiveDimensions.responsiveFontSize(16),
                            fontWeight: FontWeight.w600,
                            color: isValid ? Colors.white : Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
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

  // ============ دوال مساعدة للتنسيقات ============

  void _clearAllFormatting() {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
      controller.quillController.formatSelection(Attribute.placeholder);
    }
    _updateToolbarState();
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
    _updateToolbarState();
  }

  void _toggleHeading(int level) {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
controller.quillController.formatSelection(HeaderAttribute(level: level));
      _updateToolbarState();
    }
  }

  void _setTextColor(Color color) {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
      final hexColor = '#${color.value.toRadixString(16).substring(2)}';
controller.quillController.formatSelection(ColorAttribute(hexColor));
      _updateToolbarState();
    }
  }

  void _setHighlightColor(Color color) {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
      final hexColor = '#${color.value.toRadixString(16).substring(2)}';
controller.quillController.formatSelection(BackgroundAttribute(hexColor));
      _updateToolbarState();
    }
  }

  void _setFontSize(double size) {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
controller.quillController.formatSelection(SizeAttribute(size.toString()));
      _updateToolbarState();
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
  case 'justify':
    alignAttr = Attribute.justifyAlignment;
    break;
}

      
      if (alignAttr != null) {
        controller.quillController.formatSelection(alignAttr);
        _updateToolbarState();
      }
    }
  }

  void _insertCodeBlock() {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
      controller.quillController.formatSelection(Attribute.codeBlock);
      _updateToolbarState();
    }
  }

  void _insertBlockQuote() {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
      controller.quillController.formatSelection(Attribute.blockQuote);
      _updateToolbarState();
    }
  }

  void _insertHorizontalRule() {
    final index = controller.quillController.selection.start;
    controller.quillController.document.insert(index, {
      'insert': {'hr': ''}
    });
    _updateToolbarState();
  }

  void _toggleIndent() {
    final selection = controller.quillController.selection;
    if (selection.isValid) {
      controller.quillController.formatSelection(Attribute.indent);
      _updateToolbarState();
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
                style: TextStyle(
                  fontSize: ResponsiveDimensions.responsiveFontSize(18),
                  fontWeight: FontWeight.bold,
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
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
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
              SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: AppColors.primary400,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _showCustomColorPicker(isTextColor),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveDimensions.responsiveHeight(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ألوان مخصصة',
                        style: TextStyle(
                          fontSize: ResponsiveDimensions.responsiveFontSize(16),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomColorPicker(bool isTextColor) {
    // يمكن إضافة color picker package مثل: flutter_colorpicker
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isTextColor ? 'اختر لون النص' : 'اختر لون الخلفية'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text('ميزة الألوان المخصصة قيد التطوير'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }

  // ============ دوال مساعدة للإدراج ============

  void _showLinkDialog() {
    TextEditingController linkController = TextEditingController();
    TextEditingController textController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إدراج رابط'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'النص المعروض',
                  border: OutlineInputBorder(),
                  hintText: 'النص الذي يظهر',
                ),
              ),
              SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  labelText: 'الرابط',
                  border: OutlineInputBorder(),
                  hintText: 'https://example.com',
                  prefixText: 'https://',
                ),
                keyboardType: TextInputType.url,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                final text = textController.text.trim();
                final link = linkController.text.trim();
                
                if (text.isNotEmpty && link.isNotEmpty) {
                  final fullLink = link.startsWith('http') ? link : 'https://$link';
                  final index = controller.quillController.selection.start;
                  
                  controller.quillController.replaceText(
                    index,
                    0,
                    text,
                    TextSelection.collapsed(offset: index + text.length),
                  );
                  controller.quillController.formatSelection(LinkAttribute(fullLink));
                  _updateToolbarState();
                  
                  Get.snackbar(
                    'نجاح',
                    'تم إدراج الرابط بنجاح',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    'خطأ',
                    'يرجى ملء جميع الحقول',
                    backgroundColor: Colors.red,
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
                style: TextStyle(
                  fontSize: ResponsiveDimensions.responsiveFontSize(18),
                  fontWeight: FontWeight.bold,
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
          style: TextStyle(
            fontSize: ResponsiveDimensions.responsiveFontSize(14),
            color: Colors.grey[700],
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
        final file = File(result.files.first.path!);
        final bytes = await file.readAsBytes();
        final base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
        
        final index = controller.quillController.selection.start;
        controller.quillController.document.insert(index, {
          'insert': {'image': base64Image}
        });
        _updateToolbarState();
        
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
        final file = File(pickedFile.path);
        final bytes = await file.readAsBytes();
        final base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
        
        final index = controller.quillController.selection.start;
        controller.quillController.document.insert(index, {
          'insert': {'image': base64Image}
        });
        _updateToolbarState();
        
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
                  final fullLink = link.startsWith('http') ? link : 'https://$link';
                  final index = controller.quillController.selection.start;
                  controller.quillController.document.insert(index, {
                    'insert': {'image': fullLink}
                  });
                  _updateToolbarState();
                  
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
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
      );
      
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        // يمكن إضافة معالجة الملف هنا
        Get.snackbar(
          'نجاح',
          'تم إرفاق الملف: ${file.name} (${(file.size / 1024).toStringAsFixed(1)} KB)',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // إدراج رابط للملف في المحرر
        final index = controller.quillController.selection.start;
        controller.quillController.document.insert(index, {
          'insert': '📎 ${file.name}\n'
        });
        _updateToolbarState();
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

  void _showTableDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إدراج جدول'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('عدد الصفوف:'),
              Slider(
                value: 3,
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: (value) {},
              ),
              const Text('عدد الأعمدة:'),
              Slider(
                value: 3,
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: (value) {},
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                // إدراج جدول (هذا يحتاج إلى دعم من Quill)
                Get.snackbar(
                  'معلومة',
                  'ميزة إدراج الجداول قيد التطوير',
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                );
                Navigator.pop(context);
              },
              child: const Text('إدراج'),
            ),
          ],
        );
      },
    );
  }

  void _showEmojiPicker() {
    // يمكن إضافة emoji picker package
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 300,
          padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
          child: Column(
            children: [
              Text(
                'اختر إيموجي',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.responsiveFontSize(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 6,
                  children: [
                    '😀', '😃', '😄', '😁', '😆', '😅',
                    '😂', '🤣', '😊', '😇', '🙂', '🙃',
                    '😉', '😌', '😍', '🥰', '😘', '😗',
                    '😙', '😚', '😋', '😛', '😝', '😜',
                    '🤪', '🤨', '🧐', '🤓', '😎', '🤩',
                    '🥳', '😏', '😒', '😞', '😔', '😟',
                  ].map((emoji) {
                    return GestureDetector(
                      onTap: () {
                        final index = controller.quillController.selection.start;
                        controller.quillController.document.insert(index, {
                          'insert': emoji
                        });
                        _updateToolbarState();
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(4)),
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: ResponsiveDimensions.responsiveFontSize(24)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============ دوال الأسئلة الشائعة ============

  void _showAddFAQDialog() {
    Get.bottomSheet(
      const FAQBottomSheet(),
      isScrollControlled: true,
    );
  }

  void _showEditFAQDialog(FAQ faq) {
    TextEditingController questionController = TextEditingController(text: faq.question);
    TextEditingController answerController = TextEditingController(text: faq.answer);
    
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                final newQuestion = questionController.text.trim();
                final newAnswer = answerController.text.trim();
                
                if (newQuestion.isNotEmpty && newAnswer.isNotEmpty) {
                  controller.updateFAQ(faq.id, newQuestion, newAnswer);
                  Navigator.pop(context);
                  
                  Get.snackbar(
                    'نجاح',
                    'تم تحديث السؤال بنجاح',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text('حفظ'),
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
      textConfirm: 'نعم، احذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.removeFAQ(id);
        Get.back();
        
        Get.snackbar(
          'نجاح',
          'تم حذف السؤال بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
      onCancel: () => Get.back(),
    );
  }
}