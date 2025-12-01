import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';

import 'Chat_Interested.dart';
import 'Chat_Unread.dart';
import 'chat_massege.dart';

class ChatAll extends StatelessWidget {
  const ChatAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "الدردشه",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: AppColors.light1000,
                height: 55,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ابحث عن دردشة ...',
                    prefixIcon: IconButton(
                      icon: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: AppColors.primary400,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xff2176ff),
                    ),
                    child: MaterialButton(
                      onPressed: () {},
                      child: const Text(
                        "الكل",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const chat_unreade(),
                          ),
                        );
                      },
                      child: const Text(
                        "غير مقروء",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatInterested(),
                          ),
                        );
                      },
                      child: const Text(
                        "المهتمين",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.grey, height: 15),
              const SizedBox(height: 20),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatMassege(),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage("assets/image/1.png"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 3, left: 3),
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Albert Flores",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 30),
                                Text(
                                  "2صباحا",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "السعر شامل التوصيل",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemCount: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
