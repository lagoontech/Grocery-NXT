import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/DashBoardView/dashboard_view.dart';
import 'package:grocery_nxt/Pages/LoginScreen/Controller/login_controller.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:grocery_nxt/Utils/shared_pref_utils.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:http/http.dart' as http;

class OtpController extends GetxController{

  TextEditingController otpTEC = TextEditingController();
  LoginController lc = Get.find<LoginController>();
  bool checkingOtp = false;

  //
  checkOTP()async{

    if(otpTEC.text.length<4){
      ToastUtil().showToast(message: "Enter valid otp");
      return;
    }
    checkingOtp = true;
    update();
    try{
      var result = await HttpService.postRequest("checkotp",{
        "mobile": lc.phoneTEC.text,
        "otp": otpTEC.text
      });
      if(result is http.Response){
        if(result.statusCode==200){
          var res = json.decode(result.body);
          if(res["token"]!=null){
            SharedPrefUtils().setString("token",res["token"]);
            ToastUtil().showToast(message: "Welcome ${res["users"]["username"]}");
            Get.offAll(()=>DashboardView());
          }else if(res["msg"]=="OTP Mismatch."){
            ToastUtil().showToast(message: "Invalid otp");
          }
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    checkingOtp = false;
    update();
  }

}