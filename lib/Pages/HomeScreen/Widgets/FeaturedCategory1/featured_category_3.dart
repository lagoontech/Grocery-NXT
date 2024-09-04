import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';

import '../../../SwiggyView/swiggy_view.dart';

class FeaturedCategory3 extends StatelessWidget {
  FeaturedCategory3({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        id: "category_3",
        builder: (vc) {
          return vc.subcategories1.isNotEmpty?Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 12.h,bottom: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [

                      Expanded(child: Divider(
                        thickness: 0.4,
                      )),

                      SizedBox(
                        width: 8.w,
                      ),

                      Text("Oil & Ghee"),

                      SizedBox(
                        width: 8.w,
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
                      itemCount: 9,
                      padding: EdgeInsets.only(top: 20.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 6.h,
                          crossAxisSpacing: 6.w
                      ),
                      itemBuilder: (context,index){
                        var subCategory = vc.subcategories3[index];
                        return GestureDetector(
                          onTap: (){
                            Get.to(()=>SwiggyView(
                              categoryName: vc.categories.firstWhere((element) => element!.id==subCategory.categoryId)!.name,
                              categoryId: subCategory.categoryId,
                              imageUrl: vc.categories.firstWhere((element) => element!.id==subCategory.categoryId)!.imageUrl,
                              subCategoryId: subCategory.id,
                            ));
                          },
                          child: Container(
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
