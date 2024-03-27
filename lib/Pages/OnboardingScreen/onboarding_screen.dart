import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/OnboardingScreen/Controller/onboarding_controller.dart';
import 'package:grocery_nxt/Pages/OnboardingScreen/Widgets/onboarding_content.dart';

class OnboardingScreen extends StatelessWidget {
   OnboardingScreen({super.key});

   OnboardingController vc = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [

          OnboardingContent(),

          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
                "assets/images/onboarding_image_1.png",
            ),
          ),
          
          Positioned(
             right: 30.h,
              top: 40.h,
              child: Image.asset(
                  "assets/images/leaf.png",
                  width: MediaQuery.of(context).size.width*0.1,
              )),

          Positioned(
             left: 30.h,
              top: MediaQuery.of(context).size.height*0.6,
              child: Image.asset(
                  "assets/images/leaf_2.png",
                  width: MediaQuery.of(context).size.width*0.08,
              )),

          Positioned(
              right: 0.w,
              top: MediaQuery.of(context).size.height*0.5,
              child: Image.asset(
                  "assets/images/leaf_blurred.png",
                  width: MediaQuery.of(context).size.width*0.1,
              )),


        ],
      ),
    );
  }
}
