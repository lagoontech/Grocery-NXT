import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/ProfileView/Widgets/profile_item.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';

class ProfileView extends StatelessWidget {
   ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Profile",
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          gradient: RadialGradient(
            colors: [
              AppColors.primaryColor.withOpacity(0.1),
              AppColors.primaryColor.withOpacity(0.0),
            ],
            radius: 1.2,
            focalRadius: 0.2,
            center: Alignment.center,
          ),
        ),
        child: Stack(
          children: [

            Column(
              children: [

                SizedBox(height: 12.h),

                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: SvgPicture.asset(
                              "assets/icons/edit.svg",
                              width: 12.w,
                              height: 12.h,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 4.h),
                      
                      Text("AKASH A",style: TextStyle(fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                ProfileItem(
                  iconAsset: "profile",
                  title: "Personal Info",
                  onTap: (){

                  },
                ),
                ProfileItem(
                  iconAsset: "heart",
                  title: "My Wishlist",
                  onTap: (){

                  },
                ),
                ProfileItem(
                  iconAsset: "payments",
                  title: "Payments",
                  onTap: (){

                  },
                ),
                ProfileItem(
                  iconAsset: "notification",
                  title: "Notifications",
                  onTap: (){

                  },
                ),
                ProfileItem(
                  iconAsset: "profile",
                  title: "Help Center",
                  onTap: (){

                  },
                ),
                ProfileItem(
                  iconAsset: "location",
                  title: "My Address",
                  onTap: (){

                  },
                ),
                ProfileItem(
                  iconAsset: "coupon",
                  title: "My Coupons",
                  onTap: (){

                  },
                ),
                ProfileItem(
                  iconAsset: "logout",
                  title: "Log Out",
                  onTap: (){

                  },
                ),

              ],
            ),

            Positioned(
                right: -10.w,
                top: 40.h,
                child: Image.asset(
                  "assets/images/leaf.png",
                  width: MediaQuery.of(context).size.width*0.1,
                )),

            Positioned(
                left: -10.w,
                top: MediaQuery.of(context).size.height*0.12,
                child: Image.asset(
                  "assets/images/leaf.png",
                  width: MediaQuery.of(context).size.width*0.08,
                )),

            Positioned(
                right: 0.w,
                top: MediaQuery.of(context).size.height*0.5,
                child: Image.asset(
                  "assets/images/leaf_blurred.png",
                  width: MediaQuery.of(context).size.width*0.1,
                )),

          ],
        ),
      ),
    );
  }
}
