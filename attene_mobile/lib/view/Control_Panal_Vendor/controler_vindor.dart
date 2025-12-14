import 'package:flutter/material.dart';

class ControllerVendor extends StatelessWidget {
  const ControllerVendor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset("assets/images/png/Rectangle 124.png"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/png/aatene_logo_horiz.png"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}