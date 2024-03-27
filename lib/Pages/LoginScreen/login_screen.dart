import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:grocery_nxt/Pages/LoginScreen/Controller/login_controller.dart';
import 'package:grocery_nxt/Pages/OtpScreen/otp_screen.dart';
import 'package:numpad/numpad.dart';
import '../../Widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

   LoginController lc = Get.put(LoginController());

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


                SizedBox(height: 48.h),

                CustomButton(
                  width: MediaQuery.of(context).size.width*0.8,
                  text: "Continue",
                  onTap: () {
                     Get.to(()=> OtpScreen());
                  },
                ),

                SizedBox(height: 8.h),
                
                const Text.rich(
                    TextSpan(text: "By clicking on “Continue” you are agreeing to our ",children: [
                      TextSpan(
                          text: "terms of use",
                          style: TextStyle(
                            color: Colors.blue,
                          )
                      )
                    ]),
                  textAlign: TextAlign.center,
                )

              ],
            )),

            Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: NumPad(
                      backgroundColor: Colors.grey.shade100,
                      buttonSize: 12,
                      mainAxisSpacing: 12,
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                      ),
                      numItemDecoration: BoxDecoration(),
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
