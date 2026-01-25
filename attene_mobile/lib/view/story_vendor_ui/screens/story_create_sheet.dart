import 'package:flutter/material.dart';
import '../theme/story_vendor_theme.dart';
import 'text_story_screen.dart';
import 'image_picker_story_screen.dart';
import 'product_story_screen.dart';

class StoryCreateSheet {
  /// Opens create sheet and returns `true` if a story was successfully created.
  static Future<bool?> open(BuildContext context) async {
    final String? choice = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SheetBody(),
    );

    if (choice == null) return false;

    switch (choice) {
      case 'text':
        return await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => const TextStoryScreen())) ?? false;
      case 'images':
        return await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => const ImagePickerStoryScreen())) ?? false;
      case 'product':
        // Product story is still demo-only for now.
        await Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductStoryScreen()));
        return false;
      default:
        return false;
    }
  }
}

class _SheetBody extends StatelessWidget {
  const _SheetBody();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: StoryVendorTheme.sheetRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 16),
              const Text('إنشاء قصة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 18),
              _tile(
                context,
                title: 'نص',
                icon: Icons.text_fields,
                onTap: () {
                  Navigator.pop(context, 'text');
                },
              ),
              _tile(
                context,
                title: 'صور',
                icon: Icons.image_outlined,
                onTap: () {
                  Navigator.pop(context, 'images');
                },
              ),
              _tile(
                context,
                title: 'عرض منتج',
                icon: Icons.inventory_2_outlined,
                onTap: () {
                  Navigator.pop(context, 'product');
                },
              ),
              _tile(
                context,
                title: 'نشر قصة مميزة',
                icon: Icons.star_border,
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Align(
        alignment: Alignment.centerRight,
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ),
      trailing: Icon(icon, size: 26, color: Colors.black),
      onTap: onTap,
    );
  }
}
