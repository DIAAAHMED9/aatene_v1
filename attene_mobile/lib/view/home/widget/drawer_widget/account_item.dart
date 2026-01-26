
import '../../../../general_index.dart';

class DrawerAccountItem extends StatelessWidget {
  final String name;
  final String? avatar;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerAccountItem({
    super.key,
    required this.name,
    this.avatar,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: (avatar != null && avatar!.trim().isNotEmpty)
                  ? NetworkImage(avatar!.trim())
                  : null,
              child: (avatar == null || avatar!.trim().isEmpty)
                  ? const Icon(Icons.store, size: 18)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style:getMedium(   fontSize: 14,
                  fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,) ,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, size: 18),
          ],
        ),
      ),
    );
  }
}