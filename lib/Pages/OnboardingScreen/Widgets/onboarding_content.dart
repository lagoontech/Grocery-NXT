import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:grocery_nxt/Pages/LoginScreen/login_screen.dart';
import 'package:grocery_nxt/Pages/OnboardingScreen/Controller/onboarding_controller.dart';
import 'package:grocery_nxt/Widgets/custom_button.dart';
import 'package:lottie/lottie.dart';
import '../../../Constants/app_colors.dart';

class OnboardingContent extends StatelessWidget {
   OnboardingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.6,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.primaryColor.withOpacity(0.0),
          ],
          radius: 0.7,
          focalRadius: 0.1,
          center: Alignment.center,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(
            height: MediaQuery.of(context).size.height*0.1,
          ),

          Center(
            child: Image.asset(
              "assets/images/gnxt_logo.png",
              width: MediaQuery.of(context).size.width*0.6,
            ),
          ),

          SizedBox(height: 20.h),

          SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              child: AutoSizeText(
                "Get your groceries delivered to your home",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700
                ),
              )
          ),

          SizedBox(height: 20.h),

          SizedBox(
              width: MediaQuery.of(context).size.width*0.7,
              child: Text(
                "The best delivery app in town for delivering your daily fresh groceries",
                textAlign: TextAlign.center,
                maxLines: null,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500
                ),
              )
          ),

          GetBuilder<OnboardingController>(
            builder: (vc) {
              return SizedBox(
                  height: 60.h);
            }
          ),

          GetBuilder<OnboardingController>(
            builder: (vc) {
              return CustomButton(
                text: "Shop Now",
                onTap: (){
                  vc.isSubmitting = true;
                  vc.update();
                  Future.delayed(const Duration(milliseconds: 300),(){
                    Get.to(()=> LoginScreen());
                  });
                },
              );
            }
          )

        ],
      ),
    );
  }
}
