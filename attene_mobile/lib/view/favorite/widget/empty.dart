import 'package:attene_mobile/general_index.dart';

class CustomMenuWidget extends StatelessWidget {
  const CustomMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      // تخصيص شكل القائمة (الحواف المنحنية واللون)
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 10,
      // ضبط مكان ظهور القائمة بالنسبة للزر
      offset: const Offset(0, 50),
      icon: const Icon(Icons.more_vert, color: AppColors.primary300),
      onSelected: (value) {
        print("Selected: $value");
      },
      itemBuilder: (BuildContext context) {
        return [
          _buildMenuItem(
            value: 'rename',
            text: 'إعادة تسمية',
            url: 'assets/images/svg_images/Edit1.svg',
          ),
          _buildDivider(),
          _buildMenuItem(
            value: 'private',
            text: 'اجعلها مخصصة',
            url: 'assets/images/svg_images/Lock.svg',
          ),
          _buildDivider(),
          _buildMenuItem(
            value: 'share',
            text: 'مشاركة',
            url: 'assets/images/svg_images/Send.svg',
          ),
          _buildDivider(),
          _buildMenuItem(
            value: 'delete',
            text: 'حذف المجموعة',
            url: 'assets/images/svg_images/Delete.svg',
          ),
        ];
      },
    );
  }

  // ودجت لبناء عنصر القائمة بشكل موحد
  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required String text,
    required String url,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(url, width: 16, height: 16, fit: BoxFit.cover),
          Text(text, style: getMedium()),
        ],
      ),
    );
  }

  // ودجت لرسم الخط الفاصل الخفيف بين العناصر
  PopupMenuEntry<String> _buildDivider() {
    return const PopupMenuDivider(height: 1);
  }
}
