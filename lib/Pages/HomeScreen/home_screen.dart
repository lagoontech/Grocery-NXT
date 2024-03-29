import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/CarouselView/carousel_view.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/HomeProductsView/home_products_view.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/ScrollIndicator/scroll_indicator.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/Top%20Content/appbar_content.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/Top%20Content/top_content.dart';

import 'Widgets/BottomBar/bottom_bar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  HomeController hc = Get.put(HomeController());
  CartController cc = Get.put(CartController());

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return AddToCartAnimation(
      cartKey: cc.cartIconKey,
      height: 30,
      width: 30,
      opacity: 0.85,
      dragAnimation: const DragToCartAnimationOptions(
        rotation: true,
      ),
      jumpAnimation: const JumpAnimationOptions(),
      createAddToCartAnimation: (runAddToCartAnimation) {
        // You can run the animation by addToCartAnimationMethod, just pass trough the the global key of  the image as parameter
        cc.runAddToCartAnimation = runAddToCartAnimation;
      },
      child: Scaffold(
          body: Stack(
            children: [
              NestedScrollView(
                body: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          TopContent(),
                          SizedBox(height: 52.h),
                          const ScrollIndicator(),
                          HomeProductsView(),
                          CarouselView(),
                        ],
                      ),
                    ),
                  ],
                ),
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [];
                },
              ),

              AppBarContent()
            ],
          ),
          bottomNavigationBar: BottomBar()
      ),
    );
  }

}
