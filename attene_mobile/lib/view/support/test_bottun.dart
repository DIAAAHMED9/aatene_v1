import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainHome1 extends StatefulWidget {
  const MainHome1({super.key});

  @override
  State<MainHome1> createState() => _MainHome1State();
}

class _MainHome1State extends State<MainHome1> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // قائمة الصفحات
  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const StudyPage(),
    Container(), // صفحة فارغة لأن الزر الفعلي هو زر الزائد
  ];

  // العناوين العربية
  final List<String> _pageTitles = ['الرئيسية', 'البحث', 'دراسة', ''];

  void _onItemTapped(int index) {
    // إذا كان المؤشر على زر الزائد (الموقع 3)، لا تفعل شيئاً
    if (index == 3) return;

    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // محتوى الصفحات
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),

          // Custom Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavigation(
              selectedIndex: _selectedIndex,
              onItemSelected: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // عناصر التنقل
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // عنصر الرئيسية
              _buildNavItem(
                index: 0,
                icon: 'assets/images/svg_images/home-2.svg',
                label: 'الرئيسية',
              ),

              // عنصر البحث
              _buildNavItem(
                index: 1,
                icon: 'assets/images/svg_images/Calendar12.svg',
                label: 'البحث',
              ),

              // مسافة لزر الزائد
              const SizedBox(width: 80),

              // عنصر الدراسة
              _buildNavItem(
                index: 2,
                icon: 'assets/images/svg_images/massages.svg',
                label: 'دراسة',
              ),

              // عنصر المستخدم
              _buildNavItem(
                index: 3,
                icon: 'assets/images/svg_images/about4.svg',
                label: 'USER',
              ),
            ],
          ),

          // زر الزائد العائم في المنتصف
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 35,
            bottom: 25,
            child: GestureDetector(
              onTap: () {
                // يمكن إضافة وظيفة لزر الزائد هنا
                print('زر الزائد تم النقر عليه');
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF5B67CA),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5B67CA).withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.white, size: 30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String icon,
    required String label,
  }) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // أيقونة SVG مع تأثير التحديد
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: index == 3
                ? const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  )
                : SvgPicture.asset(
                    icon,
                    width: 24,
                    height: 24,
                    color: isSelected ? const Color(0xFF5B67CA) : Colors.grey,
                  ),
          ),

          const SizedBox(height: 4),

          // نص العنصر
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFF5B67CA) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// صفحات التطبيق
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'الرئيسية',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'البحث',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class StudyPage extends StatelessWidget {
  const StudyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'دراسة',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
