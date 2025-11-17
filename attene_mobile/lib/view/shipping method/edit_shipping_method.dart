import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';

class EditShippingMethod extends StatelessWidget {
  const EditShippingMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MaterialButton(
            onPressed: () {},
            child: Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.primary400,
              ),
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.ice_skating, color: AppColors.light1000,),
                  Text("data", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: AppColors.light1000)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
