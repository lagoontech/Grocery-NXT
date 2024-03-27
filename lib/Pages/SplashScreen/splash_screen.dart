import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/SplashScreen/Controller/splash_controller.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});

   SplashController vc = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Center(
            child: Image.asset(
              'assets/images/gnxt_logo.png',
               width: MediaQuery.of(context).size.width*0.5,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 20.h),

          CupertinoActivityIndicator(
            color: Colors.green,
          )

        ],
      ),
    );
  }
}
