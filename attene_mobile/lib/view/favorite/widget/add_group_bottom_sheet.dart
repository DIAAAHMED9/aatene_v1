import 'package:attene_mobile/general_index.dart';

import '../controller/favorite_controller.dart';

class AddGroupBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? listToEdit;

  const AddGroupBottomSheet({super.key, this.listToEdit});

  @override
  State<AddGroupBottomSheet> createState() => _AddGroupBottomSheetState();
}

class _AddGroupBottomSheetState extends State<AddGroupBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool isPublic = false;
  String selectedType = 'product';

  final List<Map<String, dynamic>> listTypes = [
    {'value': 'product', 'label': 'منتجات'},
    {'value': 'service', 'label': 'خدمات'},
    {'value': 'store', 'label': 'متاجر'},
    {'value': 'blog', 'label': 'مدونات'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.listToEdit != null) {
      _nameController.text = widget.listToEdit!['name'] ?? '';
      _descController.text = widget.listToEdit!['description'] ?? '';
      isPublic = widget.listToEdit!['is_private'] == 0;
      selectedType = widget.listToEdit!['type'] ?? 'product';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    final controller = Get.find<FavoriteController>();

    return Container(
      height: 750,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              widget.listToEdit == null ? 'إضافة مجموعة جديدة' : 'تعديل المجموعة',
              style: getBold(fontSize: 20),
            ),
          ),
          const SizedBox(height: 24),
          Text('اسم المجموعة', style: getBold(fontSize: 18)),
          const SizedBox(height: 8),
          TextFiledAatene(
            isRTL: isRTL,
            hintText: 'عنوان المجموعة',
            controller: _nameController,
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.name,
          ),
          const SizedBox(height: 16),
          Text('الوصف (اختياري)', style: getBold(fontSize: 18)),
          const SizedBox(height: 8),
          TextFiledAatene(
            isRTL: isRTL,
            hintText: 'وصف المجموعة',
            controller: _descController,
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.text,
          ),
          
          if (widget.listToEdit == null) ...[
            const SizedBox(height: 16),
            Text('نوع القائمة', style: getBold(fontSize: 18)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedType,
                  isExpanded: true,
                  items: listTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type['value'],
                      child: Text(type['label']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),
          Text('الخصوصية', style: getBold(fontSize: 18)),
          const SizedBox(height: 8),
          _buildPrivacyOption(
            title: 'عامة',
            subtitle: 'أي شخص يمكنه رؤية هذه المجموعة',
            icon: Icons.public,
            isSelected: isPublic,
            onTap: () => setState(() => isPublic = true),
          ),
          _buildPrivacyOption(
            title: 'خاصة',
            subtitle: 'أنت فقط من يمكنه رؤية هذه المجموعة',
            icon: Icons.lock_outline,
            isSelected: !isPublic,
            onTap: () => setState(() => isPublic = false),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: AateneButton(
                  onTap: () => Get.back(),
                  buttonText: "إلغاء",
                  color: AppColors.light1000,
                  textColor: AppColors.primary400,
                  borderColor: AppColors.primary400,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AateneButton(
                  onTap: () {
                    if (_nameController.text.trim().isEmpty) {
                      Get.snackbar(
                        'تنبيه',
                        'الرجاء إدخال اسم المجموعة',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.warning100,
                        colorText: AppColors.neutral900,
                      );
                      return;
                    }
                    if (widget.listToEdit == null) {
                      controller.createFavoriteList(
                        name: _nameController.text.trim(),
                        description: _descController.text.trim().isEmpty
                            ? null
                            : _descController.text.trim(),
                        isPrivate: !isPublic,
                        type: selectedType,
                      );
                    } else {
                      controller.updateFavoriteList(
                        listId: widget.listToEdit!['id'].toString(),
                        name: _nameController.text.trim(),
                        description: _descController.text.trim().isEmpty
                            ? null
                            : _descController.text.trim(),
                        isPrivate: !isPublic,
                      );
                    }
                  },
                  buttonText: widget.listToEdit == null ? "إنشاء" : "تحديث",
                  color: AppColors.primary400,
                  textColor: AppColors.light1000,
                  borderColor: AppColors.primary400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPrivacyOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.primary400 : Colors.grey[200]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: isSelected ? AppColors.primary400 : Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: getBold(
                          color: isSelected ? AppColors.primary400 : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: getMedium(fontSize: 14, color: AppColors.neutral600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}