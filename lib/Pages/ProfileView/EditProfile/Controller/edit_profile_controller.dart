import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../Constants/app_colors.dart';
import '../../../../Services/http_services.dart';
import '../../../../Utils/toast_util.dart';
import '../../Controller/profile_controller.dart';

class EditProfileController extends GetxController{

  String selectedGender               = "";
  TextEditingController nameTEC       = TextEditingController();
  TextEditingController addressTEC    = TextEditingController();
  TextEditingController emailTEC      = TextEditingController();
  ProfileController profileController = Get.find<ProfileController>();
  bool updating       = false;

  //
  onGenderTapped(String gender){

    selectedGender = gender;
    update();
  }

  //
  updateProfile() async {

    updating = true;
    update();
    if(nameTEC.text.isEmpty){
      ToastUtil().showToast(message: "Name cannot be empty");
      return;
    }
    /*if(addressTEC.text.isEmpty){
      ToastUtil().showToast(message: "Address cannot be empty");
      return;
    }*/
    /*if(emailTEC.text.isEmpty){
      ToastUtil().showToast(message: "Email cannot be empty");
      return;
    }*/

    var postData = {
      'name': nameTEC.text,
      'email': emailTEC.text,
      'phone': profileController.profile!.userDetails.phone,
      'zipcode': '',
      'state': '',
      'city': '',
      'user_id': profileController.profile!.userDetails.id,
      'country': "70",
      'address': addressTEC.text
    };

    try{
      var result = await HttpService.postRequest("user/update-profile",postData,insertHeader: true);
      if(result is http.Response){
        if(result.statusCode==200){
          ToastUtil().showToast(message: "Profile updated successfully",color: AppColors.primaryColor);
          profileController.fetchProfile();
        }
      }
    }catch(e){
      print(e);
    }
    updating = false;
    update();
  }

  //
  getProfileDetails() async {

    await profileController.fetchProfile();
    nameTEC.text     = profileController.profile!.userDetails.name;
    addressTEC.text  = profileController.profile!.userDetails.address ?? "";
    emailTEC.text    = profileController.profile!.userDetails.email;
  }

  //
  @override
  void onInit() {
    super.onInit();
    //getProfileDetails();
  }

}