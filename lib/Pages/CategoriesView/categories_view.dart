import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/AllProductsView/all_products_view.dart';
import 'package:grocery_nxt/Pages/CategoriesView/Controller/categories_view_controller.dart';

class CategoriesView extends StatelessWidget {
   CategoriesView({super.key});

   CategoriesViewController vc = Get.put(CategoriesViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor.withOpacity(0.05),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Categories",style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600
        ),),
        centerTitle: true,
        actions: [
          Container(
            width: 40.w,
            height: 40.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200)
            ),
            child: const Icon(Icons.search),
          )
        ],
      ),
      body: GetBuilder<CategoriesViewController>(
        builder: (vc) {
          return !vc.loading
              ? SingleChildScrollView(
            child: Column(
              children: [

                AnimationLimiter(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 12.h),
                      shrinkWrap: true,
                      itemCount: vc.categories.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          mainAxisExtent: MediaQuery.of(context).size.height*0.20
                      ),
                      itemBuilder: (context,index){
                        var category = vc.categories[index];
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          columnCount: 2,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.h,
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: (){
                                  Get.to(()=>AllProductsView(category: category,));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 20.h,left: 2.w,right: 2.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r)
                                  ),
                                  child: Column(
                                    children: [

                                      CachedNetworkImage(
                                        imageUrl: category!.imageUrl ?? "",
                                        fit: BoxFit.contain,
                                        height: MediaQuery.of(context).size.height*0.20*0.4,
                                        errorWidget: (c,w,o){
                                          return Image.asset("assets/images/gnxt_logo.png");
                                        },
                                      ),

                                      SizedBox(height: 16.h),

                                      Expanded(
                                        child: AutoSizeText(
                                            category.name!.toUpperCase(),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp
                                            ),
                                        ),
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )

              ],
            ),
          ) : const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}
