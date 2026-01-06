import 'package:attene_mobile/component/index.dart';
import 'package:flutter/material.dart';

class DrawerAccountItem extends StatelessWidget {
  final String name;
  final String avatar;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerAccountItem({
    super.key,
    required this.name,
    required this.avatar,
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
              backgroundImage: NetworkImage(avatar),
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
