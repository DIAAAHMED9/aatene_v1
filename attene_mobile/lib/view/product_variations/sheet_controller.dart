import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/view/product_variations/product_variation_model.dart';

class BottomSheetController extends GetxController {
  final RxList<ProductAttribute> selectedAttributesRx = <ProductAttribute>[].obs;

  void openManageAttributes(
    List<ProductAttribute> allAttributes,
    List<ProductAttribute> selectedAttributes,
    Function(List<ProductAttribute>) onSelected,
  ) {
    selectedAttributesRx.assignAll(selectedAttributes);

    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'إدارة السمات والصفات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'السمات المتاحة',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Obx(() => Text(
                    '${selectedAttributesRx.length} مختارة',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: allAttributes.length,
                itemBuilder: (context, index) {
                  final attribute = allAttributes[index];
                  final isSelected = selectedAttributesRx
                      .any((attr) => attr.id == attribute.id);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        attribute.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.blue[700] : Colors.black87,
                        ),
                      ),
                      subtitle: Text('${attribute.values.length} قيمة'),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          if (value == true) {
                            selectedAttributesRx.add(attribute);
                          } else {
                            selectedAttributesRx
                                .removeWhere((attr) => attr.id == attribute.id);
                          }
                        },
                        activeColor: Colors.blue,
                      ),
                      onTap: () {
                        if (isSelected) {
                          selectedAttributesRx
                              .removeWhere((attr) => attr.id == attribute.id);
                        } else {
                          selectedAttributesRx.add(attribute);
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onSelected(selectedAttributesRx.toList());
                      Get.back();
                      
                      Get.snackbar(
                        'تم الحفظ',
                        'تم حفظ السمات المختارة',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('حفظ'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void updateSelectedAttributes(List<ProductAttribute> attributes) {
    selectedAttributesRx.assignAll(attributes);
  }
}