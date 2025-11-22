// lib/view/advance_info/keyword_management_screen.dart
import 'package:attene_mobile/view/advance_info/keyword_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:attene_mobile/utlis/colors/app_color.dart';

class KeywordManagementScreen extends StatelessWidget {
  final KeywordController controller = Get.find<KeywordController>();

  KeywordManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return     SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 20),
          _buildStoreSelector(),
          SizedBox(height: 16),
          _buildSearchBox(),
          SizedBox(height: 20),
          _buildAvailableKeywords(),
          SizedBox(height: 20),
          _buildSelectedKeywordsSection(),
        ],
      ),
    );
         
         
    
    // SafeArea(
    //   child: Scaffold(
    //     backgroundColor: Colors.white,
    //     body: 
    //     bottomNavigationBar: _buildBottomActions(),
    //   ),
    // );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          SizedBox(width: 8),
          Text(
            'الكلمات المفتاحية',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إظهار المنتج في متجر',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'اختر الكلمات المفتاحية المناسبة لظهور أفضل في نتائج البحث',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStoreSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'إظهار المنتج في متجر',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Obx(() => Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(25),
          ),
          child: DropdownButtonFormField<String>(
            value: controller.selectedStore.value,
            decoration: InputDecoration(
              hintText: 'اختر المتجر',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            items: controller.stores.map((store) {
              return DropdownMenuItem(
                value: store,
                child: Text(store),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.setSelectedStore(value);
              }
            },
          ),
        )),
      ],
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          // حقل النص - يستخدم controller.searchController مباشرة
          Expanded(
            child: TextField(
              controller: controller.searchController, // ✅ استخدام الـ Controller من الـ GetX Controller
              onSubmitted: (value) => controller.addCustomKeyword(),
              decoration: InputDecoration(
                hintText: 'اكتب الوسم ثم اضغط على إضافة...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ),
          
          // زر الإضافة
          Obx(() => _buildAddButton()),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    final hasText = !controller.isSearchInputEmpty;
    final canAddMore = controller.canAddMoreKeywords;
    final isDuplicate = controller.isDuplicateKeyword;
    
    String tooltipMessage = '';
    Color buttonColor = Colors.grey[300]!;
    
    if (!hasText) {
      tooltipMessage = 'اكتب وسماً أولاً';
    } else if (isDuplicate) {
      tooltipMessage = 'هذا الوسم مضاف مسبقاً';
      buttonColor = Colors.orange[300]!;
    } else if (!canAddMore) {
      tooltipMessage = 'تم الوصول للحد الأقصى (15 وسماً)';
      buttonColor = Colors.red[300]!;
    } else {
      tooltipMessage = 'إضافة الوسم';
      buttonColor = AppColors.primary400;
    }
    
    return Tooltip(
      message: tooltipMessage,
      child: Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        child: InkWell(
          onTap: hasText && canAddMore && !isDuplicate 
              ? () => controller.addCustomKeyword()
              : null,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableKeywords() {
    return Obx(() {
      final keywords = controller.filteredAvailableKeywords;
      
      if (keywords.isEmpty) {
        return _buildEmptyAvailableKeywords();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الكلمات المفتاحية المتاحة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: keywords.map((keyword) {
              return InkWell(
                onTap: () => controller.addKeyword(keyword),
                child: Container(
                  child: Text(keyword.text,
                  style: TextStyle(
                    color: AppColors.primary400,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color:AppColors.primary400,),
                    borderRadius: BorderRadius.circular(25)
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  Widget _buildEmptyAvailableKeywords() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 40,
            color: Colors.grey[400],
          ),
          SizedBox(height: 8),
          Text(
            'لا توجد كلمات مفتاحية متاحة',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Text(
            'جرب البحث بكلمات مختلفة أو اختر متجراً آخر',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedKeywordsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'الوسوم المختارة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            Obx(() => Text(
              '${controller.selectedKeywords.length}/15',
              style: TextStyle(
                fontSize: 14,
                color: controller.selectedKeywords.length >= 15 
                    ? Colors.red 
                    : Colors.grey[600],
              ),
            )),
          ],
        ),
        SizedBox(height: 8),
        Obx(() => _buildSelectedKeywordsContent()),
      ],
    );
  }

  Widget _buildSelectedKeywordsContent() {
    if (controller.selectedKeywords.isEmpty) {
      return _buildEmptySelectedKeywords();
    }
    return _buildSelectedKeywordsList();
  }

  Widget _buildEmptySelectedKeywords() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.tag,
              size: 40,
              color: Colors.grey[300],
            ),
            SizedBox(height: 8),
            Text(
              'لا توجد وسوم مختارة',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: 4),
            Text(
              'اختر من الكلمات المفتاحية المتاحة',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedKeywordsList() {
    return Container(
      constraints: BoxConstraints(
        minHeight: 60,
        maxHeight: 200,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.selectedKeywords.map((keyword) {
            return Chip(
              label: Text(keyword.text),
              backgroundColor: AppColors.primary100,
              deleteIconColor: AppColors.primary400,
              
              onDeleted: () => controller.removeKeyword(keyword.id),
              labelStyle: TextStyle(
                color: AppColors.primary500,
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                color: AppColors.primary300,
                width: 1.0,
              ),
            ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: Colors.grey[400]!),
              ),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Obx(() => ElevatedButton(
              onPressed: controller.selectedKeywords.isNotEmpty
                  ? () => controller.confirmSelection()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary400,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'تأكيد الوسوم',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

}