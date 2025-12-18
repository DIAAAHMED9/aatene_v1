import 'package:flutter/material.dart';

class HomeControl extends StatelessWidget {
  const HomeControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: double.infinity,
        height: 267,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F8),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child:  Stack(
          children: [
            Image.asset("assets/images/png/Rectangle 124.png"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/images/png/aatene_logo_horiz.png"),
            ),
          ],
        ),
      ),
    );
  }
}
