import '../../../general_index.dart';

class FollowersSearchField extends StatelessWidget {
  const FollowersSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FollowersController>();
    final isRTL = LanguageUtils.isRTL;

    return TextFiledAatene(
      controller: controller.searchController,
      isRTL: isRTL,
      hintText: 'بحث',
      filled: true,
      onChanged: controller.onSearch,
      suffixIcon: Padding(
        padding: const EdgeInsets.all(5),
        child: CircleAvatar(
          backgroundColor: AppColors.primary400,
          child: const Icon(Icons.search, color: Colors.white),
        ),
      ),
      textInputAction: TextInputAction.done, textInputType: TextInputType.name,
    );
  }
}
