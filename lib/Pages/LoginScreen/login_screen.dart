import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Constants/app_size.dart';
import 'package:grocery_nxt/Pages/LoginScreen/Controller/login_controller.dart';
import 'package:grocery_nxt/Pages/RegisterScreen/register_screen.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:grocery_nxt/Widgets/custom_textfield.dart';
import 'package:numpad/numpad.dart';
import '../../Widgets/custom_button.dart';
import '../DashBoardView/dashboard_view.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  LoginController lc = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //lc.getPhoneNumber();
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: lc.pageController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                ),

                                Center(
                                  child: Image.asset(
                                    "assets/images/gnxt_logo.png",
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                  ),
                                ),

                                SizedBox(height: 20.h),

                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: AutoSizeText(
                                      "Enter your mobile number",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w700),
                                    )),

                                SizedBox(height: 20.h),

                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      "We will send you a verification code",
                                      textAlign: TextAlign.center,
                                      maxLines: null,
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade600),
                                    )),

                                SizedBox(height: 20.h),

                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 40.w),
                                  child: Column(
                                    children: [
                                      customTextField(
                                        context,
                                        hint: "Phone",
                                        fillColor: AppColors.primaryColor.withOpacity(0.01),
                                        borderColor: AppColors.primaryColor,
                                        controller: lc.phoneTEC,
                                        textInputType: TextInputType.number
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 24.h),

                                GetBuilder<LoginController>(builder: (vc) {
                                  return CustomButton(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: !vc.loggingIn
                                        ? Text(
                                            "Login",
                                            style:
                                                TextStyle(color: Colors.white,fontSize: 14.sp),
                                          )
                                        : CustomCircularLoader(),
                                    onTap: () {
                                      lc.processLogin();
                                      //Get.to(()=> OtpScreen());
                                    },
                                  );
                                }),

                                SizedBox(height: 8.h),

                                TextButton(
                                    onPressed: (){
                                      Get.to(()=> Register());
                                    },
                                    child: Text("Register",style: TextStyle(
                                      fontSize: isIpad?12.sp:14.sp
                                    ),)
                                ),

                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w,vertical: isIpad?4.h:2.h),
                                  child: Text.rich(
                                    TextSpan(
                                        text:
                                            "By continuing you are agreeing to our \n",
                                        style: TextStyle(
                                          fontSize: isIpad?10.sp:12.sp
                                        ),
                                        children: [
                                          TextSpan(
                                              text: "terms of use",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline))
                                        ]),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                SizedBox(height: 32.h),

                                Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                          color: AppColors.primaryColor
                                      )
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        Get.offAll(()=> DashboardView());
                                      },
                                      child: Text(
                                        "Continue as guest",
                                        style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: isIpad?12.sp:null
                                        ),
                                      )
                                  ),
                                ),


                              ],
                            )),

                        /* Expanded(
                            flex: 5,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16)
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: NumPad(
                                  backgroundColor: const Color(0xfff3f5f7),
                                  buttonSize: 12,
                                  mainAxisSpacing: 12,
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 28,
                                  ),
                                  numItemDecoration: const BoxDecoration(),
                                  onTap: (val) {
                                    if(val==99){
                                      if(lc.phoneTEC.text.isEmpty){
                                        return;
                                      }
                                      lc.phoneTEC.text = lc.phoneTEC.text.substring(0, lc.phoneTEC.text.length - 1);
                                      return;
                                    }
                                    if(lc.phoneTEC.text.length==10){
                                      return;
                                    }
                                    lc.phoneTEC.text = lc.phoneTEC.text+val.toString();
                                    print(lc.phoneTEC.text);
                                    lc.update();
                                  },
                                ),
                              ),
                            )
                        )*/
                      ],
                    ),

                    //................................................................

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 6,
                            child: Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                ),
                                Center(
                                  child: Image.asset(
                                    "assets/images/gnxt_logo.png",
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: AutoSizeText(
                                      "Enter your mobile number",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w700),
                                    )),
                                SizedBox(height: 20.h),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      "We will send you a verification code",
                                      textAlign: TextAlign.center,
                                      maxLines: null,
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade600),
                                    )),
                                SizedBox(height: 20.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 40.w),
                                  child: Column(
                                    children: [
                                      customTextField(
                                        context,
                                        hint: "Username",
                                        fillColor: AppColors.primaryColor
                                            .withOpacity(0.01),
                                        borderColor: AppColors.primaryColor,
                                        controller: lc.nameTEC,
                                      ),
                                      SizedBox(height: 12.h),
                                      customTextField(
                                        context,
                                        hint: "Phone number",
                                        fillColor: AppColors.primaryColor
                                            .withOpacity(0.01),
                                        borderColor: AppColors.primaryColor,
                                        controller: lc.phoneTEC,
                                      ),
                                      SizedBox(height: 12.h),
                                      customTextField(
                                        context,
                                        hint: "GST number",
                                        fillColor: AppColors.primaryColor
                                            .withOpacity(0.01),
                                        borderColor: AppColors.primaryColor,
                                        controller: lc.gstTEC,
                                      ),
                                      SizedBox(height: 12.h),
                                      customTextField(context,
                                          hint: "FSSAI number",
                                          fillColor: AppColors.primaryColor
                                              .withOpacity(0.01),
                                          borderColor: AppColors.primaryColor,
                                          controller: lc.fssaiTEC),
                                      SizedBox(height: 12.h),
                                      customTextField(context,
                                          hint: "Company",
                                          fillColor: AppColors.primaryColor
                                              .withOpacity(0.01),
                                          borderColor: AppColors.primaryColor,
                                          controller: lc.companyTEC),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                GetBuilder<LoginController>(builder: (vc) {
                                  return CustomButton(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: !vc.loggingIn
                                        ? const Text(
                                            "Register / Login",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : CustomCircularLoader(),
                                    onTap: () {
                                      lc.register();
                                      //Get.to(()=> OtpScreen());
                                    },
                                  );
                                }),
                                SizedBox(height: 8.h),
                                GetBuilder<LoginController>(builder: (vc) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Switch(
                                            value: lc.isVendor,
                                            onChanged: (v) {
                                              lc.isVendor = v;
                                              lc.update();
                                              if (v) {
                                                lc.pageController.animateToPage(
                                                    1,
                                                    duration: const Duration(
                                                        milliseconds: 400),
                                                    curve: Curves.linear);
                                              } else {
                                                lc.pageController.animateToPage(
                                                    0,
                                                    duration: const Duration(
                                                        milliseconds: 400),
                                                    curve: Curves.linear);
                                              }
                                            }),
                                        Text("Vendor",
                                            style: TextStyle(
                                                color: AppColors.primaryColor))
                                      ],
                                    ),
                                  );
                                }),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w),
                                  child: const Text.rich(
                                    TextSpan(
                                        text:
                                            "By continuing you are agreeing to our \n",
                                        children: [
                                          TextSpan(
                                              text: "terms of use",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline))
                                        ]),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )),

                        /* Expanded(
                            flex: 5,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16)
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: NumPad(
                                  backgroundColor: const Color(0xfff3f5f7),
                                  buttonSize: 12,
                                  mainAxisSpacing: 12,
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 28,
                                  ),
                                  numItemDecoration: const BoxDecoration(),
                                  onTap: (val) {
                                    if(val==99){
                                      if(lc.phoneTEC.text.isEmpty){
                                        return;
                                      }
                                      lc.phoneTEC.text = lc.phoneTEC.text.substring(0, lc.phoneTEC.text.length - 1);
                                      return;
                                    }
                                    if(lc.phoneTEC.text.length==10){
                                      return;
                                    }
                                    lc.phoneTEC.text = lc.phoneTEC.text+val.toString();
                                    print(lc.phoneTEC.text);
                                    lc.update();
                                  },
                                ),
                              ),
                            )
                        )*/
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  InputDecoration inputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
      border:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
    );
  }
}
