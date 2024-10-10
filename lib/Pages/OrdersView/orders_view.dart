import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/OrdersView/Controller/order_controller.dart';
import 'package:grocery_nxt/Pages/OrdersView/Widgets/ontheway_order_list_item.dart';
import 'package:grocery_nxt/Pages/OrdersView/Widgets/order_pending_list_item.dart';
import 'package:grocery_nxt/Pages/OrdersView/Widgets/picked_order_list_item.dart';
import 'package:grocery_nxt/Pages/OrdersView/Widgets/processed_order_list_item.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:lottie/lottie.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'Widgets/order_list_item.dart';

class OrdersView extends StatelessWidget {
  OrdersView({super.key});

  OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
        title: "Orders View",
        textColor: Colors.white,
        color: AppColors.primaryColor,
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
                    if (vc.currentTab == 0) {
                      vc.getPendingOrders();
                    } else if (vc.currentTab == 1) {
                      vc.getProcessedOrders();
                    } else if (vc.currentTab == 4) {
                      vc.getOrders();
                    }
                    vc.refreshController.refreshCompleted();
                  },
                  onLoading: () {
                    if (vc.currentTab == 0) {
                      vc.getPendingOrders(isLoading: true);
                    } else if (vc.currentTab == 1) {
                      vc.getProcessedOrders(isLoading: true);
                    } else if (vc.currentTab == 4) {
                      vc.getOrders(isLoading: true);
                    }
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(height: 12.h),
                      ),
                      SliverAppBar(
                          backgroundColor: Colors.white,
                          scrolledUnderElevation: 0,
                          titleSpacing: 0,
                          toolbarHeight: kToolbarHeight * 2,
                          pinned: true,
                          title: Column(
                            children: [
                              Center(
                                child: PreferredSize(
                                    preferredSize: const Size.fromHeight(50.0),
                                    child: GetBuilder<OrderController>(
                                        builder: (vc) {
                                      return MaterialSegmentedControl(
                                        children: {
                                          0: tab(title: "Payment Pending"),
                                          1: tab(title: "Processing"),
                                          2: tab(title: "Picked by courier"),
                                          3: tab(title: 'On the way'),
                                          4: tab(title: "Completed"),
                                        },
                                        selectionIndex: vc.currentTab,
                                        borderColor: AppColors.primaryColor,
                                        selectedColor: AppColors.primaryColor,
                                        unselectedColor: Colors.white,
                                        selectedTextStyle: const TextStyle(
                                            color: Colors.white),
                                        unselectedTextStyle: const TextStyle(
                                            color: Colors.black),
                                        horizontalPadding: EdgeInsets.symmetric(
                                            horizontal: 8.w),
                                        borderWidth: 0.7,
                                        borderRadius: 16.w,
                                        onSegmentTapped: (index) {
                                          vc.currentTab = index;
                                          if (index == 0) {
                                            vc.getPendingOrders();
                                          } else if (index == 1) {
                                            vc.getProcessedOrders();
                                          } else if (index == 2) {
                                            vc.getPickedByCourierOrders();
                                          } else if (index == 4) {
                                            vc.getOrders();
                                          } else if (index == 3) {
                                            vc.getOnTheWayOrders();
                                          }
                                          vc.update();
                                        },
                                      );
                                    })),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                  vc.currentTab == 0
                                      ? "Payment not yet completed"
                                      : vc.currentTab == 1
                                          ? "Order is currently being packed or prepared"
                                          : vc.currentTab == 2
                                              ? "Your order was picked by the courier"
                                              : vc.currentTab == 4
                                                  ? "Your order was delivered"
                                                  : "Your order is on the way",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey.shade700))
                            ],
                          )),
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
                          : vc.currentTab == 0 && vc.pendingOrders.isEmpty
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
                              : vc.currentTab == 1 && vc.processedOrders.isEmpty
                                  ? SliverToBoxAdapter(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Lottie.asset(
                                              "assets/animations/empty_orders.json"),
                                          const Text("No orders")
                                        ],
                                      ),
                                    )
                                  : vc.currentTab == 2 &&
                                          vc.pickedOrders.isEmpty
                                      ? SliverToBoxAdapter(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Lottie.asset(
                                                  "assets/animations/empty_orders.json"),
                                              const Text("No orders")
                                            ],
                                          ),
                                        )
                                      : vc.currentTab == 3 &&
                                              vc.onthewayOrders.isEmpty
                                          ? SliverToBoxAdapter(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Lottie.asset(
                                                      "assets/animations/empty_orders.json"),
                                                  const Text(
                                                      "No orders")
                                                ],
                                              ),
                                            )
                                          : SliverToBoxAdapter(
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.only(
                                                      top: 12.h),
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: vc.currentTab == 0
                                                      ? vc.pendingOrders.length
                                                      : vc.currentTab == 1
                                                          ? vc.processedOrders
                                                              .length
                                                          : vc.currentTab == 2
                                                              ? vc.pickedOrders
                                                                  .length
                                                              : vc.currentTab ==
                                                                      4
                                                                  ? vc.completedOrders
                                                                      .length
                                                                  : vc.onthewayOrders
                                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return vc.currentTab == 0
                                                        ? OrderPendingListItem(
                                                            order:
                                                                vc.pendingOrders[
                                                                    index],
                                                          )
                                                        : vc.currentTab == 4
                                                            ? OrderListItem(
                                                                order:
                                                                    vc.completedOrders[
                                                                        index],
                                                              )
                                                            : vc.currentTab == 1
                                                                ? ProcessedOrderItem(
                                                                    order: vc
                                                                            .processedOrders[
                                                                        index])
                                                                : vc.currentTab ==
                                                                        2
                                                                    ? PickedOrderListItem(
                                                                        order: vc.pickedOrders[
                                                                            index])
                                                                    : OnthewayOrderListItem(
                                                                        order: vc
                                                                            .onthewayOrders[index]);
                                                  }),
                                            )
                    ],
                  ),
                ),
              );
      }),
    );
  }

  //
  Widget tab({String title = ""}) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12.sp, fontFamily: "roboto"),
      ),
    );
  }
}
