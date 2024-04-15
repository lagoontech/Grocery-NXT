import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/OtpScreen/otp_screen.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_number/mobile_number.dart';

class LoginController extends GetxController{

  TextEditingController phoneTEC = TextEditingController();
  bool loggingIn = false;

  //
  processLogin() async {

    loggingIn = true;
    update();
    try{
      var result = await HttpService.postRequest("loginotp",{
        "mobile":phoneTEC.text
      });
      if(result is http.Response){
        if(result.statusCode==200){
          Get.to(()=>OtpScreen());
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    loggingIn = false;
    update();
  }

  //
  getPhoneNumber() async {
    if(Platform.isIOS){
      return;
    }
    if(await MobileNumber.hasPhonePermission){
      MobileNumber.getSimCards!.then((value) async {
        await Get.defaultDialog(
            backgroundColor: Colors.white,
            title: "Choose your number",
            titleStyle: TextStyle(fontSize: 14.sp),
            content: ListView.builder(
                shrinkWrap: true,
                itemCount: value.length,
                itemBuilder: (context,index){
                  var sim = value[index].number;
                  return ListTile(
                    leading: Text("SIM ${index+1}"),
                    title: Text(value[index].number!),
                    onTap: (){
                      if(sim!.length>12) {
                        phoneTEC.text = sim.substring(4);
                      }else{
                        phoneTEC.text = sim.substring(2);
                      }
                      Get.close(1);
                    },
                  );
                })
        );
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
    listenForPermissions();
    //getPhoneNumber();
  }

}