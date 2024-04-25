import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/Top%20Content/top_content.dart';

class AppBarContent extends StatelessWidget {
  AppBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.14,
      color: AppColors.primaryColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).viewPadding.top + 2.h,
        bottom: 16.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /*Container(
            height: kToolbarHeight,
            color: Colors.grey.shade100,
          ),*/

          SizedBox(
            height: 4.h,
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                children: [

                  Image.asset(
                    'assets/images/gnxt_logo.png',
                    width: MediaQuery.of(context).size.width*0.5,
                    color: Colors.white,
                  ),

                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 48.w,
                        child: TextFormField(
                          decoration: decoration(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
        hintText: "Search Products",
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
