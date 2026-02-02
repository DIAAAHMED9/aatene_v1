import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رياضة الجمال والاكسسوارات',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Tajawal',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ShoppingHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ShoppingHomeScreen extends StatefulWidget {
  const ShoppingHomeScreen({super.key});

  @override
  State<ShoppingHomeScreen> createState() => _ShoppingHomeScreenState();
}

class _ShoppingHomeScreenState extends State<ShoppingHomeScreen> {
  final PageController _bannerController = PageController(
    viewportFraction: 0.9,
  );
  int _currentBannerIndex = 0;

  // بيانات العروض البانر
  final List<BannerItem> _banners = [
    BannerItem(image: 'assets/banner1.jpg', title: 'عرض خاص'),
    BannerItem(image: 'assets/banner2.jpg', title: 'خصومات تصل إلى 50%'),
    BannerItem(image: 'assets/banner3.jpg', title: 'عروض جديدة'),
  ];

  // بيانات الفئات
  final List<CategoryItem> _categories = [
    CategoryItem(
      name: 'عرض الكل',
      icon: Icons.all_inclusive,
      color: Colors.blue,
    ),
    CategoryItem(
      name: 'جديد في أوكازيُون',
      icon: Icons.new_releases,
      color: Colors.red,
    ),
    CategoryItem(name: 'فساتين', icon: Icons.checkroom, color: Colors.pink),
    CategoryItem(
      name: 'هوديس وبلوزات',
      icon: Icons.house,
      color: Colors.purple,
    ),
    CategoryItem(name: 'أحذية', icon: Icons.shopping_bag, color: Colors.brown),
    CategoryItem(name: 'إكسسوارات', icon: Icons.diamond, color: Colors.amber),
    CategoryItem(name: 'ملابس رياضية', icon: Icons.sports, color: Colors.green),
    CategoryItem(name: 'حقائب', icon: Icons.work, color: Colors.deepOrange),
  ];

  // بيانات المنتجات
  final List<ProductItem> _products = [
    ProductItem(
      name: 'فستان زهري',
      price: '199 ر.س',
      image: 'assets/dress1.jpg',
    ),
    ProductItem(
      name: 'هودي أزرق',
      price: '149 ر.س',
      image: 'assets/hoodie1.jpg',
    ),
    ProductItem(
      name: 'فستان أسود',
      price: '249 ر.س',
      image: 'assets/dress2.jpg',
    ),
    ProductItem(
      name: 'بلوزة بيضاء',
      price: '99 ر.س',
      image: 'assets/blouse1.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // شريط العنوان
              _buildAppBar(),

              // قسم البانر
              _buildBannerSection(),

              // قسم الفئات
              _buildCategoriesSection(),

              // قسم المنتجات
              _buildProductsSection(),
            ],
          ),
        ),
      ),
    );
  }

  // شريط التطبيق
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر القائمة
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu, size: 28)),

          // العنوان الرئيسي
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'رياضة الجمال والاكسسوارات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                'ملابس',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),

          // صورة المستخدم
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // قسم البانر
  Widget _buildBannerSection() {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _bannerController,
              itemCount: _banners.length,
              onPageChanged: (index) {
                setState(() {
                  _currentBannerIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue[50],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // صورة البانر
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blue[100],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.blue,
                            ),
                          ),
                        ),

                        // نص البانر
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Text(
                            _banners[index].title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // مؤشر الصفحات
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentBannerIndex == index
                      ? Colors.blue
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // قسم الفئات
  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان قسم الفئات
          Text(
            'الفئات',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          const SizedBox(height: 16),

          // قائمة الفئات
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    children: [
                      // دائرة الفئة
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _categories[index].color.withOpacity(0.2),
                        ),
                        child: Center(
                          child: Icon(
                            _categories[index].icon,
                            size: 30,
                            color: _categories[index].color,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // اسم الفئة
                      SizedBox(
                        width: 80,
                        child: Text(
                          _categories[index].name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // قسم المنتجات
  Widget _buildProductsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان قسم المنتجات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المنتجات المميزة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'عرض الكل',
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // قائمة المنتجات
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // صورة المنتج
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          color: Colors.grey[200],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.shopping_bag,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // اسم المنتج
                            Text(
                              _products[index].name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 4),

                            // سعر المنتج
                            Text(
                              _products[index].price,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// نموذج بيانات البانر
class BannerItem {
  final String image;
  final String title;

  BannerItem({required this.image, required this.title});
}

// نموذج بيانات الفئة
class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem({required this.name, required this.icon, required this.color});
}

// نموذج بيانات المنتج
class ProductItem {
  final String name;
  final String price;
  final String image;

  ProductItem({required this.name, required this.price, required this.image});
}
