import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';

class FeaturedCategory2 extends StatelessWidget {
  FeaturedCategory2({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        id: "category_2",
        builder: (vc) {
          return vc.subcategories2.isNotEmpty?Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [

                      const Expanded(child: Divider(
                        thickness: 0.4,
                      )),

                      SizedBox(
                        width: 2.w,
                      ),

                      SizedBox(
                        height: 14.h,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: vc.subcategories2.length,
                            itemBuilder: (context,index){
                              var subCategory = vc.subcategories2[index];
                              return subCategory.imageUrl!=null?CachedNetworkImage(
                                imageUrl: subCategory.imageUrl??"",
                                width: 12.w,
                                height: 12.w,
                              ):SizedBox();
                            }
                        ),
                      ),

                      SizedBox(
                        width: 2.w,
                      ),

                      Expanded(child: Divider(
                        thickness: 0.4,
                      )),

                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: vc.subcategories2.length,
                      padding: EdgeInsets.only(top: 12.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12.h,
                          crossAxisSpacing: 12.w
                      ),
                      itemBuilder: (context,index){
                        var subCategory = vc.subcategories2[index];
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: Colors.grey.shade200)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Container(
                                width: 56.w,
                                height: 56.w,
                                alignment: Alignment.bottomCenter,
                                child: CachedNetworkImage(
                                  imageUrl: subCategory.imageUrl!,
                                ),
                              ),

                              SizedBox(height: 4.h),


                              Text(
                                  subCategory.name!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600
                                  )),

                            ],
                          ),
                        );
                      }),
                )

              ],
            ),
          ) : SizedBox();
        }
    );
  }
}
