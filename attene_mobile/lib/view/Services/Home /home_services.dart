import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';

class HomeServices extends StatefulWidget {
  const HomeServices({super.key});

  @override
  State<HomeServices> createState() => _HomeServicesState();
}

class _HomeServicesState extends State<HomeServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ExpansionTile(
            maintainState: true,
            shape: StadiumBorder(),
            title: Row(
              spacing: 10,
              children: [
                Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      topLeft: Radius.circular(100),
                    ),
                    color: AppColors.primary100,
                  ),
                  child: Icon(Icons.card_giftcard, color: AppColors.primary400),
                ),
                Text("data"),
              ],
            ),
            children: [Text("data")],
          ),
        ),
      ),
    );
  }
}
