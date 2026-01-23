import '../../../general_index.dart';
import '../../../utlis/responsive/index.dart';
import '../index.dart';

class AddStoryTypeSheet extends StatelessWidget {
  final void Function(StoryPublishType type) onSelect;

  const AddStoryTypeSheet({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: ResponsiveDimensions.h(12),
        left: ResponsiveDimensions.w(12),
        right: ResponsiveDimensions.w(12),
        bottom: ResponsiveDimensions.h(12) + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.bottomSheetBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveDimensions.w(18)),
        ),
        border: Border.all(color: AppColors.neutral900, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          SizedBox(height: ResponsiveDimensions.h(10)),
          _buildHeader(),
          SizedBox(height: ResponsiveDimensions.h(12)),
          _buildOptions(),
          SizedBox(height: ResponsiveDimensions.h(6)),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: ResponsiveDimensions.w(42),
      height: ResponsiveDimensions.h(5),
      decoration: BoxDecoration(
        color: AppColors.neutral800,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'اختر نوع القصة',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(15),
              fontWeight: FontWeight.bold,
              color: AppColors.neutral200,
            ),
          ),
        ),
        InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveDimensions.w(6)),
            child: Icon(
              Icons.close_rounded,
              size: ResponsiveDimensions.w(20),
              color: AppColors.neutral400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    return Column(
      children: [
        StoryPublishOptionTile(
          icon: Icons.text_fields_rounded,
          title: 'نص',
          onTap: () => onSelect(StoryPublishType.text),
        ),
        _divider(),
        StoryPublishOptionTile(
          icon: Icons.image_outlined,
          title: 'صورة',
          onTap: () => onSelect(StoryPublishType.image),
        ),
        _divider(),
        StoryPublishOptionTile(
          icon: Icons.shopping_bag_outlined,
          title: 'منتج',
          onTap: () => onSelect(StoryPublishType.product),
        ),
        _divider(),
        StoryPublishOptionTile(
          icon: Icons.videocam_outlined,
          title: 'فيديو',
          onTap: () => onSelect(StoryPublishType.video),
        ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.w(8)),
      child: Divider(
        height: ResponsiveDimensions.h(1),
        thickness: 1,
        color: AppColors.neutral900,
      ),
    );
  }
}
