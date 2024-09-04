import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/Top%20Content/top_content.dart';
import 'package:grocery_nxt/Pages/ProductsSearchScreen/products_search_screen.dart';

class AppBarContent extends StatelessWidget {
  AppBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: "appbar",
      builder: (vc) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: MediaQuery.of(context).size.width,
          height: vc.shrinkAppbar?MediaQuery.of(context).size.height*0.12:MediaQuery.of(context).size.height * 0.16,
          color: AppColors.primaryColor,
          padding: EdgeInsets.only(
            top: vc.shrinkAppbar
                ? MediaQuery.of(context).viewPadding.top*0.7
                : MediaQuery.of(context).viewPadding.top + 2.h,
            bottom: 6.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

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
                        width: vc.shrinkAppbar?MediaQuery.of(context).size.width*0.5:MediaQuery.of(context).size.width*0.6,
                        color: Colors.white,
                      ),

                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: (){
                              Get.to(()=> ProductsSearchScreen());
                            },
                            child: Container(
                              width: 40.w,
                              height: 40.w,
                              margin: EdgeInsets.only(top: 4.h),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                              ),
                              child: Icon(Icons.search,color: AppColors.primaryColor),
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
        prefixIcon: const Icon(Icons.search, color: Colors.green),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 0, color: Colors.transparent),
            borderRadius: BorderRadius.circular(28.r)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.r),
            borderSide: const BorderSide(width: 0)));
  }
}
