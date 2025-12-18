import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';

class ControllerVendor extends StatelessWidget {
  const ControllerVendor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset("assets/images/png/controler_bacground.png"),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Image.asset(
                          "assets/images/png/aatene_logo_horiz.png",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(radius: 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "jerusalemlll",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  " فلسطين ، الخليل",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppColors.primary100
                              ),
                              child: Center(child: IconButton(onPressed: (){}, icon: Icon(Icons.mode_edit_outline_outlined,color: AppColors.primary400,))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
