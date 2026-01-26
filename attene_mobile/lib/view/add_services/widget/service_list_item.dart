import '../../../general_index.dart';
import '../../../utils/responsive/index.dart';

class ServiceListItem extends StatelessWidget {
  final Service service;
  final ServiceController controller;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;
  final VoidCallback? onTap;

  const ServiceListItem({
    super.key,
    required this.service,
    required this.controller,
    this.isSelected = false,
    this.onSelectionChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelectionMode = controller.isInSelectionMode;

    return GestureDetector(
      onLongPress: () {
        if (!isSelectionMode) {
          final serviceId = service.id?.toString() ?? '';
          if (serviceId.isNotEmpty) {
            controller.toggleServiceSelection(serviceId);
          }
        }
      },
      onTap: () {
        if (isSelectionMode) {
          final serviceId = service.id?.toString() ?? '';
          if (serviceId.isNotEmpty) {
            controller.toggleServiceSelection(serviceId);
          }
        } else {
          onTap?.call();
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              if (isSelectionMode)
                Padding(
                  padding: EdgeInsets.only(left: ResponsiveDimensions.f(5)),
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      onSelectionChanged?.call(value ?? false);
                    },
                    activeColor: AppColors.primary400,
                  ),
                ),

              _buildServiceImage(context),

              SizedBox(width: ResponsiveDimensions.f(10)),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveDimensions.f(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: getMedium(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: ResponsiveDimensions.f(4)),

                      // if (service.sectionId != null && service.sectionId != 0)
                      //   Row(
                      //     children: [
                      //       Icon(
                      //         Icons.category_outlined,
                      //         color: Colors.grey[600],
                      //         size: ResponsiveDimensions.f(14),
                      //       ),
                      //       SizedBox(width: ResponsiveDimensions.f(4)),
                      //       Text(
                      //         _getSectionName(service.sectionId!),
                      //         style: getRegular(
                      //           fontSize: ResponsiveDimensions.f(12),
                      //           color: Color(0xFF757575),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      SizedBox(height: ResponsiveDimensions.f(4)),
                      _buildStatusChip(service.status),
                    ],
                  ),
                ),
              ),
              Text('${service.price} ₪', style: getBold(fontSize: 12)),
              SizedBox(width: ResponsiveDimensions.f(15)),
              if (!isSelectionMode)
                IconButton(
                  onPressed: _showServiceOptions,
                  icon: Icon(
                    Icons.more_horiz,
                    color: Colors.grey,
                    size: ResponsiveDimensions.f(24),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          Divider(height: 3),
        ],
      ),
    );
  }

  Widget _buildServiceImage(BuildContext context) {
    final imageSize = ResponsiveDimensions.f(70);
    print(' image${service.images}');
    return Container(
      width: imageSize,
      height: imageSize,
      margin: EdgeInsets.all(ResponsiveDimensions.f(12)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: service.imagesUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                (service.imagesUrl.isNotEmpty ? service.imagesUrl.first : ''),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      color: AppColors.primary400,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.work_outline,
                      color: Colors.grey[400],
                      size: ResponsiveDimensions.f(40),
                    ),
                  );
                },
              ),
            )
          : Container(
              color: Colors.grey[200],
              child: Icon(
                Icons.work_outline,
                color: Colors.grey[400],
                size: ResponsiveDimensions.f(40),
              ),
            ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        text = 'قيد المراجعة';
        break;
      case 'draft':
        color = Colors.grey;
        text = 'مسودة';
        break;
      case 'rejected':
        color = Colors.red;
        text = 'مرفوض';
        break;
      case 'approved':
        color = Colors.green;
        text = 'معتمد';
        break;
      case 'active':
        color = Colors.green;
        text = 'نشط';
        break;
      default:
        color = Colors.blue;
        text = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.f(8),
        vertical: ResponsiveDimensions.f(4),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: getMedium(fontSize: ResponsiveDimensions.f(10), color: color),
      ),
    );
  }

  String _getSectionName(int sectionId) {
    final section = controller.sections.firstWhere(
      (s) => int.tryParse((s['id'] ?? '').toString()) == sectionId,
      orElse: () => {'name': 'غير محدد'},
    );
    return section['name']?.toString() ?? 'غير محدد';
  }

  void _showServiceOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.edit,
                color: AppColors.primary400,
                size: ResponsiveDimensions.f(24),
              ),
              title: Text('تعديل الخدمة', style: getRegular()),
              onTap: () {
                Get.back();
                _editService();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Colors.red,
                size: ResponsiveDimensions.f(24),
              ),
              title: Text('حذف الخدمة', style: getRegular()),
              onTap: () {
                Get.back();
                _confirmDeleteService();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.visibility,
                color: Colors.blue,
                size: ResponsiveDimensions.f(24),
              ),
              title: Text('عرض التفاصيل', style: getRegular()),
              onTap: () {
                Get.back();
                _viewServiceDetails();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.content_copy,
                color: Colors.orange,
                size: ResponsiveDimensions.f(24),
              ),
              title: Text('نسخ الخدمة', style: getRegular()),
              onTap: () {
                Get.back();
                _copyService();
              },
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary500.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          SizedBox(height: 15),
                          Icon(
                            Icons.edit,
                            size: ResponsiveDimensions.responsiveFontSize(32),
                            color: AppColors.primary500,
                          ),
                          Text(
                            'تعديل السؤال',
                            style: getMedium(
                              fontSize: 14,
                              color: AppColors.primary500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Get.back();
                      _editService();
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.error300.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          SizedBox(height: 15),
                          Icon(
                            Icons.delete_outline,
                            size: ResponsiveDimensions.responsiveFontSize(32),
                            color: AppColors.error300,
                          ),
                          Text(
                            'حذف السؤال',
                            style: getMedium(
                              fontSize: 14,
                              color: AppColors.error300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Get.back();
                      _confirmDeleteService();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDimensions.f(20)),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _editService() {
    if (service.id != null) {
      controller.setEditMode(service.id!.toString(), service.title);
      Get.toNamed(
        '/add-service',
        arguments: {'isEditMode': true, 'serviceId': service.id},
      );
    }
  }

  void _confirmDeleteService() {
    Get.dialog(
      AlertDialog(
        title: Text('حذف الخدمة'),
        content: Text('هل أنت متأكد من حذف الخدمة "${service.title}"؟'),
        actions: [
          AateneButton(
            onTap: () {
              Get.back();
              _deleteService();
            },
            buttonText: "حذف",
            color: AppColors.primary400,
            textColor: AppColors.light1000,
            borderColor: AppColors.primary400,
          ),
          SizedBox(height: 10),
          AateneButton(
            onTap: () => Get.back(),
            buttonText: "إلغاء",
            color: AppColors.light1000,
            textColor: AppColors.primary400,
            borderColor: AppColors.primary400,
          ),
        ],
      ),
    );
  }

  void _viewServiceDetails() {
    Get.toNamed('/service-details', arguments: service);
  }

  void _copyService() {
    Get.snackbar(
      'نسخ الخدمة',
      'تم نسخ الخدمة ${service.title}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _deleteService() {
    if (service.id != null) {
      controller.deleteService(service.id!.toString()).then((result) {
        if (result?['success'] == true) {
          Get.snackbar(
            'نجاح',
            'تم حذف الخدمة بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      });
    }
  }
}
