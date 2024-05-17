import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/AutoSlideProductsView/auto_slide_products_view.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/CarouselView/carousel_view.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/FeaturedCategory1/featured_category_1.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/FeaturedProductsView/featured_products_view.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/HomeCampaign/home_campaign.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/HomeProductsView/home_products_view.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/ScrollIndicator/scroll_indicator.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/Top%20Content/appbar_content.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/Top%20Content/top_content.dart';
import 'package:lottie/lottie.dart';

import 'Widgets/FeaturedCategory1/featured_category_2.dart';
import 'Widgets/FeaturedCategory1/featured_category_3.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  HomeController hc = Get.put(HomeController());
  CartController cc = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    if(hc.sc.hasClients){
      hc.sc.animateTo(
          -20,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn);
    }

    return AddToCartAnimation(
      cartKey: cc.cartIconKey,
      height: 30,
      width: 30,
      opacity: 1,
      dragAnimation: const DragToCartAnimationOptions(
        rotation: true,
      ),
      jumpAnimation: const JumpAnimationOptions(
          curve: Curves.easeOutSine,
          duration: Duration(milliseconds: 250)
      ),
      createAddToCartAnimation: (runAddToCartAnimation) {
        cc.runAddToCartAnimation = runAddToCartAnimation;
      },
      child: Scaffold(
          body: Stack(
            children: [

              Image.asset(
                "assets/images/grocery.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fitWidth,
                color: Colors.black.withOpacity(0.02),
              ),

              NestedScrollView(
                body: CustomScrollView(
                  controller: hc.homeSc,
                  slivers: <Widget>[

                    SliverList(
                      delegate: SliverChildListDelegate(
                        [

                          TopContent(),

                          SizedBox(height: 52.h),

                          const ScrollIndicator(),

                          FeaturedProductsView(),

                          CarouselView(),

                          HomeProductsView(),

                          SizedBox(height: 24.h),

                          HomeCampaign(),

                          FeaturedCategory1(),

                          SizedBox(height: 24.h),

                          FeaturedCategory2(),

                          SizedBox(height: 24.h),

                          FeaturedCategory3(),

                          SizedBox(height: 24.h),

                          //AutoSlideProductsView()

                        ],
                      ),
                    ),

                  ],
                ),
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [];
                },
              ),

              AppBarContent(),

              GetBuilder<HomeController>(
                builder: (vc) {
                  return vc.categories.isEmpty||vc.products.isEmpty?Container(
                    color: AppColors.primaryColor,
                    child: Stack(
                      children: [

                        Image.asset(
                            "assets/images/grocery.png",
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            fit: BoxFit.fitWidth,
                          color: Colors.white.withOpacity(0.2),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                          ),
                        ),

                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.height*0.3,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              shape: BoxShape.circle
                            ),
                            child: Lottie.asset("assets/animations/home_loader.json"),
                          ),
                        )

                      ],
                    ),
                  ):SizedBox();
                }
              )

            ],
          ),
      ),
    );
  }

}
