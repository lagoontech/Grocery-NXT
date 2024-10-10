import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/OrderDetailsView/Controller/order_details_controller.dart';
import 'package:grocery_nxt/Pages/OrderDetailsView/Widgets/order_products.dart';
import 'package:grocery_nxt/Utils/date_utils.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:grocery_nxt/Widgets/custom_button.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';

class OrderDetailsView extends StatelessWidget {
  OrderDetailsView({super.key, this.orderId,this.orderStatus});

  int? orderId;
  String ?orderStatus;

  OrderDetailsController orderDetailsController =
      Get.put(OrderDetailsController());

  int ?activeStep;

  @override
  Widget build(BuildContext context) {

    if(orderStatus == "Processing"){
      activeStep = 1;
    }else if(orderStatus == "Picked by courier"){
      activeStep = 2;
    }else if(orderStatus == "On the way"){
      activeStep = 3;
    }else if(orderStatus == "Delivered"){
      activeStep = 4;
    }

    if (orderDetailsController.orderId == null) {
      orderDetailsController.orderId = orderId;
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
              : DefaultTextStyle(
                style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black,
                    fontFamily: GoogleFonts.lato().fontFamily),
                child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: EdgeInsets.only(left: 16.w, top: 12.h),
                                  child: Text(
                                    "Order Id - ${orderDetailsController.orderDetails!.order![0].id}",
                                    style: TextStyle(
                                        color: Colors.grey.shade500, fontSize: 13.sp),
                                  ),
                                ),

                                Container(
                                    margin: EdgeInsets.only(right: 16.w, top: 12.h),
                                    padding: EdgeInsets.all(4.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.primaryColor,width: 0.6),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                        orderDetailsController.orderDetails!.paymentDetails!.paymentGateway!.replaceAll("_"," ").capitalize!,
                                        style: TextStyle(
                                          letterSpacing: 1,
                                          color: AppColors.primaryColor
                                        ),
                                    ))

                              ],
                            ),

                            Divider(
                              color: Colors.grey.shade300,
                            ),

                            Container(
                              margin: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
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
                                        itemCount: vc.orderDetails!.order![0].orderItem!.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          var product = vc.orderDetails!.order![0].orderItem![index];
                                          return Container(
                                            padding: EdgeInsets.all(4.w),
                                            child: Container(
                                              width: 75.w,
                                              height: 75.w,
                                              padding: EdgeInsets.all(2.w),
                                              child: Transform.scale(
                                                scale: 1.5,
                                                child: CachedNetworkImage(
                                                  imageUrl: product.product!.image!,
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
                                      "\u{20B9} ${double.parse(vc.orderDetails!.order![0].totalAmount!)+double.parse(vc.orderDetails!.order![0].shippingCost!)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade300,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.w, top: 8.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 28.w,
                                          height: 28.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.check,color: Colors.white,size: 18.sp),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text("Order confirmed - ${DateFormatUtil().displayFormat(dateTime: vc.orderDetails!.orderTrack!.createdAt)}"),
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
                                          child: Icon(Icons.delivery_dining,
                                              color: Colors.white,size: 18.sp),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                            "Delivery cost - \u{20B9}${vc.orderDetails!.order![0].shippingCost!}"),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.w, top: 8.h),
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
                                          child: Icon(
                                              Icons.payment_outlined,
                                              color: Colors.white,size: 18.sp),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text("Payment status - ${vc.orderDetails!.paymentDetails!.paymentStatus!.capitalize!}"),

                                      ],
                                    ),
                                  ),

                                  orderStatus != "Delivered"? Padding(
                                    padding: EdgeInsets.only(left: 12.w, top: 8.h),
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
                                          child: Icon(
                                              Icons.calendar_month,
                                              color: Colors.white,size: 18.sp),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text("Expected Delivery - ${calculateExpectedDelivery()}")

                                      ],
                                    ),
                                  ): const SizedBox(),

                                ],
                              ),
                            ),

                            activeStep!=null? Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: EasyStepper(
                                activeStep: activeStep!,
                                activeStepTextColor: Colors.black87,
                                finishedStepTextColor: AppColors.primaryColor,
                                internalPadding: 0,
                                showLoadingAnimation: false,
                                stepRadius: 22,
                                showStepBorder: false,
                                steps: [

                                  EasyStep(
                                    topTitle: true,
                                    customStep: stepperItem(
                                      orderStatus: "Processing",
                                      isActive: activeStep! >= 1
                                    ),
                                    customTitle: Center(
                                      child: Text(
                                        "Processing",
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: orderStatus == "Processing"
                                              ? AppColors.primaryColor
                                              : Colors.black
                                        )
                                      ),
                                    ),
                                  ),

                                  EasyStep(
                                    customStep: stepperItem(
                                        orderStatus: "Picked by courier",
                                        isActive: activeStep! >= 2
                                    ),
                                    customTitle: Center(
                                      child: Text(
                                          "Picked by courier",
                                          style: TextStyle(
                                              fontSize: 10.sp
                                          )
                                      ),
                                    ),
                                    topTitle: true,
                                  ),

                                  EasyStep(
                                    topTitle: true,
                                    customStep: stepperItem(
                                        orderStatus: "On the way",
                                        isActive: activeStep! >=3
                                    ),
                                    customTitle: Center(
                                      child: Text(
                                          "On the way",
                                          style: TextStyle(
                                              fontSize: 10.sp
                                          )
                                      ),
                                    ),
                                  ),

                                  EasyStep(
                                    customStep: stepperItem(
                                       orderStatus: "Delivered",
                                        isActive: activeStep == 4
                                    ),
                                    customTitle: Center(
                                      child: Text(
                                          "Delivered",
                                          style: TextStyle(
                                              fontSize: 10.sp
                                          )
                                      ),
                                    ),
                                    topTitle: true,
                                  )

                                ],
                                onStepReached: (index){},
                              ),
                            ) : const SizedBox(),

                            SizedBox(height: 16.h),

                            vc.orderDetails!.paymentDetails!.paymentStatus ==
                                    "pending" && vc.orderDetails!.paymentDetails!.paymentGateway != "cash_on_delivery"
                                ? Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.9,
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
                  ),
              );
        }),
      ),
    );
  }

  //
  Widget stepperItem({
    String ?orderStatus,
    Color ?color,
    bool ?isActive,
    bool isImage = false
  }){

    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive!
            ? AppColors.primaryColor
            : Colors.white,
        border: Border.all(color: Colors.grey.shade200)
      ),
      child: isImage ? Image.asset("assets/images/${orderStatus}.jpeg") : Icon(
          orderStatus == "Processing"
              ? Icons.backpack
              : orderStatus == "Picked by courier"
              ? Icons.shopping_bag
              : orderStatus == "On the way"
              ? Icons.directions_bus
              : Icons.check,
          color: isActive
              ? Colors.white
              : Colors.black,
      )
    );

  }

  //
  String calculateExpectedDelivery(){

    var orderedDate = orderDetailsController.orderDetails!.order![0].order!.createdAt;

    var state = orderDetailsController.orderDetails!.paymentDetails!.address!.state!.name;
    if(state == "Tamil Nadu" || state == "Kerala" || state == "Karnataka"){
      orderDetailsController.expectedDeliveryDate = orderedDate!.add(const Duration(days: 4));
    }else if(state == "Andhra Pradesh" || state == "Telangana"){
      orderDetailsController.expectedDeliveryDate = orderedDate!.add(const Duration(days: 6));
    }else {
      orderDetailsController.expectedDeliveryDate = orderedDate!.add(const Duration(days: 8));
    }
    return DateFormatUtil().displayFormat(dateTime: orderDetailsController.expectedDeliveryDate);

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
