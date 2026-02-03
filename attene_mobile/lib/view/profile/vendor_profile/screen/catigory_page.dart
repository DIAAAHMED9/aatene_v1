import 'package:flutter/material.dart';

import '../../../../general_index.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  int selectedIndex = 0;

  final List<Map<String, String>> categories = [
    {'title': 'فساتين', 'image': 'https://i.imgur.com/QCNbOAo.png'},
    {'title': 'جينز', 'image': 'https://i.imgur.com/5M0pXQy.png'},
    {'title': 'قمصان', 'image': 'https://i.imgur.com/3yM6GQy.png'},
  ];

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "الاقسام",
          style: getBold(color: AppColors.neutral100, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[100],
            ),
            child: Icon(Icons.arrow_back, color: AppColors.neutral100),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 5,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "قسم الملابس",
                    textAlign: TextAlign.center,
                    style: getMedium(fontSize: 12, color: AppColors.neutral500),
                  ),
                  Text(
                    "فساتين",
                    textAlign: TextAlign.center,

                    style: getBold(fontSize: 32, color: AppColors.neutral100),
                  ),
                  Text(
                    "271 عنصر",
                    textAlign: TextAlign.center,

                    style: getMedium(fontSize: 12, color: AppColors.neutral500),
                  ),
                ],
              ),
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: TextFiledAatene(
                    isRTL: isRTL,
                    hintText: "اكتب هنا",
                    textInputAction: TextInputAction.done,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(5),
                      child: CircleAvatar(
                        backgroundColor: AppColors.primary400,
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                    textInputType: TextInputType.name,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: AppColors.primary50,
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/images/svg_images/Filter.svg',
                      semanticsLabel: 'My SVG Image',
                      height: 18,
                      width: 18,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryItem(
                    title: categories[index]['title']!,
                    imageUrl: categories[index]['image']!,
                    isSelected: selectedIndex == index,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  );
                },
              ),
            ),

            ShowAllTitle(title: "title"),
          ],
        ),
      ),
    );
  }
}

/// Category Item Widget
class CategoryItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE8EFF7) : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              /// Circle Avatars (بدون تغيير)
              Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary400,
                  ),
                  Positioned(
                    left: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),

              /// Title
              Text(
                title,
                style: getMedium(
                  color: isSelected
                      ? AppColors.primary400
                      : AppColors.neutral100,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
