import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/notification/model/notification_model.dart';
import 'package:attene_mobile/view/notification/widget/notification_item.dart';

class AnimatedNotificationItem extends StatefulWidget {
  final NotificationModel model;
  final VoidCallback onDelete;
  final VoidCallback onMarkRead;

  const AnimatedNotificationItem({
    super.key,
    required this.model,
    required this.onDelete,
    required this.onMarkRead,
  });

  @override
  State<AnimatedNotificationItem> createState() =>
      _AnimatedNotificationItemState();
}

class _AnimatedNotificationItemState extends State<AnimatedNotificationItem> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: visible
          ? TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.95, end: 1),
              duration: const Duration(milliseconds: 300),
              builder: (_, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Dismissible(
                  key: ValueKey(widget.model.hashCode),
                  direction: DismissDirection.horizontal,
                  background: _buildMarkReadBackground(),
                  secondaryBackground: _buildDeleteBackground(),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      widget.onMarkRead();
                      return false;
                    } else {
                      setState(() => visible = false);
                      Future.delayed(
                        const Duration(milliseconds: 300),
                        widget.onDelete,
                      );
                      return true;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.model.isRead
                          ? AppColors.neutral50
                          : AppColors.primary50.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.model.isRead
                            ? AppColors.neutral100
                            : AppColors.primary100,
                        width: 1,
                      ),
                    ),
                    child: NotificationItem(
                      model: widget.model,
                      showMarkAsRead: false,
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 24),
      decoration: BoxDecoration(
        color: AppColors.error200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "حذف",
            style: getMedium(color: AppColors.light1000, fontSize: 13),
          ),
          const SizedBox(width: 5),
          Icon(Icons.delete, color: AppColors.light1000, size: 20),
        ],
      ),
    );
  }

  Widget _buildMarkReadBackground() {
    if (widget.model.isRead) return Container();

    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        color: AppColors.primary400,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.remove_red_eye_rounded,
            color: AppColors.light1000,
            size: 20,
          ),
          const SizedBox(width: 5),
          Text(
            "تحديد كمقروء",
            style: getMedium(color: AppColors.light1000, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
