import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/AllProductsView/all_products_view.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Models/home_categories_model.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/HomeProductsView/product_list_item.dart';
import 'package:lottie/lottie.dart';

class OfferProducts extends StatelessWidget {
  OfferProducts({super.key});

  HomeController hc = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {

    return GetBuilder<HomeController>(
        id: "offerProducts",
        builder: (hc) {
          return hc.offerProducts.isNotEmpty?Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
                child: Row(
                  children: [

                    Text(
                      "Offer Products",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),

                    SizedBox(
                        width: 25,
                        child: Lottie.asset('assets/animations/hot_items_fire.json')
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Get.to(()=>AllProductsView(category: CategoryModel(name: "OFFERS"),));
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "See All",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: AnimationLimiter(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hc.offerProducts.length,
                      padding: EdgeInsets.only(left: 8.w),
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                            position: index,
                            delay: const Duration(milliseconds: 150),
                            child: SlideAnimation(
                              verticalOffset: 24.h,
                              duration: const Duration(milliseconds: 350),
                              child: FadeInAnimation(
                                child: ProductListItem(
                                    index: index,
                                    product: hc.offerProducts[index]),
                              ),
                            ));
                      }),
                ),
              ),
            ],
          ):SizedBox();
        }
    );
  }
}
