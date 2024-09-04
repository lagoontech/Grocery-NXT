import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/OrdersView/Controller/order_controller.dart';
import 'package:grocery_nxt/Pages/OrdersView/Widgets/order_pending_list_item.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'Widgets/order_list_item.dart';

class OrdersView extends StatelessWidget {
  OrdersView({super.key});

  OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "MY ORDERS",
          color: AppColors.primaryColor,
          elevation: 2,
          textColor: Colors.white,
      ),
      body: GetBuilder<OrderController>(builder: (vc) {
        return vc.pendingOrders.isEmpty && vc.completedOrders.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Lottie.asset("assets/animations/empty_orders.json"),
                  const Text("You have not ordered yet")
                ],
              )
            : Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: SmartRefresher(
                  controller: vc.refreshController,
                  enablePullUp: true,
                  onRefresh: () {
                    if (vc.tabController!.index == 0)
                      vc.getPendingOrders();
                    else {
                      vc.getOrders();
                    }
                    vc.refreshController.refreshCompleted();
                  },
                  onLoading: () {
                    if (vc.tabController!.index == 0) {
                      vc.getPendingOrders(isLoading: true);
                    } else {
                      vc.getOrders(isLoading: true);
                    }
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        scrolledUnderElevation: 0,
                        titleSpacing: 0,
                        pinned: true,
                        title: Container(
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 1,
                              offset: const Offset(
                                  0, 2), // changes position of shadow
                            )
                          ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    vc.currentTab = 1;
                                    vc.getPendingOrders();
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    height: kToolbarHeight,
                                    decoration: BoxDecoration(
                                      color: vc.currentTab == 1
                                          ? AppColors.primaryColor.withOpacity(0.7)
                                          : Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 1,
                                          offset: const Offset(
                                              0, 2), // changes position of shadow
                                        )
                                      ]
                                    ),
                                    child: Center(
                                      child: Text(
                                          "Pending",
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                            color: vc.currentTab != 1
                                                ? Colors.black
                                                : Colors.white
                                          ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    vc.currentTab = 2;
                                    vc.getOrders();
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    height: kToolbarHeight,
                                    decoration: BoxDecoration(
                                        color: vc.currentTab == 2
                                            ? AppColors.primaryColor.withOpacity(0.7)
                                            : Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 1,
                                            offset: const Offset(
                                                0, 2), // changes position of shadow
                                          )
                                        ]
                                    ),
                                    child: Center(
                                      child: Text("Completed",style: TextStyle(
                                          fontSize: 14.sp,
                                          color: vc.currentTab != 2
                                              ? Colors.black
                                              : Colors.white
                                      ),),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          )

                        ),
                      ),
                      vc.loadingOrders
                          ? SliverToBoxAdapter(
                              child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 2 -
                                      (kToolbarHeight +
                                          MediaQuery.of(context)
                                              .viewPadding
                                              .top)),
                              child: Center(
                                  child: CustomCircularLoader(
                                      color: AppColors.primaryColor)),
                            ))
                          : vc.currentTab == 1 &&
                                  vc.pendingOrders.isEmpty
                              ? SliverToBoxAdapter(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Lottie.asset(
                                          "assets/animations/empty_orders.json"),
                                      const Text("No pending orders")
                                    ],
                                  ),
                                )
                              : vc.currentTab == 2 &&
                                      vc.completedOrders.isEmpty
                                  ? SliverToBoxAdapter(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Lottie.asset(
                                              "assets/animations/empty_orders.json"),
                                          const Text("No completed orders")
                                        ],
                                      ),
                                    )
                                  : SliverToBoxAdapter(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              vc.tabController!.index == 0
                                                  ? vc.pendingOrders.length
                                                  : vc.completedOrders.length,
                                          itemBuilder: (context, index) {
                                            return vc.currentTab == 1
                                                ? OrderPendingListItem(
                                                    order:
                                                        vc.pendingOrders[index],
                                                  )
                                                : OrderListItem(
                                                    order: vc
                                                        .completedOrders[index],
                                                  );
                                          }),
                                    )
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
