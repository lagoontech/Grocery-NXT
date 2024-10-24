import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Widgets/custom_button.dart';
import 'package:lottie/lottie.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          
          Lottie.asset(
              "assets/animations/order_success.json",
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
                "Back to home",
                style: TextStyle(color: Colors.white),
              ))
          
        ],
      ),
    );
  }
}
