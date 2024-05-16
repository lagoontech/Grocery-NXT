import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/OrderDetailsView/Controller/order_details_controller.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:grocery_nxt/Widgets/custom_button.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';

class OrderDetailsView extends StatelessWidget {
  OrderDetailsView({super.key, this.orderId});

  int? orderId;

  OrderDetailsController orderDetailsController =
      Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {
    if(orderDetailsController.orderId==null){
      orderDetailsController.orderId = orderId;
      orderDetailsController.getOrderDetails();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Order Details",
      ),
      body: GetBuilder<OrderDetailsController>(builder: (vc) {
        return vc.isLoading
            ? Center(child: CustomCircularLoader(color: AppColors.primaryColor))
            : SingleChildScrollView(
                child: Column(
                  children: [

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12.r)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [

                            const Text("Products"),

                            ListView.builder(
                                itemCount: vc.orderDetails!.order![0].orderItem!.length,
                                shrinkWrap: true,
                                itemBuilder: (context,index){
                                  var product = vc.orderDetails!.order![0].orderItem![index];
                              return ListTile(
                                leading: CachedNetworkImage(
                                    imageUrl: product.product!.image!,
                                    width: 30.w,
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          product.product!.name!,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 10.sp)),
                                    ),
                                    Text(
                                        "${product.quantity} X ${product.price!}",
                                        style: TextStyle(fontSize: 10.sp),
                                    )
                                  ],
                                ),
                                trailing: Text( ((product.quantity!*double.parse(product.price.toString())).toStringAsFixed(0))),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    OrderDetail(
                        title: "Order Status",
                        detail: vc.orderDetails!.order![0].orderStatus!.toUpperCase()
                    ),
                    OrderDetail(
                        title: "Tax",
                        detail: vc.orderDetails!.order![0].taxAmount
                    ),
                    OrderDetail(
                        title: "Shipping Cost",
                        detail: vc.orderDetails!.order![0].shippingCost
                    ),
                    OrderDetail(
                      title: "Total",
                      detail: vc.orderDetails!.order![0].totalAmount
                    ),
                    OrderDetail(
                      title: "Payment Method",
                      detail: vc.orderDetails!.paymentDetails!.paymentGateway!.toUpperCase()
                    ),
                    OrderDetail(
                      title: "Payment Status",
                      detail: vc.orderDetails!.paymentDetails!.paymentStatus
                    ),

                    SizedBox(height: 16.h),

                    vc.orderDetails!.paymentDetails!.paymentStatus == "pending"
                        ? CustomButton(
                            child: Text("Pay Now",style: TextStyle(color: Colors.white)),
                            onTap: () {
                              vc.processPayment();
                            },
                          )
                        : SizedBox()
                  ],
                ),
              );
      }),
    );
  }

  Widget OrderDetail({String? title,String? detail}){

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(title!),
          Text(detail!),

        ],
      ),
    );
  }

}
