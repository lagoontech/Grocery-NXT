import 'package:flutter/material.dart';
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
      appBar: CustomAppBar(title: "Orders"),
      body: GetBuilder<OrderController>(builder: (vc) {
        return vc.loadingOrders
            ? Center(child: CustomCircularLoader(color: AppColors.primaryColor))
            : vc.pendingOrders.isEmpty && vc.completedOrders.isEmpty
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
                      onRefresh: (){
                        if(vc.tabController!.index==0)
                          vc.getPendingOrders();
                        else{
                          vc.getOrders();
                        }
                        vc.refreshController.refreshCompleted();
                      },
                      onLoading: (){
                        if(vc.tabController!.index==0) {
                          vc.getPendingOrders(isLoading: true);
                        } else{
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
                                  offset: const Offset(0, 2), // changes position of shadow
                                )
                              ]),
                              child: TabBar(
                                  controller: vc.tabController,
                                  dividerColor: Colors.transparent,
                                  labelStyle: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                  tabs: const [
                                    Tab(
                                      text: "Pending",
                                    ),
                                    Tab(
                                      text: "Delivered",
                                    ),
                                  ]),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: vc.tabController!.index == 0
                                    ? vc.pendingOrders.length
                                    : vc.completedOrders.length,
                                itemBuilder: (context, index) {
                                  return vc.tabController!.index==0
                                      ? OrderPendingListItem(
                                    order: vc.pendingOrders[index],
                                  ):OrderListItem(
                                    order: vc.completedOrders[index],
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
