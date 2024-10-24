import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/CartView/cart_view.dart';
import 'package:grocery_nxt/Pages/CategoriesView/categories_view.dart';
import 'package:grocery_nxt/Pages/DashBoardView/BottomBar/bottom_bar.dart';
import 'package:grocery_nxt/Pages/DashBoardView/Controller/dashboard_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/home_screen.dart';
import 'package:grocery_nxt/Pages/OrdersView/orders_view.dart';
import 'package:grocery_nxt/Pages/ProfileView/Views/WishlistView/Controller/wishlist_controller.dart';
import 'package:grocery_nxt/Pages/ProfileView/profile_view.dart';

class DashboardView extends StatelessWidget {
   DashboardView({super.key});

   DashboardController vc = Get.put(DashboardController());
   CartController      cc = Get.put(CartController());
   WishlistController  wc = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {

    return DoubleBack(
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: vc.pageController,
          children: [
      
            HomeScreen().animate(effects: [
              const FadeEffect(
                  duration: Duration(milliseconds: 480),
                  begin: 0.4
              )]),
      
            CategoriesView().animate(effects: [const FadeEffect(duration: Duration(milliseconds: 480),
                begin: 0.4)]),
      
            CartView(showBack: false).animate(effects: [const FadeEffect(duration: Duration(milliseconds: 480),
                begin: 0.4)]),
      
            OrdersView().animate(effects: [const FadeEffect(duration: Duration(milliseconds: 480),
                begin: 0.4)]),
      
            ProfileView().animate(effects: [const FadeEffect(duration: Duration(milliseconds: 480),
                begin: 0.4)])
      
          ],
        ),
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}
