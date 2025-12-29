import 'dart:io';
import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:attene_mobile/view/add%20new%20store/shipping%20method/add_new_company_shipping.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/Text/text_with_star.dart';
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/controller/create_store_controller.dart';
import 'package:attene_mobile/view/Services/data_lnitializer_service.dart';
import 'package:attene_mobile/view/Services/unified_loading_screen.dart';

import 'shipping method/shipping_methode.dart';

class AddNewStore extends StatelessWidget {
  AddNewStore({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateStoreController controller = Get.find<CreateStoreController>();
    final DataInitializerService dataService =
        Get.find<DataInitializerService>();
    final isRTL = LanguageUtils.isRTL;
    final arguments = Get.arguments;
    final int? storeId = arguments != null ? arguments['storeId'] : null;

    if (storeId != null && !controller.isEditMode.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadStoreForEdit(storeId);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "البيانات الاساسية",
          style: getBold(color: AppColors.neutral100, fontSize: 20),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[100],
            ),
            child: Icon(Icons.arrow_back, color: AppColors.neutral100),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWithStar(text: "اسم المتجر"),
              SizedBox(height: 5),
              TextFiledAatene(
                heightTextFiled: 50,
                isRTL: isRTL,
                hintText: "أدخل اسم المتجر",
                controller: controller.nameController,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 15),

              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.store, color: AppColors.primary400),
                      SizedBox(width: 8),
                      Text(
                        "نوع المتجر: ${controller.storeType.value == 'products' ? 'منتجات' : 'خدمات'}",
                        style: getRegular(
                          fontSize: 14,
                          color: AppColors.primary500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextWithStar(text: "شعار المتجر"),

              SizedBox(height: 5),
              Text(
                "اختر صورة أساسية للشعار (حد أقصى 5 صور)",
                style: getRegular(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 10),

              _buildLogoImagesList(controller),

              SizedBox(height: 20),

              TextWithStar(text: "صور الغلاف"),

              SizedBox(height: 5),
              Text(
                "اختر صورة واحدة على الأقل للغلاف (حد أقصى 10 صور)",
                style: getRegular(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 10),

              _buildCoverImagesList(controller),

              SizedBox(height: 20),

              TextWithStar(text: "وصف المتجر"),
              SizedBox(height: 5),
              TextFiledAatene(
                heightTextFiled: 50,
                isRTL: isRTL,
                hintText: "أدخل وصف المتجر",
                controller: controller.descriptionController,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 15),
              TextWithStar(text: "البريد الالكتروني"),
              SizedBox(height: 5),
              TextFiledAatene(
                heightTextFiled: 50,
                isRTL: isRTL,
                hintText: "example@email.com",
                controller: controller.emailController,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 15),

              TextWithStar(text: "المدينة"),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () => controller.openCitySelection(),
                child: AbsorbPointer(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            final cityName = controller.selectedCityName.value;
                            return Text(
                              cityName,
                              style: getRegular(
                                color: cityName != 'اختر المدينة'
                                    ? AppColors.neutral900
                                    : Colors.grey,
                              ),
                            );
                          }),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),

              TextWithStar(text: "الحي"),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () => controller.openDistrictSelection(),
                child: AbsorbPointer(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            final districtName =
                                controller.selectedDistrictName.value;
                            return Text(
                              districtName,
                              style: getRegular(
                                color: districtName != 'اختر الحي'
                                    ? AppColors.neutral900
                                    : Colors.grey,
                              ),
                            );
                          }),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),

              TextWithStar(text: "العملة"),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () => controller.openCurrencySelection(),
                child: AbsorbPointer(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            final currencyName =
                                controller.selectedCurrencyName.value;
                            return Text(
                              currencyName,
                              style: getRegular(
                                color: currencyName != 'اختر العملة'
                                    ? AppColors.neutral900
                                    : Colors.grey,
                              ),
                            );
                          }),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),

              TextWithStar(text: "الهاتف المحمول "),
              SizedBox(height: 5),
              TextFiledAatene(
                heightTextFiled: 50,
                isRTL: isRTL,
                hintText: "أدخل رقم الهاتف",
                controller: controller.phoneController,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 15),

              Obx(
                () => Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: controller.hidePhone.value,
                        onChanged: (bool? newValue) {
                          controller.hidePhone.value = newValue ?? false;
                        },
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith<Color>((
                          states,
                        ) {
                          if (states.contains(MaterialState.selected)) {
                            return AppColors.primary400;
                          }
                          return Colors.white;
                        }),
                        side: BorderSide(color: Colors.grey, width: 1.5),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "إخفاء رقم الهاتف على الملف الشخصي",
                          style: getRegular(
                            fontSize: 14,
                            color: AppColors.neutral700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "💡 تأكد من اختيار الصور من 'المكتبة' وليس 'رفع صورة جديدة' لتجنب مشاكل الرفع أثناء إنشاء المتجر",
                        style: getRegular(
                          color: Colors.blueAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              _buildCreateButton(controller),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoImagesList(CreateStoreController controller) {
    return Obx(() {
      final logoCount = controller.selectedLogoMedia.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'الصور المختارة: $logoCount/5',
              style: getRegular(
                fontSize: 12,
                color: logoCount >= 5 ? Colors.red : Colors.grey,
                fontWeight: logoCount >= 5
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),

          if (controller.selectedLogoMedia.isEmpty)
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: controller.openMediaLibraryForLogo,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اضف او اسحب صورة او فيديو',
                    style: getRegular(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'png , jpg , svg',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            )
          else
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 4),
                  ...controller.selectedLogoMedia.asMap().entries.map((entry) {
                    int index = entry.key;
                    var media = entry.value;

                    return Container(
                      width: 130,
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.isPrimaryLogo(media)
                              ? AppColors.primary400
                              : Colors.grey[200]!,
                          width: controller.isPrimaryLogo(media) ? 3 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image(
                              image: _getImageProvider(controller, media),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey[100],
                                    child: Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                            ),
                          ),

                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.6),
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'شعار ${index + 1}',
                                      style: getRegular(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if (controller.isPrimaryLogo(media))
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary400,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'أساسي',
                                  style: TextStyle(
                                    fontFamily: "PingAR",
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                          Positioned(
                            top: 8,
                            left: 8,
                            child: GestureDetector(
                              onTap: () => controller.removeLogo(index),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          if (!controller.isPrimaryLogo(media))
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: GestureDetector(
                                onTap: () => controller.setPrimaryLogo(index),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary400,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.star_border,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(width: 4),
                  Container(
                    height: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: controller.openMediaLibraryForLogo,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'اضف او اسحب صورة او فيديو',
                          style: getRegular(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'png , jpg , svg',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  Widget _buildCoverImagesList(CreateStoreController controller) {
    return Obx(() {
      final coverCount = controller.selectedCoverMedia.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'الصور المختارة: $coverCount/10',
              style: getRegular(
                fontSize: 12,
                color: coverCount >= 10 ? Colors.red : Colors.grey,
                fontWeight: coverCount >= 10
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),

          if (controller.selectedCoverMedia.isEmpty)
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: controller.openMediaLibraryForCover,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اضف او اسحب صورة او فيديو',
                    style: getRegular(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'png , jpg , svg',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: "PingAR",
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 4),
                  ...controller.selectedCoverMedia.asMap().entries.map((entry) {
                    int index = entry.key;
                    var media = entry.value;

                    return Container(
                      width: 130,
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.isPrimaryCover(media)
                              ? AppColors.secondary400
                              : Colors.grey[200]!,
                          width: controller.isPrimaryCover(media) ? 3 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image(
                              image: _getImageProvider(controller, media),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey[100],
                                    child: Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                            ),
                          ),

                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.6),
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'غلاف ${index + 1}',
                                      style: getRegular(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if (controller.isPrimaryCover(media))
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary400,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'أساسي',
                                  style: TextStyle(
                                    fontFamily: "PingAR",
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                          Positioned(
                            top: 8,
                            left: 8,
                            child: GestureDetector(
                              onTap: () => controller.removeCover(index),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          if (!controller.isPrimaryCover(media))
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: GestureDetector(
                                onTap: () => controller.setPrimaryCover(index),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary400,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.star_border,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(width: 4),
                  Container(
                    height: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: controller.openMediaLibraryForCover,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'اضف او اسحب صورة او فيديو',
                          style: getRegular(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'png , jpg , svg',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  ImageProvider _getImageProvider(
    CreateStoreController controller,
    dynamic media,
  ) {
    final url = controller.getMediaDisplayUrl(media);

    if (media.isLocal == true) {
      return FileImage(File(media.path));
    } else if (url.startsWith('http')) {
      return NetworkImage(url);
    } else {
      return AssetImage('assets/images/placeholder.png');
    }
  }

  Widget _buildCreateButton(CreateStoreController controller) {
    return Obx(() {
      if (controller.createStoreLoading.value) {
        return Center(
          child: Column(
            children: [
              CircularProgressIndicator(color: AppColors.primary400),
              SizedBox(height: 10),
              Text(
                'جاري التحقق من البيانات...',
                style: getRegular(color: AppColors.primary400),
              ),
            ],
          ),
        );
      }

      return AateneButton(
        buttonText: controller.isEditMode.value ? 'تحديث المتجر' : 'التالي',
        textColor: Colors.white,
        color: AppColors.primary400,
        borderColor: AppColors.primary400,
        raduis: 10,
        onTap: () async {
          if (await _validateForm(controller)) {
            if (controller.isEditMode.value) {
              final success = await controller.updateStoreBasicInfo();
              if (success ?? false) {
                Get.to(() => AddShippingMethod());
              }
            } else {
              Get.to(() => AddShippingMethod());
            }
          }
        },
      );
    });
  }

  Future<bool> _validateForm(CreateStoreController controller) async {
    if (controller.nameController.text.isEmpty) {
      Get.snackbar('❌ خطأ', 'يرجى إدخال اسم المتجر');
      return false;
    }

    if (controller.emailController.text.isEmpty) {
      Get.snackbar('❌ خطأ', 'يرجى إدخال البريد الإلكتروني');
      return false;
    }

    if (!controller.emailController.text.contains('@')) {
      Get.snackbar('❌ خطأ', 'يرجى إدخال بريد إلكتروني صحيح');
      return false;
    }

    if (controller.phoneController.text.isEmpty) {
      Get.snackbar('❌ خطأ', 'يرجى إدخال رقم الهاتف');
      return false;
    }

    if (controller.selectedLogoMedia.isEmpty) {
      Get.snackbar('❌ خطأ', 'يرجى إضافة صورة واحدة على الأقل للشعار');
      return false;
    }

    if (controller.primaryLogo.value == null) {
      Get.snackbar('❌ خطأ', 'يرجى تحديد صورة أساسية للشعار');
      return false;
    }

    if (controller.selectedCoverMedia.isEmpty) {
      Get.snackbar('❌ خطأ', 'يرجى إضافة صورة واحدة على الأقل للغلاف');
      return false;
    }

    if (controller.primaryCover.value == null) {
      Get.snackbar('❌ خطأ', 'يرجى تحديد صورة أساسية للغلاف');
      return false;
    }

    return true;
  }
}