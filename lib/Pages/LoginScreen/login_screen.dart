import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/LoginScreen/Controller/login_controller.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:numpad/numpad.dart';
import '../../Widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

   LoginController lc = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //lc.getPhoneNumber();
    });
    return Scaffold(
      body: Column(
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
                    "Enter your mobile number",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style:
                        TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
                  )),

              SizedBox(height: 20.h),

              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.08,
                  ),

                  Text(
                      "+91",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp
                      )
                  ),

                  SizedBox(width: 8.w),

                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: TextFormField(
                      controller: lc.phoneTEC,
                      readOnly: true,
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 6,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600
                      ),
                      decoration: inputDecoration(),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              GetBuilder<LoginController>(builder: (vc) {
                    return CustomButton(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: !vc.loggingIn
                          ? const Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            )
                          : CustomCircularLoader(),
                      onTap: () {
                        lc.processLogin();
                        //Get.to(()=> OtpScreen());
                      },
                    );
                  }),
                  SizedBox(height: 8.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: const Text.rich(
                    TextSpan(text: "By clicking on “Continue” you are agreeing to our \n",children: [
                      TextSpan(
                          text: "terms of use",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline
                          )
                      )
                    ]),
                  textAlign: TextAlign.center,
                ),
              )

            ],
          )),

          Expanded(
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
          )

        ],
      ),
    );
  }

  //
  InputDecoration inputDecoration(){

    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        vertical: 10.h
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent)

      ), enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent)

    ), focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent)

    ),

    );

  }

}
