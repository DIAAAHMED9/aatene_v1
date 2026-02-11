import 'package:attene_mobile/general_index.dart' hide SearchController;
import 'package:attene_mobile/view/search/controller/search_controller.dart';
import 'package:attene_mobile/view/search/widget/big_search_filter.dart';

class SearchTypeBottomSheet extends StatelessWidget {
  const SearchTypeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<SearchController>();

    return _AnimatedSheet(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'البحث عن طريق',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),

            _buildRadioTile(
              title: 'منتجات',
              value: SearchType.products,
              groupValue: searchController.selectedType.value,
              onChanged: (type) {
                if (type != null) {
                  searchController.changeSearchType(type);
                  Get.back();
                  _showFilterBottomSheet(context, type);
                }
              },
            ),
            _buildRadioTile(
              title: 'متاجر',
              value: SearchType.stores,
              groupValue: searchController.selectedType.value,
              onChanged: (type) {
                if (type != null) {
                  searchController.changeSearchType(type);
                  Get.back();
                  _showFilterBottomSheet(context, type);
                }
              },
            ),
            _buildRadioTile(
              title: 'خدمات',
              value: SearchType.services,
              groupValue: searchController.selectedType.value,
              onChanged: (type) {
                if (type != null) {
                  searchController.changeSearchType(type);
                  Get.back();
                  _showFilterBottomSheet(context, type);
                }
              },
            ),
            _buildRadioTile(
              title: 'مستخدمين',
              value: SearchType.users,
              groupValue: searchController.selectedType.value,
              onChanged: (type) {
                if (type != null) {
                  searchController.changeSearchType(type);
                  Get.back();
                  _showFilterBottomSheet(context, type);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile({
    required String title,
    required SearchType value,
    required SearchType groupValue,
    required void Function(SearchType?) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Radio<SearchType>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppColors.primary400,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(title, style: getBold(fontSize: 14)),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, SearchType type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(searchType: type),
    );
  }
}

class _AnimatedSheet extends StatefulWidget {
  const _AnimatedSheet({required this.child});
  final Widget child;

  @override
  State<_AnimatedSheet> createState() => _AnimatedSheetState();
}

class _AnimatedSheetState extends State<_AnimatedSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}