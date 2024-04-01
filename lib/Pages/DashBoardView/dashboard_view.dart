import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/CartView/cart_view.dart';
import 'package:grocery_nxt/Pages/CategoriesView/categories_view.dart';
import 'package:grocery_nxt/Pages/DashBoardView/BottomBar/bottom_bar.dart';
import 'package:grocery_nxt/Pages/DashBoardView/Controller/dashboard_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/home_screen.dart';
import 'package:grocery_nxt/Pages/OrdersView/orders_view.dart';
import 'package:grocery_nxt/Pages/ProfileView/profile_view.dart';

class DashboardView extends StatelessWidget {
   DashboardView({super.key});

   DashboardController vc = Get.put(DashboardController());
   CartController cc = Get.put(CartController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: vc.pageController,
        children: [

          HomeScreen(),

          CategoriesView(),

          CartView(),

          OrdersView(),

          ProfileView()

        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
