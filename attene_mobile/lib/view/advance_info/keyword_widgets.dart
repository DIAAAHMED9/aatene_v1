import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import '../../models/store_model.dart';
import 'keyword_controller.dart';

class KeywordHeaderWidget extends StatelessWidget {
  const KeywordHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الكلمات المفتاحية للمنتج',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(18),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: ResponsiveDimensions.f(8)),
        Text(
          'اختر المتجر وأضف الكلمات المفتاحية المناسبة لظهور أفضل في نتائج البحث',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(14),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class StoreSelectorWidget extends StatelessWidget {
  const StoreSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KeywordController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'إظهار المنتج في متجر',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: ResponsiveDimensions.f(4)),
            Text('*', style: TextStyle(color: Colors.red)),
            const Spacer(),
            Obx(() {
              if (controller.hasStoresError ||
                  (!controller.isLoadingStores.value &&
                      !controller.hasStores)) {
                return IconButton(
                  icon: Icon(Icons.refresh, size: ResponsiveDimensions.f(20)),
                  onPressed: controller.reloadStores,
                  tooltip: 'إعادة تحميل المتاجر',
                );
              }
              return const SizedBox();
            }),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.f(8)),
        GetBuilder<KeywordController>(
          builder: (_) {
            if (controller.isLoadingStores.value) {
              return _buildStoreLoading();
            }

            if (controller.hasStoresError) {
              return _buildStoreError(controller.storesError.value);
            }

            if (!controller.hasStores) {
              return _buildStoreEmpty();
            }

            return _buildStoreDropdown(controller);
          },
        ),
      ],
    );
  }

  Widget _buildStoreLoading() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.f(16),
        vertical: ResponsiveDimensions.f(16),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: ResponsiveDimensions.f(20),
            height: ResponsiveDimensions.f(20),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: ResponsiveDimensions.f(12)),
          Text(
            'جاري تحميل المتاجر...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: ResponsiveDimensions.f(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreError(String error) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.f(16),
            vertical: ResponsiveDimensions.f(16),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: ResponsiveDimensions.f(20),
              ),
              SizedBox(width: ResponsiveDimensions.f(12)),
              Expanded(
                child: Text(
                  error,
                  style: TextStyle(
                    color: Colors.red[600],
                    fontSize: ResponsiveDimensions.f(14),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveDimensions.f(8)),
        ElevatedButton.icon(
          onPressed: () => Get.find<KeywordController>().reloadStores,
          icon: Icon(Icons.refresh),
          label: Text('إعادة المحاولة'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStoreEmpty() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.f(16),
        vertical: ResponsiveDimensions.f(16),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.store_mall_directory_outlined,
            color: Colors.orange,
            size: ResponsiveDimensions.f(20),
          ),
          SizedBox(width: ResponsiveDimensions.f(12)),
          Expanded(
            child: Text(
              'لا توجد متاجر متاحة',
              style: TextStyle(
                color: Colors.orange[600],
                fontSize: ResponsiveDimensions.f(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDropdown(KeywordController controller) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<Store>(
          isExpanded: true,
          value: controller.selectedStore.value,
          decoration: InputDecoration(
            hintText: controller.hasStores
                ? 'اختر المتجر'
                : 'لا توجد متاجر متاحة',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveDimensions.f(16),
              vertical: ResponsiveDimensions.f(16),
            ),
          ),
          items: controller.stores.map((store) {
            return DropdownMenuItem(
              value: store,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: ResponsiveDimensions.f(60),
                ),
                child: Row(
                  children: [
                    if (store.logoUrl != null && store.logoUrl!.isNotEmpty)
                      Container(
                        width: ResponsiveDimensions.f(30),
                        height: ResponsiveDimensions.f(30),
                        margin: EdgeInsets.only(
                          left: ResponsiveDimensions.f(8),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(store.logoUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        store.name,
                        style: TextStyle(fontSize: ResponsiveDimensions.f(14)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: (Store? value) {
            if (value != null) {
              controller.setSelectedStore(value);
            }
          },
        ),
      ),
    );
  }
}

class KeywordSearchBoxWidget extends StatelessWidget {
  const KeywordSearchBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KeywordController>();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.searchController,
              onSubmitted: (value) => controller.addCustomKeyword(),
              decoration: InputDecoration(
                hintText: 'اكتب الكلمة المفتاحية ثم اضغط على إضافة...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveDimensions.f(16),
                  vertical: ResponsiveDimensions.f(14),
                ),
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: ResponsiveDimensions.f(14),
                ),
              ),
            ),
          ),
          GetBuilder<KeywordController>(
            builder: (_) => _buildAddButton(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(KeywordController controller) {
    final hasText = !controller.isSearchInputEmpty.value;
    final canAddMore = controller.canAddMoreKeywords;
    final isDuplicate = hasText
        ? controller.selectedKeywords.contains(
            controller.searchController.text.trim(),
          )
        : false;

    String tooltipMessage = '';
    Color buttonColor = Colors.grey[300]!;

    if (!hasText) {
      tooltipMessage = 'اكتب كلمة مفتاحية أولاً';
    } else if (isDuplicate) {
      tooltipMessage = 'هذه الكلمة مضافه مسبقاً';
      buttonColor = Colors.orange[300]!;
    } else if (!canAddMore) {
      tooltipMessage =
          'تم الوصول للحد الأقصى (${KeywordController.maxKeywords} كلمة)';
      buttonColor = Colors.red[300]!;
    } else {
      tooltipMessage = 'إضافة الكلمة المفتاحية';
      buttonColor = AppColors.primary400;
    }

    return Tooltip(
      message: tooltipMessage,
      child: Container(
        margin: EdgeInsets.only(
          left: ResponsiveDimensions.f(8),
          right: ResponsiveDimensions.f(8),
        ),
        child: InkWell(
          onTap: hasText && canAddMore && !isDuplicate
              ? () => controller.addCustomKeyword()
              : null,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: ResponsiveDimensions.f(40),
            height: ResponsiveDimensions.f(40),
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: ResponsiveDimensions.f(20),
            ),
          ),
        ),
      ),
    );
  }
}

class AvailableKeywordsWidget extends StatelessWidget {
  const AvailableKeywordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KeywordController>();

    return GetBuilder<KeywordController>(
      builder: (_) {
        final keywords = controller.filteredKeywords;

        if (keywords.isEmpty) {
          return _buildEmptyAvailableKeywords();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'الكلمات المفتاحية المتاحة',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(16),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: ResponsiveDimensions.f(12)),
            Wrap(
              spacing: ResponsiveDimensions.f(8),
              runSpacing: ResponsiveDimensions.f(8),
              children: keywords.map((keyword) {
                return InkWell(
                  onTap: () => controller.addKeyword(keyword),
                  child: Container(
                    child: Text(
                      keyword,
                      style: TextStyle(
                        color: AppColors.primary400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveDimensions.f(15),
                      vertical: ResponsiveDimensions.f(10),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary400),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyAvailableKeywords() {
    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.f(16)),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: ResponsiveDimensions.f(40),
            color: Colors.grey[400],
          ),
          SizedBox(height: ResponsiveDimensions.f(8)),
          Text(
            'لا توجد كلمات مفتاحية متاحة',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(14),
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: ResponsiveDimensions.f(4)),
          Text(
            'جرب البحث بكلمات مختلفة',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(12),
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SelectedKeywordsWidget extends StatelessWidget {
  const SelectedKeywordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KeywordController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'الكلمات المفتاحية المختارة',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(16),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            GetBuilder<KeywordController>(
              builder: (_) => Text(
                '${controller.selectedKeywords.length}/${KeywordController.maxKeywords}',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(14),
                  color:
                      controller.selectedKeywords.length >=
                          KeywordController.maxKeywords
                      ? Colors.red
                      : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.f(8)),
        GetBuilder<KeywordController>(
          builder: (_) {
            if (controller.selectedKeywords.isEmpty) {
              return _buildEmptySelectedKeywords();
            }
            return _buildSelectedKeywordsList(controller);
          },
        ),
      ],
    );
  }

  Widget _buildEmptySelectedKeywords() {
    return Container(
      height: ResponsiveDimensions.f(120),
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
              size: ResponsiveDimensions.f(40),
              color: Colors.grey[300],
            ),
            SizedBox(height: ResponsiveDimensions.f(8)),
            Text(
              'لا توجد كلمات مفتاحية مختارة',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(14),
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: ResponsiveDimensions.f(4)),
            Text(
              'اختر من الكلمات المفتاحية المتاحة',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(12),
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedKeywordsList(KeywordController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: ResponsiveDimensions.f(60),
          maxHeight: ResponsiveDimensions.f(200),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveDimensions.f(12)),
          child: Wrap(
            spacing: ResponsiveDimensions.f(8),
            runSpacing: ResponsiveDimensions.f(8),
            children: controller.selectedKeywords.map((keyword) {
              return Chip(
                label: Text(keyword),
                backgroundColor: AppColors.primary100,
                deleteIconColor: AppColors.primary400,
                onDeleted: () => controller.removeKeyword(keyword),
                labelStyle: TextStyle(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(color: AppColors.primary300, width: 1.0),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class KeywordBottomActionsWidget extends StatelessWidget {
  const KeywordBottomActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KeywordController>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.f(16),
        vertical: ResponsiveDimensions.f(12),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveDimensions.f(14),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: Colors.grey[400]!),
              ),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: ResponsiveDimensions.f(16),
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveDimensions.f(12)),
          Expanded(
            child: GetBuilder<KeywordController>(
              builder: (_) => ElevatedButton(
                onPressed: controller.isFormValid
                    ? () => controller.confirmSelection()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary400,
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveDimensions.f(14),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'تأكيد الاختيار',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveDimensions.f(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}