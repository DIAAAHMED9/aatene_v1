import '../../../general_index.dart';
import '../controller/search_controller.dart';
import '../widget/big_search_filter.dart';
import '../widget/search_type.dart' hide SearchType;

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: TextFiledAatene(
                        isRTL: isRTL,
                        hintText: "hintText",
                        textInputAction: TextInputAction.done,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            /// بحث عن الاشخاص والعناصر
                            // Future<void> openSearchTypeSheet() async {
                            //   final result = await Get.bottomSheet<SearchType>(
                            //     const SearchTypeBottomSheet(),
                            //     backgroundColor: Colors.transparent,
                            //     isScrollControlled: true,
                            //   );
                            //
                            //   if (result != null) {
                            //     debugPrint('Selected Type: $result');
                            //   }
                            // }

                            showModalBottomSheet(
                              context: context,
                              builder: (context) => FilterBottomSheet(),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Container(
                              width: 50,
                              height: 30,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primary400,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: AppColors.light1000,
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.light1000,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ), textInputType: TextInputType.name,
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 2,
                  color: AppColors.neutral600Alpha10.withOpacity(0.2),
                ),
                Row(
                  children: [
                    Text("البحث الأخير", style: getMedium(fontSize: 14)),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete_outline,
                        color: AppColors.error300,
                      ),
                    ),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primary50,
                      ),
                      child: Center(
                        child: Text(
                          "ملابس أطفال",
                          style: getMedium(
                            fontSize: 12,
                            color: AppColors.primary500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text("أهم عمليات البحث", style: getMedium(fontSize: 14)),
                Wrap(children: [ProductCard()]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
