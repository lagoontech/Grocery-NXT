import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/HomeProductsView/home_products_view.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/top_content.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

   HomeController hc = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            TopContent(),

            SizedBox(height: 52.h),

            HomeProductsView()

          ],
        ),
      ),
    );
  }
}
