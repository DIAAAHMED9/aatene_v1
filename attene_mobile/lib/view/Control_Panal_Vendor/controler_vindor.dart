import 'package:attene_mobile/utlis/colors/app_color.dart';
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
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/png/aatene_logo_horiz.png"),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          spacing: 10,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              child: Image.asset(
                                "assets/images/png/aatene_logo_horiz.png",
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "jerusalemlll",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "فلسطين ، الخليل",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary100,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  width: 2,
                                  color: AppColors.light1000,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.mode_edit_outlined, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                spacing: 15,
                children: [
                  MaterialButton(
                    onPressed: () {},
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(
                          Icons.dashboard_outlined,
                          size: 25,
                          color: AppColors.primary400,
                        ),
                        Text(
                          "لوحة القيادة",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColors.neutral800,
                    radius: BorderRadius.circular(5),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(
                          Icons.dashboard_outlined,
                          size: 25,
                          color: AppColors.primary400,
                        ),
                        Text(
                          "لوحة القيادة",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColors.neutral800,
                    radius: BorderRadius.circular(5),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(
                          Icons.dashboard_outlined,
                          size: 25,
                          color: AppColors.primary400,
                        ),
                        Text(
                          "لوحة القيادة",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColors.neutral800,
                    radius: BorderRadius.circular(5),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(
                          Icons.dashboard_outlined,
                          size: 25,
                          color: AppColors.primary400,
                        ),
                        Text(
                          "لوحة القيادة",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColors.neutral800,
                    radius: BorderRadius.circular(5),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(
                          Icons.dashboard_outlined,
                          size: 25,
                          color: AppColors.primary400,
                        ),
                        Text(
                          "لوحة القيادة",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColors.neutral800,
                    radius: BorderRadius.circular(5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      //
    );
  }
}
