import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/ChooseAddressView/choose_address_view.dart';
import 'package:grocery_nxt/Pages/Help_center/HelpCenter_view.dart';
import 'package:grocery_nxt/Pages/LoginScreen/login_screen.dart';
import 'package:grocery_nxt/Pages/ProfileView/Controller/profile_controller.dart';
import 'package:grocery_nxt/Pages/ProfileView/Views/WishlistView/wishlist_view.dart';
import 'package:grocery_nxt/Pages/ProfileView/Widgets/profile_item.dart';
import 'package:grocery_nxt/Utils/shared_pref_utils.dart';
import 'package:grocery_nxt/Widgets/custom_button.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:lottie/lottie.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ProfileController>(
        builder: (vc) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryColor.withOpacity(0.04),
                  AppColors.primaryColor.withOpacity(0.0),
                ],
                radius: 3,
                focalRadius: 0.1,
                center: Alignment.topCenter,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).viewPadding.top*2),
                    /*Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SizedBox(
                          height: kToolbarHeight,
                          child: Center(
                            child: Text(
                              "Profile",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),*/
                    Center(
                      child: Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.r)),
                            elevation: 20,
                            shadowColor: AppColors.primaryColor.withOpacity(0.8),
                            child: SizedBox(
                              width: 100.w,
                              height: 100.w,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: Stack(
                                    children: [

                                      Lottie.asset(
                                          "assets/animations/avatar.json",
                                          width: 100.w,
                                          height: 100.h,
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          GetBuilder<ProfileController>(builder: (vc) {
                            return !vc.loadingProfile
                                ? Text(
                                    vc.profile == null
                                        ? ""
                                        : vc.profile!.userDetails.name.toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.3))
                                : CustomCircularLoader(
                                    color: AppColors.primaryColor);
                          })
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),

                    ProfileItem(
                      iconAsset: "heart",
                      title: "My Wishlist",
                      onTap: () {
                        Get.to(() => WishListView());
                      },
                    ),

                    ProfileItem(
                      iconAsset: "profile",
                      title: "Help Center",
                      onTap: () {
                        Get.to(()=> const HelpCenterView());
                      },
                    ),

                    ProfileItem(
                      iconAsset: "location",
                      title: "My Address",
                      onTap: () {
                        Get.to(() => ChooseAddressView(fromProfile: true));
                      },
                    ),

                    ProfileItem(
                      iconAsset: "coupon",
                      title: "My Coupons",
                      onTap: () {},
                    ),

                    ProfileItem(
                      iconAsset: "logout",
                      title: "Log Out",
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: const Center(child: Text('Logout')),
                                backgroundColor: Colors.white,
                                surfaceTintColor: Colors.white,
                                content: const Text('Are you sure you want to log out?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  CustomButton(
                                    width: 80.w,
                                    onTap: () async {
                                      await SharedPrefUtils.pref!.setString("token","");
                                      Get.offAll(()=>LoginScreen());
                                    },
                                    child: const Text('Logout',style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ],
                ),
                Positioned(
                    right: -10.w,
                    top: 40.h,
                    child: Image.asset(
                      "assets/images/leaf.png",
                      width: MediaQuery.of(context).size.width * 0.1,
                    )),
                Positioned(
                    left: -10.w,
                    top: MediaQuery.of(context).size.height * 0.12,
                    child: Image.asset(
                      "assets/images/leaf.png",
                      width: MediaQuery.of(context).size.width * 0.08,
                    )),
                Positioned(
                    right: 0.w,
                    top: MediaQuery.of(context).size.height * 0.5,
                    child: Image.asset(
                      "assets/images/leaf_blurred.png",
                      width: MediaQuery.of(context).size.width * 0.1,
                    )),
              ],
            ),
          );
        }
      ),
    );
  }
}
