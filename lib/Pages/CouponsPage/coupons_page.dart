import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/CouponsPage/Controller/coupon_controller.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import '../../Widgets/custom_button.dart';

class CouponsPage extends StatelessWidget {
  CouponsPage({super.key});

  CouponController couponController = Get.put(CouponController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Available Coupons",),
      body: GetBuilder<CouponController>(
        builder: (vc) {
          return !vc.loading ? Column(
            children: [

              ListView.builder(
                  shrinkWrap: true,
                  itemCount: vc.coupons.length,
                  itemBuilder: (context,index){
                    return Column(
                      children: [

                        ListTile(
                          title: Text(vc.coupons[index].title!,style: TextStyle(
                            color: AppColors.primaryColor
                          ),),
                          subtitle: Text(
                              "Code: ${vc.coupons[index].code}",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12.sp
                              ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text(vc.coupons[index].discount! + "%",style: TextStyle(
                                fontSize: 14.sp
                              ),),

                              SizedBox(height: 2.h),

                              SizedBox(
                                width: 50.w,
                                height: 24.h,
                                child: CustomButton(
                                    onTap: (){
                                      Get.back(result: vc.coupons[index].code);
                                    },
                                    borderRadius: 8.r,
                                    child: Text("Apply",style: TextStyle(fontSize: 10.sp))
                                ),
                              ),

                            ],
                          ),
                          onTap: () {
                            // Navigate to CouponDetailsPage with selected coupon
                          },
                        ),

                        Divider()

                      ],
                    );
                  }
              )

            ],
          ) : Center(child: CustomCircularLoader(color: AppColors.primaryColor));
        }
      )
    );
  }
}
