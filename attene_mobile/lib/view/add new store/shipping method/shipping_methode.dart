import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/controller/create_store_controller.dart';
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';

import 'add_new_company_shipping.dart';

class AddShippingMethod extends StatelessWidget {
  AddShippingMethod({super.key});

  final CreateStoreController controller = Get.find<CreateStoreController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "طريقة الشحن",
          style: TextStyle(
            color: AppColors.neutral100,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[300],
            ),
            child: Icon(Icons.arrow_back, color: AppColors.primary500),
          ),
        ),
      ),
      body: Column(
        children: [
          // الجزء العلوي: اختيار طريقة الشحن
          _buildShippingMethodSection(),
          
          // خط فاصل
          Container(
            height: 1,
            color: Colors.grey[300],
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
          
          // الجزء السفلي: شركات الشحن (يظهر فقط عند اختيار "من خلال شركة التوصيل")
          _buildShippingCompaniesSection(),
          if (true) 
           Padding(
    padding: const EdgeInsets.all(20.0),
    child: ElevatedButton(
      onPressed: () {
        print('=== 🔍 التحقق من شركات الشحن ===');
        print('عدد الشركات: ${controller.shippingCompanies.length}');
        for (int i = 0; i < controller.shippingCompanies.length; i++) {
          print('--- الشركة ${i + 1} ---');
          print('الاسم: ${controller.shippingCompanies[i]['name']}');
          print('الهاتف: ${controller.shippingCompanies[i]['phone']}');
          if (controller.shippingCompanies[i]['prices'] != null) {
            print('الأسعار: ${jsonEncode(controller.shippingCompanies[i]['prices'])}');
          }
        }
        print('نوع التوصيل: ${controller.deliveryType.value}');
        print('===============================');
      },
      child: Text('تحقق من البيانات'),
    ),
  ),
    
          _buildSaveButton(),
          SizedBox(height: 20),
        
        ],
      ),
    );
    
  }

  // بناء قسم اختيار طريقة الشحن
  Widget _buildShippingMethodSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Text(
            "كيف توجد شحن المنتجات؟",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          SizedBox(height: 15),
          
          // خيارات طريقة الشحن
          Obx(() => Column(
            children: [
              // خيار: مجاني
              _buildShippingOption(
                value: 'free',
                title: 'مجاني',
                subtitle: 'توصيل مجاني للمنتجات',
                icon: Icons.local_shipping,
              ),
              
              SizedBox(height: 12),
              
              // خيار: من خلال شركة التوصيل
              _buildShippingOption(
                value: 'shipping',
                title: 'من خلال شركة التوصيل',
                subtitle: 'استخدام شركات الشحن المتاحة',
                icon: Icons.business,
              ),
              
              SizedBox(height: 12),
              
              // خيار: من يد ليد
              _buildShippingOption(
                value: 'hand',
                title: 'من يد ليد',
                subtitle: 'دون شركة توصيل',
                icon: Icons.handshake,
              ),
            ],
          )),
        ],
      ),
    );
  }

  // بناء خيار طريقة الشحن
  Widget _buildShippingOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        controller.setDeliveryType(value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // أيقونة
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: controller.deliveryType.value == value
                      ? AppColors.primary400
                      : Colors.grey[400]!,
                  width: 2,
                ),
                color: controller.deliveryType.value == value
                    ? AppColors.primary400
                    : Colors.white,
              ),
              child: controller.deliveryType.value == value
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(width: 12),
            
            // النص
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            
            // زر الاختيار
         
          ],
        ),
      ),
    );
  }

  // بناء قسم شركات الشحن
  Widget _buildShippingCompaniesSection() {
    return Obx(() {
      // إظهار هذا القسم فقط إذا تم اختيار "من خلال شركة التوصيل"
      if (controller.deliveryType.value != 'shipping') {
        return SizedBox();
      }
      
      return Expanded(
        child: Column(
          children: [
            // رأس قسم شركات الشحن
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "شركات الشحن",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  // زر إضافة شركة شحن
                  GestureDetector(
                    onTap: () {
                      Get.to(() => AddNewShippingCompany());
                    },
                    child: Row(
                      children: [
                        Icon(Icons.add,                          color: AppColors.primary400
, size: 18),
                        SizedBox(width: 6),
                        Text(
                          "إضافة شركة شحن",
                          style: TextStyle(
                            color: AppColors.primary400,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // قائمة شركات الشحن
            Expanded(
              child: controller.shippingCompanies.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_shipping,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 16),
                            Text(
                              "لا توجد شركات شحن مضافة",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "انقر على 'إضافة شركة شحن' لإضافة شركة",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(20),
                      itemCount: controller.shippingCompanies.length,
                      itemBuilder: (context, index) {
                        final company = controller.shippingCompanies[index];
                        return _buildShippingCompanyCard(company, index);
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }

  // بناء بطاقة شركة الشحن
  Widget _buildShippingCompanyCard(Map<String, dynamic> company, int index) {
    final isPrimary = company['is_primary'] == true || index == 0;
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPrimary ? AppColors.primary400 : Colors.grey[200]!,
          width: isPrimary ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // مؤشر الأساسي/الثانوي
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPrimary ? AppColors.primary400 : Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isPrimary ? 'أساسي' : 'ثانوي',
              style: TextStyle(
                color: isPrimary ? Colors.white : Colors.grey[700],
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          SizedBox(width: 12),
          
          // معلومات الشركة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم الشركة
                Text(
                  company['name']?.toString() ?? 'شركة شحن',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral900,
                  ),
                ),
                
                SizedBox(height: 4),
                
                // المدن المغطاة
                if (company['prices'] != null && company['prices'] is List)
                  Text(
                    'المدن المغطاة: ${(company['prices'] as List).length} مدينة',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                
                // تاريخ الإضافة (إذا كان موجوداً)
                if (company['created_at'] != null)
                  Text(
                    'مضافة بتاريخ: ${company['created_at']}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
              ],
            ),
          ),
          
          // أزرار الإجراءات
          Row(
            children: [
              // زر التعديل
              GestureDetector(
                onTap: () {
                  _editShippingCompany(company, index);
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.blue,
                  ),
                ),
              ),
              
              SizedBox(width: 8),
              
              // زر الحذف
              GestureDetector(
                onTap: () {
                  _deleteShippingCompany(index);
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.delete,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // دالة تعديل شركة الشحن
  void _editShippingCompany(Map<String, dynamic> company, int index) {
    Get.to(
      () => AddNewShippingCompany(
        // companyToEdit: company,
        // companyIndex: index,
      ),
    );
  }

  // دالة حذف شركة الشحن
  void _deleteShippingCompany(int index) {
    Get.defaultDialog(
      title: 'تأكيد الحذف',
      middleText: 'هل أنت متأكد من حذف شركة الشحن هذه؟',
      textConfirm: 'نعم، احذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      cancelTextColor: AppColors.primary400,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.removeShippingCompany(index);
        Get.back();
        Get.snackbar(
          'تم الحذف',
          'تم حذف شركة الشحن بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  // بناء زر الحفظ
  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AateneButton(
        buttonText: 'التالي',
        textColor: Colors.white,
        color: AppColors.primary400,
        borderColor: AppColors.primary400,
        raduis: 10,
        onTap: () {
          _validateAndProceed();
        },
      ),
    );
  }

  // التحقق من البيانات والمتابعة
void _validateAndProceed() {
  // التحقق من اختيار طريقة الشحن
  if (controller.deliveryType.value.isEmpty) {
    Get.snackbar(
      'خطأ',
      'يرجى اختيار طريقة الشحن',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }
  
  // إذا كانت طريقة الشحن هي "من خلال شركة التوصيل"، يجب أن تكون هناك شركات شحن مضافة
  if (controller.deliveryType.value == 'shipping' && 
      controller.shippingCompanies.isEmpty) {
    Get.snackbar(
      'خطأ',
      'يرجى إضافة شركة شحن واحدة على الأقل',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }
  
  // 🔥 **حفظ المتجر النهائي**
  Get.defaultDialog(
    title: 'حفظ المتجر',
    middleText: controller.isEditMode.value 
        ? 'هل تريد تحديث المتجر بالبيانات الجديدة؟'
        : 'هل تريد إنشاء المتجر الآن؟',
    textConfirm: 'نعم',
    textCancel: 'لا',
    confirmTextColor: Colors.white,
    cancelTextColor: AppColors.primary400,
    buttonColor: AppColors.primary400,
    onConfirm: () async {
      Get.back();
      
      // رفع الصور المحلية إن وجدت
      bool hasLocalImages = controller.selectedLogoMedia.any((m) => m.isLocal == true) ||
                          controller.selectedCoverMedia.any((m) => m.isLocal == true);
      
      if (hasLocalImages) {
        Get.snackbar(
          'جاري الرفع',
          'جاري رفع الصور المحلية...',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
        
        controller.createStoreLoading.value = true;
        final uploadSuccess = await controller.uploadLocalImages();
        controller.createStoreLoading.value = false;
        
        if (!uploadSuccess) {
          Get.snackbar(
            'تنبيه',
            'فشل في رفع بعض الصور',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }
      }
      
      // حفظ المتجر النهائي
      final success = await controller.saveCompleteStore();
      if (success) {
        // العودة إلى القائمة الرئيسية
        Get.until((route) => route.isFirst);
      }
    },
    onCancel: () {
      Get.back();
    },
  );
}
}