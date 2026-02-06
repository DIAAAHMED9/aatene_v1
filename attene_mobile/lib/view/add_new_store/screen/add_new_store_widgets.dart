import '../../../general_index.dart';
import '../../../utils/platform/local_image.dart';
import '../../../utils/platform/local_image_provider.dart';

class AddNewStoreForm extends StatelessWidget {
  final CreateStoreController controller;
  final bool isRTL;

  const AddNewStoreForm({
    super.key,
    required this.controller,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWithStar(text: "اسم المتجر"),
            TextFiledAatene(
              heightTextFiled: 50,
              isRTL: isRTL,
              hintText: "أدخل اسم المتجر",
              controller: controller.nameController,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.name,
            ),
            _StoreTypeBanner(controller: controller),
            const TextWithStar(text: "شعار المتجر"),
            Text(
              "اختر صورة أساسية للشعار (حد أقصى 5 صور)",
              style: getMedium(fontSize: 12, color: Colors.grey),
            ),
            _LogoImagesList(controller: controller),
            const SizedBox(height: 10),
            const TextWithStar(text: "صور الغلاف"),
            Text(
              "اختر صورة واحدة على الأقل للغلاف (حد أقصى 10 صور)",
              style: getMedium(fontSize: 12, color: Colors.grey),
            ),
            _CoverImagesList(controller: controller),
            const SizedBox(height: 10),
            const TextWithStar(text: "وصف المتجر"),
            TextFiledAatene(
              heightTextFiled: 50,
              isRTL: isRTL,
              hintText: "أدخل وصف المتجر",
              controller: controller.descriptionController,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.name,
            ),
            const TextWithStar(text: "البريد الالكتروني"),
            TextFiledAatene(
              heightTextFiled: 50,
              isRTL: isRTL,
              hintText: "example@email.com",
              controller: controller.emailController,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.emailAddress,
            ),
            _CitySelector(controller: controller),
            _DistrictSelector(controller: controller),
            _CurrencySelector(controller: controller),
            const TextWithStar(text: "الهاتف المحمول"),
            TextFiledAatene(
              heightTextFiled: 50,
              isRTL: isRTL,
              hintText: "أدخل رقم الهاتف",
              controller: controller.phoneController,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.number,
            ),
            _HidePhoneTile(controller: controller),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            _CreateButton(controller: controller),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _StoreTypeBanner extends StatelessWidget {
  final CreateStoreController controller;

  const _StoreTypeBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          spacing: 7,
          children: [
            Icon(Icons.store, color: AppColors.primary400),
            Text(
              "نوع المتجر: ${controller.storeType.value == 'products' ? 'منتجات' : 'خدمات'}",
              style: getMedium(fontSize: 14, color: AppColors.primary500),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoImagesList extends StatelessWidget {
  final CreateStoreController controller;

  const _LogoImagesList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final logoCount = controller.selectedLogoMedia.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'الصور المختارة: $logoCount/5',
              style: getMedium(
                fontSize: 12,
                color: logoCount >= 5 ? Colors.red : Colors.grey,
                fontWeight: logoCount >= 5
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
          if (controller.selectedLogoMedia.isEmpty)
            _EmptyMediaPicker(
              onTap: controller.openMediaLibraryForLogo,
              title: 'اضف او اسحب صورة او فيديو',
              subtitle: 'png , jpg , svg',
            )
          else
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(width: 4),
                  ...controller.selectedLogoMedia.asMap().entries.map((entry) {
                    final index = entry.key;
                    final media = entry.value;

                    return _MediaTile(
                      width: 130,
                      imageProvider: _getImageProvider(controller, media),
                      title: 'شعار ${index + 1}',
                      isPrimary: controller.isPrimaryLogo(media),
                      onRemove: () => controller.removeLogo(index),
                    );
                  }),
                  _AddMoreTile(onTap: controller.openMediaLibraryForLogo),
                ],
              ),
            ),
        ],
      );
    });
  }
}

class _CoverImagesList extends StatelessWidget {
  final CreateStoreController controller;

  const _CoverImagesList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final coverCount = controller.selectedCoverMedia.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'الصور المختارة: $coverCount/10',
              style: getMedium(
                fontSize: 12,
                color: coverCount >= 10 ? Colors.red : Colors.grey,
                fontWeight: coverCount >= 10
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
          if (controller.selectedCoverMedia.isEmpty)
            _EmptyMediaPicker(
              onTap: controller.openMediaLibraryForCover,
              title: 'اضف او اسحب صورة او فيديو',
              subtitle: 'png , jpg , svg',
            )
          else
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(width: 4),
                  ...controller.selectedCoverMedia.asMap().entries.map((entry) {
                    final index = entry.key;
                    final media = entry.value;

                    return _MediaTile(
                      width: 160,
                      imageProvider: _getImageProvider(controller, media),
                      title: 'غلاف ${index + 1}',
                      isPrimary: controller.isPrimaryCover(media),
                      onRemove: () => controller.removeCover(index),
                    );
                  }),
                  _AddMoreTile(onTap: controller.openMediaLibraryForCover),
                ],
              ),
            ),
        ],
      );
    });
  }
}

class _EmptyMediaPicker extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String subtitle;

  const _EmptyMediaPicker({
    required this.onTap,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.customAddProductWidgets,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.add, size: 25, color: Colors.black),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: getMedium(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _MediaTile extends StatelessWidget {
  final double width;
  final ImageProvider imageProvider;
  final String title;
  final bool isPrimary;
  final VoidCallback onRemove;

  const _MediaTile({
    required this.width,
    required this.imageProvider,
    required this.title,
    required this.isPrimary,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPrimary ? AppColors.primary400 : Colors.grey[200]!,
          width: isPrimary ? 3 : 1,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image(
              image: imageProvider,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[100],
                child: Icon(Icons.image, size: 40, color: Colors.grey[400]),
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
                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: getMedium(color: Colors.white, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isPrimary)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
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
              onTap: onRemove,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddMoreTile extends StatelessWidget {
  final VoidCallback onTap;

  const _AddMoreTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(child: Icon(Icons.add)),
      ),
    );
  }
}

ImageProvider _getImageProvider(
  CreateStoreController controller,
  dynamic media,
) {
  if (media is MediaItem) {
    final url = media.fileUrl;
    if (url != null && url.isNotEmpty) {
      return NetworkImage(url);
    }
  }
  if (media is String && media.trim().isNotEmpty) {
    return localImageProvider(media);
  }
  return const AssetImage('assets/images/png/placeholder.png');
}

class _CitySelector extends StatelessWidget {
  final CreateStoreController controller;

  const _CitySelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextWithStar(text: "المدينة"),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => controller.openCitySelection(),
          child: AbsorbPointer(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      final cityName = controller.selectedCityName.value;
                      return Text(
                        cityName,
                        style: getMedium(
                          color: cityName != 'اختر المدينة'
                              ? AppColors.neutral100
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DistrictSelector extends StatelessWidget {
  final CreateStoreController controller;

  const _DistrictSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextWithStar(text: "الحي"),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => controller.openDistrictSelection(),
          child: AbsorbPointer(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(100),
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
                        style: getMedium(
                          color: districtName != 'اختر الحي'
                              ? AppColors.neutral100
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CurrencySelector extends StatelessWidget {
  final CreateStoreController controller;

  const _CurrencySelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextWithStar(text: "العملة"),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => controller.openCurrencySelection(),
          child: AbsorbPointer(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(100),
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
                        style: getMedium(
                          color: currencyName != 'اختر العملة'
                              ? AppColors.neutral100
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HidePhoneTile extends StatelessWidget {
  final CreateStoreController controller;

  const _HidePhoneTile({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Checkbox(
              value: controller.hidePhone.value,
              onChanged: (newValue) =>
                  controller.hidePhone.value = newValue ?? false,
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.primary400;
                }
                return Colors.white;
              }),
              side: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "إخفاء رقم الهاتف على الملف الشخصي",
                style: getMedium(fontSize: 14, color: AppColors.neutral700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  final CreateStoreController controller;

  const _CreateButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AateneButton(
      buttonText: controller.isEditMode.value ? 'تحديث المتجر' : 'إنشاء المتجر',
      textColor: Colors.white,
      color: AppColors.primary400,
      borderColor: AppColors.primary400,
      onTap: () => Get.to(AddShippingMethod()),
    );
  }
}
