import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Constants/app_colors.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/custom_circular_loader.dart';
import '../../Widgets/custom_list_view.dart';
import '../../Widgets/custom_textfield.dart';
import 'Controller/register_controller.dart';

class Register extends StatelessWidget {
  Register({super.key});

  RegisterController rc = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36.w),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Center(
                child: Image.asset(
                  "assets/images/gnxt_logo.png",
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: kToolbarHeight,
                ),
              ),
              SizedBox(height: 20.h),
              customTextField(
                context,
                hint: "Name",
                fillColor: AppColors.primaryColor.withOpacity(0.01),
                borderColor: AppColors.primaryColor,
                controller: rc.nameTEC,
              ),
              SizedBox(height: 12.h),
              customTextField(
                context,
                hint: "Email",
                fillColor: AppColors.primaryColor.withOpacity(0.01),
                borderColor: AppColors.primaryColor,
                controller: rc.emailTEC,
              ),
              SizedBox(height: 12.h),
              customTextField(
                context,
                hint: "Password",
                obscureText: true,
                maxlines: 1,
                fillColor: AppColors.primaryColor.withOpacity(0.01),
                borderColor: AppColors.primaryColor,
                textInputType: TextInputType.visiblePassword,
                controller: rc.passwordTEC,
              ),
              SizedBox(height: 12.h),
              customTextField(
                context,
                hint: "Phone",
                fillColor: AppColors.primaryColor.withOpacity(0.01),
                borderColor: AppColors.primaryColor,
                textInputType: TextInputType.phone,
                controller: rc.phoneTEC,
              ),
              SizedBox(height: 12.h),
              customTextField(
                context,
                hint: "City",
                readOnly: true,
                onTap: () {
                  showCitiesBottomSheet(context);
                },
                fillColor: AppColors.primaryColor.withOpacity(0.01),
                borderColor: AppColors.primaryColor,
                controller: rc.cityTEC,
              ),
              SizedBox(height: 12.h),
              customTextField(
                context,
                hint: "Zipcode",
                readOnly: true,
                onTap: () {
                  showCitiesBottomSheet(context);
                },
                fillColor: AppColors.primaryColor.withOpacity(0.01),
                borderColor: AppColors.primaryColor,
                controller: rc.cityTEC,
              ),
              GetBuilder<RegisterController>(
                builder: (vc) {
                  return vc.isVendor?Column(
                    children: [
                      SizedBox(height: 12.h),
                      customTextField(
                        context,
                        hint: "Address",
                        fillColor: AppColors.primaryColor.withOpacity(0.01),
                        borderColor: AppColors.primaryColor,
                        controller: rc.addressTEC,
                      ),
                      SizedBox(height: 12.h),
                      customTextField(
                        context,
                        hint: "GST number",
                        fillColor: AppColors.primaryColor
                            .withOpacity(0.01),
                        borderColor: AppColors.primaryColor,
                        controller: rc.gstTEC,
                      ),
                      SizedBox(height: 12.h),
                      customTextField(context,
                          hint: "FSSAI number",
                          fillColor: AppColors.primaryColor
                              .withOpacity(0.01),
                          borderColor: AppColors.primaryColor,
                          controller: rc.fssaiTEC),
                      SizedBox(height: 12.h),
                      customTextField(context,
                          hint: "Company",
                          fillColor: AppColors.primaryColor
                              .withOpacity(0.01),
                          borderColor: AppColors.primaryColor,
                          controller: rc.companyTEC),
                    ],
                  ) : SizedBox();
                }
              ),

              SizedBox(height: 4.h),

              GetBuilder<RegisterController>(
                builder: (vc) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      SizedBox(
                        width: 30.w,
                        child: Checkbox(
                            value: rc.isVendor,
                            side: BorderSide(color: AppColors.primaryColor,width: 1),
                            onChanged: (v){
                              rc.isVendor = v!;
                              rc.update();
                            }),
                      ),

                      Text(
                        "Re-seller",
                        style: TextStyle(
                            color: AppColors.primaryColor))

                    ],
                  );
                }
              ),

              SizedBox(height: 24.h),
              GetBuilder<RegisterController>(builder: (vc) {
                return CustomButton(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: !vc.isRegistering
                      ? const Text(
                          "Register",
                          style: TextStyle(color: Colors.white),
                        )
                      : CustomCircularLoader(),
                  onTap: () {
                    rc.register();
                    //Get.to(()=> OtpScreen());
                  },
                );
              }),
              SizedBox(height: 8.h),
              TextButton(
                  onPressed: (){
                    Get.back();
                  },
                  child: const Text("Login")
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  showCitiesBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: customTextField(context,
                        borderRadius: 12.r,
                        borderColor: const Color(0xffD7DFE9),
                        hint: "Search City",
                        controller: rc.citySearchTEC,
                        onChanged: (v) {}),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    "Select City",
                    style: TextStyle(
                      color: const Color(0xff798397),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  GetBuilder<RegisterController>(builder: (vc) {
                    return !vc.loadingCities
                        ? CustomListView(
                            itemCount: vc.cities.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      vc.cityTEC.text =
                                          vc.cities[index]!.name!;
                                      vc.selectedCity = vc.cities[index];
                                      Get.back();
                                    },
                                    title: Text(vc.cities[index]!.name!),
                                  ),
                                  const Divider(height: 0)
                                ],
                              );
                            },
                          )
                        : CustomCircularLoader(
                            color: AppColors.primaryColor,
                          );
                  }),
                ],
              ),
            ),
          );
        });
  }
}
