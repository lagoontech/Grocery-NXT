import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/OrdersView/Controller/order_controller.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:lottie/lottie.dart';

import 'Widgets/order_list_item.dart';

class OrdersView extends StatelessWidget {
   OrdersView({super.key});

   OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Orders"),
      body: GetBuilder<OrderController>(
        builder: (vc) {
          return !vc.loadingOrders?Container(
            color: Colors.white,
            child: Column(
              children: [

                vc.orders.isNotEmpty?ListView.builder(
                    shrinkWrap: true,
                    itemCount: vc.orders.length,
                    itemBuilder: (context,index){
                  return OrderListItem(
                    order: vc.orders[index],
                  );
                }): Column(
                  children: [
                    Lottie.asset("assets/animations/empty_orders.json"),

                    Text("You have not ordered yet")
                  ],
                )

              ],
            ),
          ):Center(
              child: CustomCircularLoader(
                  color: AppColors.primaryColor)
          );
        }
      ),
    );
  }
}
