import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/AddCheckoutAddressView/Models/states_model.dart';
import 'package:grocery_nxt/Pages/OtpScreen/otp_screen.dart';
import 'package:grocery_nxt/Pages/RegisterScreen/Models/cities_model.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController{

  TextEditingController nameTEC          = TextEditingController();
  TextEditingController passwordTEC      = TextEditingController();
  TextEditingController emailTEC         = TextEditingController();
  TextEditingController phoneTEC         = TextEditingController();
  TextEditingController stateTEC         = TextEditingController();
  TextEditingController cityTEC          = TextEditingController();
  TextEditingController zipcodeTEC       = TextEditingController();
  TextEditingController addressTEC       = TextEditingController();
  TextEditingController citySearchTEC    = TextEditingController();
  TextEditingController gstTEC           = TextEditingController();
  TextEditingController fssaiTEC         = TextEditingController();
  TextEditingController companyTEC       = TextEditingController();
  CountryState ?selectedState;
  City ?selectedCity;

  bool isRegistering = false;
  bool loadingCities = false;
  bool isVendor      = false;
  List<City> cities = [];

  //
  @override
  void onInit() {
    super.onInit();
    getCities();
  }

  //
  validateRegister(){

    if(nameTEC.text.isEmpty){
      ToastUtil().showToast(message: "Enter your name");
      return;
    }
    if(emailTEC.text.isEmpty){
      ToastUtil().showToast(message: "Enter your email");
      return;
    }
    if(passwordTEC.text.length<6){
      ToastUtil().showToast(message: "Enter a password that is atleast 6 characters long");
      return;
    }
    if(validateEmail(emailTEC.text)!=null){
      ToastUtil().showToast(message: validateEmail(emailTEC.text)!);
      return;
    }
    if(phoneTEC.text.length != 10){
      ToastUtil().showToast(message: "Enter a valid phone number");
      return;
    }
    if(selectedCity==null){
      ToastUtil().showToast(message: "Select a city");
      return;
    }
    if(addressTEC.text.isEmpty){
      ToastUtil().showToast(message: "Enter your address");
      return;
    }
    if(zipcodeTEC.text.length!=6){
      ToastUtil().showToast(message: "Enter a valid zipcode");
      return;
    }
    if(isVendor){
      if(gstTEC.text.isEmpty){
        ToastUtil().showToast(message: "Enter your GST number");
        return;
      }
      if(fssaiTEC.text.isEmpty){
        ToastUtil().showToast(message: "Enter your FSSAI number");
        return;
      }
      if(companyTEC.text.isEmpty){
        ToastUtil().showToast(message: "Enter your company name");
        return;
      }
    }

    register();
  }

  //
  register() async{

    isRegistering = true;
    update();
    try{
      var result = await HttpService.postRequest("register",{
        'username': nameTEC.text,
        'password': passwordTEC.text,
        'full_name': nameTEC.text,
        'email': emailTEC.text,
        'phone': phoneTEC.text,
        'state_id': "613",
        'city': selectedCity!.name,
        'zipcode': zipcodeTEC.text,
        'country_id': "70",
        'terms_conditions': 'on',
      });
      if(result is http.Response){
        print(result.statusCode);
        if(result.statusCode == 200){
          Get.to(()=> OtpScreen());
        } else if(result.statusCode == 422){
          var error = jsonDecode(result.body);
          if(error["validation_errors"]!=null && error["validation_errors"] is Map){
            (error["validation_errors"] as Map).keys.forEach((element) {
              ToastUtil().showToast(message: error["validation_errors"][element][0]);
            });
          }
        }
      }
    } catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    isRegistering = false;
    update();
  }

  //
  getCities() async{

    try{
      var result = await HttpService.getRequest("get-cities/613");
      if(result is http.Response){
       if(result.statusCode == 200){
         cities = citiesModelFromJson(result.body).cities!;
       }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    update();
  }

  //
  String? validateEmail(String value) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

}