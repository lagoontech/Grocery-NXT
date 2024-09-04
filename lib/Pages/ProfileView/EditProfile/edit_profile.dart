import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Constants/app_colors.dart';
import '../../../Widgets/custom_appbar.dart';
import '../../../Widgets/custom_circular_loader.dart';
import '../../../Widgets/custom_textfield.dart';
import 'Controller/edit_profile_controller.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  EditProfileController vc = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(vc.nameTEC.text.isEmpty) {
        vc.getProfileDetails();
      }
    });

    return GetBuilder<EditProfileController>(
      builder: (vc) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: "Profile",
            action: GestureDetector(
              onTap: () {
                vc.updateProfile();
              },
              child: Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: !vc.updating?SizedBox(
                  width: 32.w,
                  height: 32.w,
                  child: const Image(image: AssetImage("assets/images/confirm_edit.png")),
                ):CustomCircularLoader(color: AppColors.primaryColor,),
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(left: 24.w, right: 24.w),
            child: Stack(
              children: [

                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 32.h),
                      customTextField(context,
                          label: "Full Name",
                          controller: vc.nameTEC,
                          fillColor: const Color(0xfff5f5f5),
                          borderColor: Colors.grey.shade500),
                      SizedBox(height: 40.h),
                      customTextField(context,
                          label: "Email ID",
                          controller: vc.emailTEC,
                          fillColor: const Color(0xfff5f5f5),
                          borderColor: Colors.grey.shade500),
                      SizedBox(height: 40.h),
                      customTextField(context,
                          label: "Address",
                          controller: vc.addressTEC,
                          fillColor: const Color(0xfff5f5f5),
                          borderColor: Colors.grey.shade500),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
