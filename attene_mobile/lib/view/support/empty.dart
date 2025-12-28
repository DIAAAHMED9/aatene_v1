import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: 50,
        children: [
          Text("ضياء اعطيني", style: getBlack(color: Colors.black, fontSize: 40)),
          Text("ضياءءءء اعطيني", style: TextStyle(fontSize: 40)),
        ],
      ),
    );
  }
}
