import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/SplashScreen/Controller/splash_controller.dart';
import 'package:grocery_nxt/Widgets/custom_button.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});

   SplashController vc = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (vc) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: !vc.networkError?Column(
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

              const CupertinoActivityIndicator(
                color: Colors.green,
              )

            ],
          ): Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Lottie.asset('assets/animations/no_network.json'),

                SizedBox(height: 24.h),

                Text(
                    "Check Your Interenet Connection",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                    ),
                )

              ],
            ),
          )
        );
      }
    );
  }
}
