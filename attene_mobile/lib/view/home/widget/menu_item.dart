import 'package:attene_mobile/component/index.dart';
import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;

  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: getRegular(fontSize: 14) ,
      ),
      onTap: onTap,
    );
  }
}
