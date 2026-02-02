import 'package:attene_mobile/general_index.dart';

import '../controller/search_controller.dart';
import '../widget/big_search_filter.dart';
import '../widget/search_type.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _history = ['ملابس أطفال', 'براند', 'ديكور منزلي'];

  String? _removedItem;
  int? _removedIndex;

  void _addSearch() {
    final text = _searchController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _history.insert(0, text);
    });

    _searchController.clear();
  }

  void _removeItem(int index) {
    setState(() {
      _removedItem = _history[index];
      _removedIndex = index;
      _history.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'تم حذف العنصر',
          style: getBold(color: AppColors.light1000),
        ),
        action: SnackBarAction(
          label: 'تراجع',
          textColor: AppColors.primary50,
          onPressed: () {
            if (_removedItem != null && _removedIndex != null) {
              setState(() {
                _history.insert(_removedIndex!, _removedItem!);
              });
            }
          },
        ),
      ),
    );
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('مسح الكل'),
        content: const Text('هل أنت متأكد من مسح جميع عمليات البحث؟'),
        actions: [
          AateneButton(
            onTap: () {
              setState(() => _history.clear());
              Get.back();
            },
            buttonText: 'تأكيد',
            color: AppColors.primary400,
            textColor: AppColors.light1000,
            borderColor: AppColors.primary400,
          ),
          SizedBox(height: 10),
          AateneButton(
            onTap: () => Get.back(),
            buttonText: 'الغاء',
            color: AppColors.light1000,
            textColor: AppColors.primary400,
            borderColor: AppColors.primary400,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFiledAatene(
                      isRTL: isRTL,
                      hintText: "ابحث عن اي شيء في اعطيني",
                      textInputAction: TextInputAction.done,
                      controller: _searchController,
                      onSubmitted: (_) => _addSearch(),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Container(
                          width: 65,
                          decoration: BoxDecoration(
                            color: AppColors.primary400,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: IconButton(
                            icon: Row(
                              spacing: 7,
                              children: [
                                Icon(Icons.search, color: Colors.white),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            onPressed: () {
                              SearchTypeBottomSheet();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('البحث الأخير', style: getBold(fontSize: 18)),
                  TextButton(
                    onPressed: _history.isEmpty ? null : _clearAll,
                    child: Text(
                      'امسح الكل',
                      style: getMedium(fontSize: 12, color: AppColors.error200),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  _history.length,
                  (index) => AnimatedScale(
                    scale: 1,
                    duration: const Duration(milliseconds: 300),
                    child: AnimatedOpacity(
                      opacity: 1,
                      duration: const Duration(milliseconds: 300),
                      child: Chip(
                        backgroundColor: AppColors.primary50,
                        label: Text(_history[index]),
                        deleteIcon: const Icon(Icons.close, size: 15),
                        onDeleted: () => _removeItem(index),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}