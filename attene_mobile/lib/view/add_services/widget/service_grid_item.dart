
import '../../../general_index.dart';
import '../../../utils/responsive/index.dart';

class ServiceGridItem extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isSelected;
  final ValueChanged<bool> onSelectionChanged;

  const ServiceGridItem({
    super.key,
    required this.service,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.isSelected,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: service.images.isNotEmpty
                      ? BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(ResponsiveDimensions.f(8)),
                            topRight: Radius.circular(
                              ResponsiveDimensions.f(8),
                            ),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(service.images.first),
                            fit: BoxFit.cover,
                          ),
                        )
                      : BoxDecoration(
                          color: AppColors.primary100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(ResponsiveDimensions.f(8)),
                            topRight: Radius.circular(
                              ResponsiveDimensions.f(8),
                            ),
                          ),
                        ),
                  child: service.images.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.work_outline,
                            size: 40,
                            color: AppColors.primary500,
                          ),
                        )
                      : null,
                ),
                Padding(
                  padding: EdgeInsets.all(ResponsiveDimensions.f(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: getBold(fontSize: ResponsiveDimensions.f(12)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ResponsiveDimensions.f(4)),
                      Text(
                        '${service.price} ₪',
                        style: TextStyle(
                          fontSize: ResponsiveDimensions.f(11),
                          color: AppColors.primary500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: ResponsiveDimensions.f(4)),
                      _buildStatusChip(service.status),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: EdgeInsets.all(ResponsiveDimensions.f(4)),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'خدمة',
                  style: getRegular(
                    fontSize: ResponsiveDimensions.f(10),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (onSelectionChanged != null)
              Positioned(
                top: 8,
                right: 8,
                child: Checkbox(
                  value: isSelected,
                  onChanged: (value) => onSelectionChanged(value ?? false),
                  activeColor: AppColors.primary400,
                ),
              ),
            Positioned(
              bottom: 8,
              right: 8,
              child: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  size: ResponsiveDimensions.f(16),
                  color: Colors.grey,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16),
                        SizedBox(width: 8),
                        Text('تعديل'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'حذف',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: "PingAR",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        horizontal: ResponsiveDimensions.f(6),
        vertical: ResponsiveDimensions.f(2),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: getRegular(fontSize: ResponsiveDimensions.f(10), color: color),
      ),
    );
  }
}