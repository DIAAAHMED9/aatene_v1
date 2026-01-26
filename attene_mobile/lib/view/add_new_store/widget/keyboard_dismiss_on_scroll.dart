import 'package:flutter/material.dart';

class KeyboardDismissOnScroll extends StatelessWidget {
  final Widget child;

  const KeyboardDismissOnScroll({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            FocusScope.of(context).unfocus();
          }
          return false;
        },
        child: child,
      ),
    );
  }
}
