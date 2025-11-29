import 'package:flutter/material.dart';

class ServicesDetail extends StatelessWidget {
  const ServicesDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [Image.asset("assets/images/png/Rectangle 124.png")],
          ),
        ),
      ),
    );
  }
}
