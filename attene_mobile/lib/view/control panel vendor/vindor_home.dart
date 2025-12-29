import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';

class VindorHome extends StatelessWidget {
  const VindorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "لوحة القيادة",
          style:getBold( color: AppColors.neutral100,
            fontSize: 20,) ,
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[300],
            ),
            child: Icon(Icons.arrow_back, color: AppColors.primary500),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Image.asset("assets/images/png/aatene_logo_horiz.png"),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.primary500,
                      ),
                      width: 40,
                      height: 30,
                      child: IconButton(
                        icon: Icon(Icons.search_rounded),
                        iconSize: 25,
                        onPressed: () {},
                        splashColor: Colors.black,
                        color: AppColors.light1000,
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.neutral100),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.adb_sharp),
                  Text("المحتوي (الشهر الحالي)"),
                  Spacer(),
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      width: 160,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: AppColors.neutral700,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          spacing: 10,
                          children: [
                            Icon(Icons.calendar_month_outlined),
                            Text("الشهر الحالي", style:getRegular(),),
                            Icon(Icons.keyboard_arrow_down_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 50,
                children: [
                  Expanded(
                    child: Container(
                      height: 150,
                      color: Colors.redAccent,
                      child: Text("data"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      color: AppColors.neutral100,
                      child: Text("data"),
                    ),
                  ),
                ],
              ),
              Text("data"),
              Divider(color: AppColors.neutral700, endIndent: 4),
            ],
          ),
        ),
      ),
    );
  }
}