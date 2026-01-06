import 'package:attene_mobile/component/index.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';

import '../../../general_index.dart';
import '../widget/aatene_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AateneDrawer(),
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5.0, left: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(color: AppColors.primary50),
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/svg_images/Heart.svg',
                    semanticsLabel: 'My SVG Image',
                    height: 22,
                    width: 22,
                  ),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 5.0, left: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(color: AppColors.primary50),
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/svg_images/Notification.svg',
                    semanticsLabel: 'My SVG Image',
                    height: 22,
                    width: 22,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('أهلاً, 👋', style: getRegular(fontSize: 14)),
            Text('اسم المستخدم', style: getMedium()),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(child: Column(
        children: [
          Container(),
        ],
      )),
    );
  }
}
