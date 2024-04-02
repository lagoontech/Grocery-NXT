import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:add_to_cart_animation/badge_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/state_manager.dart';
import 'package:grocery_nxt/Pages/DashBoardView/Controller/dashboard_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import '../../../../Constants/app_colors.dart';

class BottomBar extends StatelessWidget {
   BottomBar({super.key});

   CartController cc = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
        id: "bottomBar",
        builder: (vc) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 1,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [

                    BottomBarItem(
                        child: SvgPicture.asset(
                          "assets/icons/home.svg",
                          color: vc.bottomIndex == 0
                              ? AppColors.primaryColor
                              : null,
                        ),
                        onTap: () {
                          vc.changePage(0);
                        }),

                    BottomBarItem(
                        child: SvgPicture.asset(
                          "assets/icons/grid.svg",
                          color: vc.bottomIndex == 1
                              ? AppColors.primaryColor
                              : null,
                        ),
                        onTap: () {
                         vc.changePage(1);
                        }),

                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          vc.changePage(2);
                        },
                        child: Transform.translate(
                          offset: const Offset(0, -20),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [

                              GetBuilder<CartController>(
                                builder: (vc) {
                                  return Badge(
                                    label: Text(vc.totalProducts.toString()),
                                    child: Container(
                                      width: 44.w,
                                      height: 44.w,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryColor),
                                      child: AddToCartIcon(
                                        key: cc.cartIconKey,
                                        badgeOptions: const BadgeOptions(
                                          width: 0,
                                          height: 0,
                                          active: false
                                        ),
                                        icon: Image.asset(
                                          "assets/icons/basket.png",
                                          width: 20.w,
                                          height: 20.w,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                    BottomBarItem(
                        child: SvgPicture.asset(
                          "assets/icons/truck-fast.svg",
                          color: vc.bottomIndex == 3
                              ? AppColors.primaryColor
                              : null,
                        ),
                        onTap: () {
                          vc.changePage(3);
                        }),

                    BottomBarItem(
                        child: SvgPicture.asset(
                          "assets/icons/profile.svg",
                          color: vc.bottomIndex == 4
                              ? AppColors.primaryColor
                              : null,
                        ),
                        onTap: () {
                          vc.changePage(4);
                        }),

                  ],
                ),
              ),

            ],
          );
        });
  }

  //
  Widget BottomBarItem({Widget? child, Function()? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          child: Center(
            child:
            SizedBox(
                width: 24.w,
                height: 24.w,
                child: Center(child: child)),
          ),
        ),
      ),
    );
  }
}
