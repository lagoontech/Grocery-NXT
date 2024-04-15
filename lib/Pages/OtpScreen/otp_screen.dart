import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/DashBoardView/dashboard_view.dart';
import 'package:grocery_nxt/Pages/HomeScreen/home_screen.dart';
import 'package:grocery_nxt/Pages/OtpScreen/Controller/otp_controller.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:numpad/numpad.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../Widgets/custom_button.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  OtpController vc = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 6,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Center(
                    child: Image.asset(
                      "assets/images/gnxt_logo.png",
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: AutoSizeText(
                        "Enter your OTP",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 22.sp, fontWeight: FontWeight.w700),
                      )),
                  SizedBox(height: 20.h),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        "4 Digit OTP",
                        textAlign: TextAlign.center,
                        maxLines: null,
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600),
                      )),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: PinCodeTextField(
                      length: 4,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      readOnly: true,
                      pinTheme: PinTheme(
                        inactiveFillColor: Colors.grey.shade200,
                        borderWidth: 0,
                        fieldOuterPadding:
                            EdgeInsets.symmetric(horizontal: 2.w),
                        activeBorderWidth: 0,
                        inactiveBorderWidth: 0,
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 50,
                        activeFillColor: Colors.grey.shade200,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.white,
                      enableActiveFill: true,
                      controller: vc.otpTEC,
                      onCompleted: (v) {
                        print("Completed");
                      },
                      pastedTextStyle: TextStyle(color: AppColors.primaryColor),
                      onChanged: (value) {},
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        return true;
                      },
                      appContext: context,
                    ),
                  ),
                  SizedBox(height: 48.h),
                  GetBuilder<OtpController>(builder: (vc) {
                    return CustomButton(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: vc.checkingOtp
                          ? CustomCircularLoader()
                          : const Text(
                              "Continue",
                              style: TextStyle(color: Colors.white),
                            ),
                      onTap: () {
                        vc.checkOTP();
                        //Get.to(()=> DashboardView());
                      },
                    );
                  }),
                  SizedBox(height: 8.h),
                ],
              )),

          Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(16)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: NumPad(
                      backgroundColor: const Color(0xfff3f5f7),
                      buttonSize: 12,
                      mainAxisSpacing: 12,
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                      ),
                      numItemDecoration: const BoxDecoration(),
                      onTap: (val) {
                        if (val == 99) {
                          if (vc.otpTEC.text.isEmpty) {
                            return;
                          }
                          vc.otpTEC.text = vc.otpTEC.text
                              .substring(0, vc.otpTEC.text.length - 1);
                          return;
                        }
                        vc.otpTEC.text = vc.otpTEC.text + val.toString();
                        print(vc.otpTEC.text);
                      }),
                ),
              ))
        ],
      ),
    ));
  }
}
