import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';

class AppBarContent extends StatelessWidget {
  AppBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.22,
      color: AppColors.primaryColor,
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: MediaQuery.of(context).viewPadding.top + 8.h,
        bottom: 16.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: decoration(),
                  ),
                ),
                SizedBox(width: 4.w),
                CircleAvatar(
                  radius: 22.w,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 20.sp),
                )
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Column(
              children: [
                Text(
                  "Current Location",
                  style: TextStyle(
                      fontSize: 10.sp, color: Colors.white.withOpacity(0.7)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Nagercoil",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //
  InputDecoration decoration() {
    return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 4.h),
        hintText: "Search Category",
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 12.sp),
        prefixIcon: Icon(Icons.search, color: Colors.green),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0, color: Colors.transparent),
            borderRadius: BorderRadius.circular(28.r)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.r),
            borderSide: BorderSide(width: 0)));
  }
}
