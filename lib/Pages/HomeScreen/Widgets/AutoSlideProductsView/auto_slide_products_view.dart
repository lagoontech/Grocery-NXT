import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';

class AutoSlideProductsView extends StatelessWidget {
   AutoSlideProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      didUpdateWidget: (c,v){
        print("updated");
      },
      builder: (vc) {
        return vc.featuredProducts.isNotEmpty?Container(
          height: MediaQuery.of(context).size.height*0.36,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          color: AppColors.secondaryColor,
          child: Column(
            children: [

              Expanded(
                child: ListView.builder(
                    itemCount: 36,
                    scrollDirection: Axis.horizontal,
                    controller: vc.autoScroll1,
                    itemBuilder: (context,index){
                      final itemIndex = index==0
                          ? 0
                          : index % vc.featuredProducts.length;
                      final product = vc.featuredProducts[itemIndex];
                      return Container(
                        width: MediaQuery.of(context).size.width*0.36,
                        height: MediaQuery.of(context).size.height*0.16,
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: product.color!.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12.r)
                        ),
                        child: FractionallySizedBox(
                            widthFactor: 0.6,
                            heightFactor: 0.7,
                            child: CachedNetworkImage(imageUrl: product.imgUrl!)
                        ),
                      );
                    }
                ),
              ),

              SizedBox(height: 8.h),

              Expanded(
                child: ListView.builder(
                    itemCount: (vc.featuredProducts.length/2).floor(),
                    scrollDirection: Axis.horizontal,
                    controller: vc.autoScroll2,
                    padding: EdgeInsets.only(left: 40.w),
                    itemBuilder: (context,index){
                      var product = vc.featuredProducts[(vc.featuredProducts.length/2).floor()];
                      return Container(
                        width: MediaQuery.of(context).size.width*0.36,
                        height: MediaQuery.of(context).size.height*0.16,
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                            color: product.color,
                            borderRadius: BorderRadius.circular(12.r)
                        ),
                        child: FractionallySizedBox(
                            widthFactor: 0.4,
                            child: CachedNetworkImage(imageUrl: product.imgUrl!)
                        ),
                      );
                    }
                ),
              ),

            ],
          ),
        ):SizedBox();
      }
    );
  }
}
