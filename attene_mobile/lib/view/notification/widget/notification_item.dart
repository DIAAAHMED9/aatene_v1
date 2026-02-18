import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/notification/model/notification_model.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel model;
  final bool showMarkAsRead;

  const NotificationItem({
    super.key,
    required this.model,
    this.showMarkAsRead = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildAvatar(), _buildContent(), _buildImage()],
    );
  }

  Widget _buildImage() {
    return Image.asset(
      "assets/images/png/N0_services.png",
      width: 70,
      height: 50,
      fit: BoxFit.cover,
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 30,
      backgroundImage: model.image != null ? AssetImage(model.image!) : null,
      backgroundColor: Colors.grey.shade200,
      child: model.image == null
          ? Icon(Icons.notifications, color: AppColors.neutral400, size: 24)
          : null,
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.title, style: getBold(fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            model.body,
            style: getMedium(color: AppColors.neutral800, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            model.time,
            style: getMedium(fontSize: 12, color: AppColors.neutral700),
          ),
        ],
      ),
    );
  }
}