
import '../../../../general_index.dart';
import '../../../../utils/responsive/index.dart';

class DiscountDetailsBottomSheet extends StatelessWidget {
  final RelatedProductsController controller;
  final ProductDiscount discount;

  const DiscountDetailsBottomSheet({
    super.key,
    required this.controller,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      constraints: BoxConstraints(maxHeight: Get.height * 0.8),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تفاصيل التخفيض',
                    style: getBold(fontSize: ResponsiveDimensions.f(18)),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveDimensions.h(16)),
              _buildDetailRow(
                'السعر الأصلي',
                '${discount.originalPrice.toStringAsFixed(2)} ₪',
              ),
              _buildDetailRow(
                'السعر بعد الخصم',
                '${discount.discountedPrice.toStringAsFixed(2)} ₪',
              ),
              _buildDetailRow(
                'قيمة الخصم',
                '${discount.discountAmount.toStringAsFixed(2)} ₪',
              ),
              _buildDetailRow(
                'نسبة الخصم',
                '${discount.discountPercentage.toStringAsFixed(1)}%',
              ),
              if (discount.note.isNotEmpty)
                _buildDetailRow('ملاحظات', discount.note),
              _buildDetailRow('التاريخ', _formatDate(discount.date)),
              _buildDetailRow('عدد المنتجات', '${discount.productCount} منتج'),
              SizedBox(height: ResponsiveDimensions.h(24)),
              if (discount.products != null && discount.products!.isNotEmpty)
                _buildProductsList(),
              SizedBox(height: ResponsiveDimensions.h(16)),
              AateneButton(buttonText: 'إغلاق', onTap: Get.back),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveDimensions.h(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: getRegular(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: label.contains('خصم') ? Colors.green[600] : null,
                fontFamily: "PingAR",
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('المنتجات المرفقة:', style: getBold()),
        SizedBox(height: ResponsiveDimensions.h(8)),
        Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.3),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: discount.products!.length,
            itemBuilder: (context, index) {
              final product = discount.products![index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[50],
                  child: Icon(Icons.shopping_bag, color: Colors.blue, size: 20),
                ),
                title: Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(_formatPrice(product.price ?? '0')),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatPrice(String price) {
    try {
      final cleanPrice = price.replaceAll(RegExp(r'[^\d.]'), '');
      final priceDouble = double.tryParse(cleanPrice) ?? 0.0;
      return '${priceDouble.toStringAsFixed(2)} ₪';
    } catch (e) {
      return '0.00 ₪';
    }
  }
}

class AddDiscountBottomSheet extends StatelessWidget {
  final RelatedProductsController controller;

  const AddDiscountBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        color: Colors.white,
      ),
      constraints: BoxConstraints(maxHeight: Get.height * 0.8),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'إضافة تخفيض',
                    style: getBold(fontSize: ResponsiveDimensions.f(18)),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveDimensions.h(16)),
              _buildPriceInput(),
              SizedBox(height: ResponsiveDimensions.h(16)),
              _buildNoteInput(),
              SizedBox(height: ResponsiveDimensions.h(16)),
              _buildDatePicker(),
              SizedBox(height: ResponsiveDimensions.h(24)),
              GetBuilder<RelatedProductsController>(
                id: 'discount',
                builder: (controller) {
                  return Column(
                    children: [
                      if (controller.hasSelectedProducts) _buildSummary(),
                      SizedBox(height: ResponsiveDimensions.h(16)),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                controller.clearDiscountFields();
                              },
                              child: const Text('مسح الحقول'),
                            ),
                          ),
                          SizedBox(width: ResponsiveDimensions.w(12)),
                          Expanded(
                            child: AateneButton(
                              buttonText: 'إضافة التخفيض',
                              onTap: () {
                                controller.addDiscount();
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveDimensions.h(12)),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceInput() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'السعر بعد التخفيض',
        hintText: 'أدخل السعر بعد التخفيض',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        suffixText: '₪',
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      onChanged: (value) {
        final price = double.tryParse(value) ?? 0.0;
        controller.setDiscountedPrice(price);
      },
    );
  }

  Widget _buildNoteInput() {
    return TextField(
      maxLines: 3,
      minLines: 2,
      decoration: InputDecoration(
        labelText: 'ملاحظات (اختياري)',
        hintText: 'أدخل ملاحظات عن التخفيض',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      onChanged: controller.setDiscountNote,
    );
  }

  Widget _buildDatePicker() {
    return TextField(
      controller: controller.dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'تاريخ التخفيض',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        suffixIcon: Icon(Icons.calendar_today),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: Get.context!,
          initialDate: controller.discountDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (selectedDate != null) {
          final selectedTime = await showTimePicker(
            context: Get.context!,
            initialTime: TimeOfDay.fromDateTime(controller.discountDate),
          );
          if (selectedTime != null) {
            final dateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );
            controller.setDiscountDate(dateTime);
          }
        }
      },
    );
  }

  Widget _buildSummary() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: EdgeInsets.all(ResponsiveDimensions.w(12)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(child: Text('السعر الأصلي:')),
                Flexible(
                  child: Text(
                    '${controller.originalPrice.toStringAsFixed(2)} ₪',
                    style: getBold(),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDimensions.h(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(child: Text('السعر بعد الخصم:')),
                Flexible(
                  child: Text(
                    '${controller.discountedPrice.toStringAsFixed(2)} ₪',
                    style: getBold(color: Colors.green),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDimensions.h(8)),
            if (controller.discountedPrice > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(child: Text('قيمة التخفيض:')),
                  Flexible(
                    child: Text(
                      '${(controller.originalPrice - controller.discountedPrice).toStringAsFixed(2)} ₪',
                      style: getBold(color: Colors.red),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}