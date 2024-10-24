import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/Payment%20Screen/Controller/payment_failed_controller.dart';
import 'package:grocery_nxt/Pages/Payment%20Screen/Models/order_success_response.dart';
import 'package:lottie/lottie.dart';
import '../../Widgets/custom_button.dart';
import '../DashBoardView/Controller/dashboard_controller.dart';

class PaymentFailed extends StatelessWidget {
  PaymentFailed(
      {super.key,
      this.successResponse,
      this.orderId,
      this.amount,
      this.subTotal});

  DashboardController dc = Get.find<DashboardController>();
  PaymentFailedController vc = Get.put(PaymentFailedController());
  OrderSuccessResponse? successResponse;
  int? orderId;
  int? amount;
  int? subTotal;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (vc.orderId == null) {
        vc.orderId = orderId;
        vc.amount = amount;
        vc.successResponse = successResponse;
      }
    });
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.w),
                border:
                    Border.all(color: AppColors.primaryColor.withOpacity(0.4))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    "Order Id - ${orderId}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SummaryItem(title: "Order Id", value: "${orderId}"),
                  SummaryItem(title: "Total", value: "\u{20B9} ${amount}"),
                  SizedBox(height: 20.h),
                  Lottie.asset(
                    "assets/animations/payment_failed.json",
                    repeat: false,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60.w),
                    child: Row(
                      children: [
                        !vc.confirmingPayment
                            ? Expanded(
                              child: CustomButton(
                                  onTap: () {
                                    vc.retryPayment();
                                  },
                                  child: Text(
                                    "Retry payment",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12.sp),
                                  )),
                            )
                            : AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    'Confirming Payment',
                                    textStyle: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                    speed: const Duration(milliseconds: 50),
                                  ),
                                ],
                                totalRepeatCount: 8,
                                pause: const Duration(milliseconds: 10),
                                displayFullTextOnTap: true,
                                stopPauseOnTap: true,
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100.h),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      dc.changePage(0);
                    },
                    child: Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                            color: Colors.black87, shape: BoxShape.circle),
                        child: Center(
                            child:
                                Icon(Icons.arrow_back, color: Colors.white))),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
        ],
      ),
    );
  }

  //
  Widget SummaryItem({String title = "", String value = ""}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Text(value)],
      ),
    );
  }
}
