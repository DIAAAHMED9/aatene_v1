import 'package:attene_mobile/view/advance_info/keyword_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';

import '../../models/store_model.dart';

class KeywordManagementScreen extends StatelessWidget {
  final KeywordController controller = Get.put(KeywordController());

  KeywordManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadStoresOnOpen();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
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
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الكلمات المفتاحية للمنتج',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'اختر المتجر وأضف الكلمات المفتاحية المناسبة لظهور أفضل في نتائج البحث',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 4),
            Text('*', style: TextStyle(color: Colors.red)),
            Spacer(),
            Obx(() {
              if (controller.storesError.isNotEmpty ||
                  (controller.stores.isEmpty &&
                      !controller.isLoadingStores.value)) {
                return IconButton(
                  icon: Icon(Icons.refresh, size: 20),
                  onPressed: () => controller.reloadStores(),
                  tooltip: 'إعادة تحميل المتاجر',
                );
              }
              return SizedBox.shrink();
            }),
          ],
        ),
        SizedBox(height: 8),
        Obx(() {
          print(
            '🔄 [REBUILDING STORE SELECTOR] Loading: ${controller.isLoadingStores.value}',
          );
          if (controller.isLoadingStores.isTrue) {
            return _buildStoreLoading();
          }

          if (controller.storesError.isNotEmpty) {
            return _buildStoreError();
          }

          if (controller.stores.isEmpty) {
            return _buildStoreEmpty();
          }

          return _buildStoreDropdown();
        }),
      ],
    );
  }

  Widget _buildStoreLoading() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text(
            'جاري تحميل المتاجر...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreError() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.storesError.value,
                  style: TextStyle(color: Colors.red[600]),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () => controller.reloadStores(),
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.store_mall_directory_outlined,
            color: Colors.orange,
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'لا توجد متاجر متاحة',
              style: TextStyle(color: Colors.orange[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDropdown() {
    return Obx(() {
      final stores = controller.stores;
      final selectedStore = controller.selectedStore.value;

      print(
        '🔄 [BUILDING DROPDOWN] Stores: ${stores.length}, Selected: ${selectedStore?.name}',
      );

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<Store>(
            isExpanded: true,
            value: selectedStore,
            decoration: InputDecoration(
              hintText: stores.isEmpty ? 'لا توجد متاجر متاحة' : 'اختر المتجر',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: stores.map((store) {
              return DropdownMenuItem(
                value: store,
                child: Container(
                  constraints: BoxConstraints(minHeight: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          if (store.logoUrl != null &&
                              store.logoUrl!.isNotEmpty)
                            Container(
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.only(left: 8),
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
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        controller.getStoreStatusText(store.status ?? ''),
                        style: TextStyle(
                          fontSize: 12,
                          color: controller.getStoreStatusColor(
                            store.status ?? '',
                          ),
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
    });
  }

  Widget _buildSearchBox() {
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
                  horizontal: 16,
                  vertical: 14,
                ),
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
          ),
          Obx(() => _buildAddButton()),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    final hasText = !controller.isSearchInputEmpty.value;
    final canAddMore = controller.canAddMoreKeywords;
    final isDuplicate = controller.searchController.text.isNotEmpty
        ? controller.isDuplicateKeyword(controller.searchController.text.trim())
        : false;
    String tooltipMessage = '';
    Color buttonColor = Colors.grey[300]!;

    if (!hasText) {
      tooltipMessage = 'اكتب كلمة مفتاحية أولاً';
    } else if (isDuplicate) {
      tooltipMessage = 'هذه الكلمة مضافه مسبقاً';
      buttonColor = Colors.orange[300]!;
    } else if (!canAddMore) {
      tooltipMessage = 'تم الوصول للحد الأقصى (15 كلمة)';
      buttonColor = Colors.red[300]!;
    } else {
      tooltipMessage = 'إضافة الكلمة المفتاحية';
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
            child: Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableKeywords() {
    return Obx(() {
      final keywords = controller.filteredKeywords; // ✅ Use filteredKeywords

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
                  child: Text(
                    keyword, // ✅ Just use keyword (it's a String)
                    style: TextStyle(
                      color: AppColors.primary400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
          Icon(Icons.search_off, size: 40, color: Colors.grey[400]),
          SizedBox(height: 8),
          Text(
            'لا توجد كلمات مفتاحية متاحة',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 4),
          Text(
            'جرب البحث بكلمات مختلفة',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
              'الكلمات المفتاحية المختارة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            Obx(
              () => Text(
                '${controller.selectedKeywords.length}/15',
                style: TextStyle(
                  fontSize: 14,
                  color: controller.selectedKeywords.length >= 15
                      ? Colors.red
                      : Colors.grey[600],
                ),
              ),
            ),
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
            Icon(Icons.tag, size: 40, color: Colors.grey[300]),
            SizedBox(height: 8),
            Text(
              'لا توجد كلمات مفتاحية مختارة',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            SizedBox(height: 4),
            Text(
              'اختر من الكلمات المفتاحية المتاحة',
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedKeywordsList() {
    return Container(
      constraints: BoxConstraints(minHeight: 60, maxHeight: 200),
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
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => ElevatedButton(
                onPressed:
                    controller.selectedKeywords.isNotEmpty &&
                        controller.selectedStore.value != null
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
                  'تأكيد الاختيار',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
