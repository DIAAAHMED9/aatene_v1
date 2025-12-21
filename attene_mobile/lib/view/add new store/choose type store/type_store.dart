import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/appBar/custom_appbar.dart';
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/my_app/my_app_controller.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/view/add%20new%20store/add_new_store.dart';
import 'package:attene_mobile/view/Services/data_lnitializer_service.dart';
import 'package:attene_mobile/view/Services/unified_loading_screen.dart';
import 'package:get_storage/get_storage.dart';

import '../../../controller/create_store_controller.dart';

class TypeStore extends GetView<CreateStoreController> {
  const TypeStore({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateStoreController controller = Get.put(CreateStoreController());
    final isRTL = LanguageUtils.isRTL;
    final MyAppController myAppController = Get.find<MyAppController>();
    final DataInitializerService dataService =
        Get.find<DataInitializerService>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'نوع المتجر',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: CircleAvatar(
              backgroundColor: Color(0XFF1F29370D),
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
      ),
      body: Obx(() => _buildBody(controller, isRTL, myAppController)),
    );
  }

  Widget _buildBody(
    CreateStoreController controller,
    bool isRTL,
    MyAppController myAppController,
  ) {
    if (!myAppController.isLoggedIn.value) {
      return _buildLoginRequiredView();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildStoreTypeOptions(controller),
            const SizedBox(height: 40),
            _buildNextButton(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'قم باختيار نوع المتجر الذي تريده (تقديم خدمات / بيع منتجات)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildStoreTypeOptions(CreateStoreController controller) {
    return Column(
      children: [
        _buildStoreTypeCard(
          controller: controller,
          type: 'products',
          title: 'متجر بيع المنتجات',
          description:
              'بيع المنتجات المادية مثل الملابس، الإلكترونيات، الأثاث، وغيرها',
          icon: Icons.store,
          isSelected: controller.storeType.value == 'products',
        ),
        const SizedBox(height: 15),
        _buildStoreTypeCard(
          controller: controller,
          type: 'services',
          title: 'متجر تقديم الخدمات',
          description:
              'تقديم الخدمات مثل التصميم، البرمجة، الاستشارات، التعليم، وغيرها',
          icon: Icons.home_repair_service,
          isSelected: controller.storeType.value == 'services',
        ),
      ],
    );
  }

  Widget _buildStoreTypeCard({
    required CreateStoreController controller,
    required String type,
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => controller.setStoreType(type),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary400 : Color(0XFFAAAAAA),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary400 : Color(0XFF393939),
              size: 30,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: isSelected ? AppColors.primary400 : Color(0XFF393939),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(CreateStoreController controller) {
    return AateneButton(
      buttonText: 'التالي',
      textColor: Colors.white,
      color: AppColors.primary400,
      borderColor: AppColors.primary400,
      raduis: 10,
      onTap: () {
        if (controller.storeType.value.isEmpty) {
          Get.snackbar(
            'تنبيه',
            'يرجى اختيار نوع المتجر',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }
        Get.to(() => AddNewStore());
      },
    );
  }

  Widget _buildLoginRequiredView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login_rounded, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'يجب تسجيل الدخول',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'يرجى تسجيل الدخول للوصول إلى إضافة المتاجر',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AateneButton(
              buttonText: 'تسجيل الدخول',
              textColor: Colors.white,
              color: AppColors.primary400,
              borderColor: AppColors.primary400,
              raduis: 10,
              onTap: () {
                Get.toNamed('/login');
              },
            ),
            const SizedBox(height: 16),
            AateneButton(
              buttonText: 'إنشاء حساب جديد',
              textColor: AppColors.primary400,
              color: Colors.white,
              borderColor: AppColors.primary400,
              raduis: 10,
              onTap: () {
                Get.toNamed('/register');
              },
            ),
          ],
        ),
      ),
    );
  }
}
