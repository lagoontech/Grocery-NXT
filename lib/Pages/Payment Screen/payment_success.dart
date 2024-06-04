import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../Widgets/custom_button.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Lottie.asset(
            "assets/animations/payment_ok.json",
            repeat: false,
          ),

          SizedBox(height: 20.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Your Order Has Been Accepted",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 40.h),

          CustomButton(
              onTap: (){
                Get.back();
              },
              child: const Text(
                "Continue Shopping",
                style: TextStyle(color: Colors.white),
              ))

        ],
      ),
    );
  }
}
