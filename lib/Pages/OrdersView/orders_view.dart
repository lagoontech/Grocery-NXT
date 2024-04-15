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
      body: GetBuilder<OrderController>(builder: (vc) {
        return vc.loadingOrders
            ? Center(child: CustomCircularLoader(color: AppColors.primaryColor))
            : vc.orders.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Lottie.asset("assets/animations/empty_orders.json"),
                      const Text("You have not ordered yet")
                    ],
                  )
                : Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: vc.orders.length,
                              itemBuilder: (context, index) {
                                return OrderListItem(
                                  order: vc.orders[index],
                                );
                              })
                        ],
                      ),
                    ),
                  );
      }),
    );
  }
}
