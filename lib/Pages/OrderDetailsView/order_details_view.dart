import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/OrderDetailsView/Controller/order_details_controller.dart';
import 'package:grocery_nxt/Pages/OrderDetailsView/Widgets/order_products.dart';
import 'package:grocery_nxt/Utils/date_utils.dart';
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
    if (orderDetailsController.orderId == null) {
      orderDetailsController.orderId = orderId;
      print(orderId);
      orderDetailsController.getOrderDetails();
    }
    return WillPopScope(
      onWillPop: (){
        if(!orderDetailsController.updatingPayment){
          return Future.value(true);
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Order Details",
        ),
        body: GetBuilder<OrderDetailsController>(builder: (vc) {
          return vc.isLoading
              ? Center(
                  child: CustomCircularLoader(color: AppColors.primaryColor))
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.w, top: 12.h),
                            child: Text(
                              "Order Id - ${orderDetailsController.orderDetails!.paymentDetails!.invoiceNumber.toString()}",
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 13.sp),
                            ),
                          ),
                          Divider(
                            color: Colors.grey.shade300,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 12.w, right: 12.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      orderDetailsController
                                              .orderDetails!.order!.isNotEmpty
                                          ? Text(
                                              "${orderDetailsController.orderDetails!.order![0].orderItem!.length.toString()} Items in Basket",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            )
                                          : const SizedBox(),
                                      GestureDetector(
                                          onTap: () {
                                            Get.to(() => OrderProducts(
                                                details: orderDetailsController
                                                    .orderDetails));
                                          },
                                          child: Text("View",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primaryColor,
                                              )))
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                SizedBox(
                                  height: 70.h,
                                  child: ListView.separated(
                                      separatorBuilder: (c, s) {
                                        return SizedBox(width: 8.w);
                                      },
                                      padding: EdgeInsets.only(left: 12.w),
                                      itemCount: vc.orderDetails!.order![0]
                                          .orderItem!.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        var product = vc.orderDetails!.order![0]
                                            .orderItem![index];
                                        return Container(
                                          padding: EdgeInsets.all(4.w),
                                          child: Container(
                                            width: 75.w,
                                            height: 75.w,
                                            clipBehavior: Clip.hardEdge,
                                            padding: EdgeInsets.all(2.w),
                                            decoration: BoxDecoration(
                                                //shape: BoxShape.circle,
                                                //border: Border.all(color: AppColors.primaryColor)
                                                ),
                                            child: Transform.scale(
                                              scale: 1.5,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    product.product!.image!,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                SizedBox(height: 12.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 12.w),
                                  child: Text(
                                    "\u{20B9} ${vc.orderDetails!.order![0].totalAmount!}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.shade300,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 12.w, top: 8.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 28.w,
                                        height: 28.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.check,
                                            color: Colors.white),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                          "Order confirmed - ${DateFormatUtil().displayFormat(dateTime: vc.orderDetails!.orderTrack!.createdAt)}"),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 12.w, top: 8.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 28.w,
                                        height: 28.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.delivery_dining,
                                            color: Colors.white),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                          "Delivery cost \u{20B9} - ${vc.orderDetails!.order![0].shippingCost!}"),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 12.w, top: 8.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 28.w,
                                        height: 28.h,
                                        padding: EdgeInsets.all(2.w),
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                            Icons.payment_outlined,
                                            color: Colors.white),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                          "Payment status - ${vc.orderDetails!.paymentDetails!.paymentStatus}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 6.w, right: 6.w),
                            child: Column(
                              children: [
                                /*OrderDetail(
                                    title: "Order Status",
                                    detail: vc.orderDetails!.order![0].orderStatus!
                                        .toUpperCase()),
                                OrderDetail(
                                    title: "Tax",
                                    detail: vc.orderDetails!.order![0].taxAmount),
                                OrderDetail(
                                    title: "Shipping Cost",
                                    detail: vc.orderDetails!.order![0].shippingCost),
                                OrderDetail(
                                    title: "Total",
                                    detail: vc.orderDetails!.order![0].totalAmount),
                                OrderDetail(
                                    title: "Payment Method",
                                    detail: vc
                                        .orderDetails!.paymentDetails!.paymentGateway!
                                        .toUpperCase()),
                                OrderDetail(
                                    title: "Payment Status",
                                    detail: vc
                                        .orderDetails!.paymentDetails!.paymentStatus),*/
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          vc.orderDetails!.paymentDetails!.paymentStatus ==
                                  "pending"
                              ? Center(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: CustomButton(
                                      child: const Text("Pay Now",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      onTap: () {
                                        vc.processPayment();
                                      },
                                    ),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    vc.updatingPayment
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.black.withOpacity(0.05),
                            child: Material(
                              color: Colors.transparent,
                              child: Center(
                                  child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 90.h,
                                margin: EdgeInsets.symmetric(horizontal: 32.w),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                        color: AppColors.primaryColor)),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      vc.successResponse != null
                                          ? Text(
                                              "Order Id: ${vc.orderId!}")
                                          : const SizedBox(),
                                      AnimatedTextKit(
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                            'Confirming Payment',
                                            textStyle: TextStyle(
                                              fontSize: 16.sp,
                                              color: AppColors.primaryColor,
                                            ),
                                            speed: const Duration(
                                                milliseconds: 50),
                                          ),
                                        ],
                                        totalRepeatCount: 8,
                                        pause: const Duration(milliseconds: 10),
                                        displayFullTextOnTap: true,
                                        stopPauseOnTap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            ),
                          )
                        : const SizedBox()
                  ],
                );
        }),
      ),
    );
  }

  //
  Widget OrderDetail({String? title, String? detail}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title!),
          Text(detail!,
              style: TextStyle(
                  color: detail == "pending" ? Colors.red : Colors.black)),
        ],
      ),
    );
  }
}
