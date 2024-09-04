import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/OtpScreen/otp_screen.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_number/mobile_number.dart';

class LoginController extends GetxController{

  TextEditingController phoneTEC   = TextEditingController(text: "9080761312");
  TextEditingController nameTEC    = TextEditingController(text: "Anlin Jude");
  TextEditingController gstTEC     = TextEditingController();
  TextEditingController fssaiTEC   = TextEditingController();
  TextEditingController companyTEC = TextEditingController();
  bool loggingIn                 = false;
  bool isVendor                  = false;
  PageController pageController = PageController();

  //
  processLogin() async {

    loggingIn = true;
    update();
    try{
      var result = await HttpService.postRequest("loginotp",{
        "mobile": phoneTEC.text,
        "username": nameTEC.text,
        'gstnumber': gstTEC.text,
        'fssai': fssaiTEC.text,
        'companyname': companyTEC.text,
        'usertype': isVendor ? "2":"1"
      });
      if(result is http.Response){
        if(result.statusCode==200){
          Get.to(()=> OtpScreen());
        }else{
          //register();
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      ToastUtil().showToast(message: e.toString());
    }
    loggingIn = false;
    update();
  }

  //
  register() async {

    loggingIn = true;
    update();
    if(isVendor && !validateVendor()){
      loggingIn = false;
      update();
      return;
    }
    try{
      var result = await HttpService.postRequest("register",{
        'username': nameTEC.text,
        'password': phoneTEC.text,
        'full_name': nameTEC.text,
        'email': phoneTEC.text+"@gmail.com",
        'phone': phoneTEC.text,
        'state_id': '',
        'city': '',
        'country_id': '70',
        'terms_conditions': 'on',
        'gstnumber': gstTEC.text,
        'fssa': fssaiTEC.text,
        'companyname': companyTEC.text,
        'usertype': isVendor ? "2":"1"
      });
      if(result is http.Response){
        if(result.statusCode==200){
          processLogin();
        }else if(result.statusCode==422){
          if(jsonDecode(result.body)["validation_errors"]["phone"]!=null){
            ToastUtil().showToast(message: jsonDecode(result.body)["validation_errors"]["phone"][0]);
          }
        }
      }
    }catch(e){
      ToastUtil().showToast(message: e.toString());
      if (kDebugMode) {
        print(e);
      }
    }
    loggingIn = false;
    update();

  }

  //
  bool validateVendor(){

    if(gstTEC.text.isEmpty){
      ToastUtil().showToast(message: "GST Number is required.");
      return false;
    }
    if(fssaiTEC.text.isEmpty){
      ToastUtil().showToast(message: "Fssai number is required.");
      return false;
    }
    if(companyTEC.text.isEmpty){
      ToastUtil().showToast(message: "Company name is required.");
      return false;
    }
    return true;
  }

  //
  getPhoneNumber() async {
    if(Platform.isIOS){
      return;
    }
    if(await MobileNumber.hasPhonePermission){
      MobileNumber.getSimCards!.then((value) async {
        if(value.isNotEmpty) {
          await Get.defaultDialog(
          title: "Choose number",
          titleStyle: TextStyle(
            fontSize: 14.sp
          ),
          content: ListView.builder(
                  shrinkWrap: true,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    var sim = value[index].number;
                    return ListTile(
                      leading: Text("SIM ${index + 1}"),
                      title: Text(value[index].number!),
                      onTap: () {
                        if (sim!.length > 12) {
                          phoneTEC.text = sim.substring(4);
                        } else {
                          phoneTEC.text = sim.substring(2);
                        }
                        Get.close(1);
                      },
                    );
                  }));
        }
      });
      update();
      return;
    }
    await MobileNumber.requestPhonePermission;
  }

  //
  listenForPermissions(){

    MobileNumber.listenPhonePermission((isPermissionGranted){
      print(Get.currentRoute);
      if(Get.currentRoute=="/LoginScreen") {
        getPhoneNumber();
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    //listenForPermissions();
    //getPhoneNumber();
  }

}