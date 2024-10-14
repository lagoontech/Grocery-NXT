import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/AddCheckoutAddressView/Models/states_model.dart';
import 'package:grocery_nxt/Pages/DashBoardView/dashboard_view.dart';
import 'package:grocery_nxt/Pages/LoginScreen/login_screen.dart';
import 'package:grocery_nxt/Pages/OtpScreen/otp_screen.dart';
import 'package:grocery_nxt/Pages/RegisterScreen/Models/cities_model.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/shared_pref_utils.dart';

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
  bool isRegistering                     = false;
  bool loadingCities                     = false;
  bool isVendor                          = false;
  List<City> cities                      = [];
  List<CountryState?> states             = [];
  bool loadingStates                     = false;
  TextEditingController stateSearchTEC   = TextEditingController();
  Timer ?searchTimer;


  //
  @override
  void onInit() {
    super.onInit();
    if(kDebugMode){
      nameTEC.text = "Anlin Jude 7777";
      emailTEC.text = "anlinjude@gmail.com";
      phoneTEC.text = "9488277140";
      zipcodeTEC.text = "629157";
      passwordTEC.text = "123123";
    }
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
    if(selectedState==null){
      ToastUtil().showToast(message: "Select your state");
      return;
    }
    if(phoneTEC.text.length != 10){
      ToastUtil().showToast(message: "Enter a valid phone number");
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
        'state_id': selectedState!.id,
        'country_id': "70",
        'terms_conditions': 'on',
        'usertype': isVendor ? "1" : "0",
        'gstnumber': isVendor? gstTEC.text : "",
        'fssa': isVendor? fssaiTEC.text : "",
        'companyname': isVendor? companyTEC.text : "",
      });
      if(result is http.Response){
        log(result.body);
        if(result.statusCode == 200){
          Get.offAll(()=> LoginScreen(afterRegister: true,number: phoneTEC.text));
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
  getStates() async {

    loadingStates = true;
    update();
    try{
      var result = await HttpService.getRequest("state/70?name=${stateSearchTEC.text}",insertHeader: false);
      if(result is http.Response){
        if(result.statusCode==200){
          states = stateModelFromJson(result.body)!.states!;
          selectedState = states[0];
        }
      }
    }catch(e){
      print(e);
    }
    loadingStates = false;
    update();

  }

  //
  getCities() async{

    loadingCities = true;
    update();
    try {
      var result = await HttpService.getRequest(
          "get-cities/${selectedState!.id}${citySearchTEC.text.isNotEmpty
              ? "?name=${citySearchTEC.text}"
              : ""}", insertHeader: false);
      if (result is http.Response) {
        if (result.statusCode == 200) {
          cities = citiesModelFromJson(result.body).cities!;
        }
      }
    }
    catch (e){
      print(e);
    }
    loadingCities = false;
    update();

  }

  //
  debounceSearch({bool isStateSearch = false,bool isCitySearch = false}){

    if(searchTimer!=null && searchTimer!.isActive){
      searchTimer!.cancel();
      return;
    }
    searchTimer = Timer(const Duration(milliseconds: 750), () {
      if(isStateSearch){
        getStates();
        return;
      }else if(isCitySearch){
        getCities();
        return;
      }
    });

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