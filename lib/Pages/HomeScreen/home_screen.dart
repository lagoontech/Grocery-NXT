import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/top_content.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

   HomeController hc = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [

          TopContent(),



        ],
      ),
    );
  }
}
