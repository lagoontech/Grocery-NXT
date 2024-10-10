import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/ProfileView/Model/profile_info_model.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import '../../LoginScreen/login_screen.dart';

class ProfileController extends GetxController{

  ProfileInfoModel ?profile;
  bool loadingProfile = false;
  bool deletingProfile = false;

  //
  fetchProfile() async {

    loadingProfile = true;
    update();
    try{
      var result = await HttpService.getRequest("user/profile");
      if(result is http.Response){
        if(result.statusCode==200){
          profile = profileInfoModelFromJson(result.body);
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    loadingProfile = false;
    update();

  }

  //
  deleteProfile() async {

    deletingProfile = true;
    update();
    Get.back();
    try{
      var result = await http.post(
          Uri.parse("https://grocerynxt.com/api/delete_account.php"),
          body: jsonEncode({
            "phone": profile!.userDetails!.phone.toString()
          })
      );
      if(result is http.Response){
        if(result.statusCode==200){
          Get.offAll(()=> LoginScreen());
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    deletingProfile = false;
    update();

  }

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

}