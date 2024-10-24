import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/ChooseAddressView/Controller/choose_address_controller.dart';
import 'package:grocery_nxt/Pages/Payment%20Screen/Controller/payment_controller.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../Constants/app_colors.dart';
import '../../Widgets/custom_button.dart';
import '../HomeScreen/Controller/cart_controller.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});

  PaymentController vc                      = Get.put(PaymentController());
  CartController    cc                      = Get.find<CartController>();
  ChooseAddressController addressController = Get.find<ChooseAddressController>();

  @override
  Widget build(BuildContext context) {

    return GetBuilder<PaymentController>(
      builder: (vc) {
        return Stack(
          children: [
            Scaffold(
              appBar: CustomAppBar(
                title: 'Payment Screen',
              ),
              body: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      "Shipping To",
                      style: TextStyle(
                          color: const Color(0xff2B3241),
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16.h),
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 2,
                                offset: const Offset(0, 1))
                          ]),
                      child: ListTile(
                        leading: Container(
                          width: 55.w,
                          height: 55.w,
                          padding: EdgeInsets.symmetric(vertical: 0.8.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 3,
                                )
                              ]),
                          child: Stack(
                            children: [
                              Image.asset("assets/images/map.png",width: 55.w),
                              Center(
                                child: Container(
                                  width: 30.w,
                                  height: 30.w,
                                  decoration: const BoxDecoration(
                                      color: Colors.white, shape: BoxShape.circle),
                                  child: const Icon(Icons.location_on),
                                ),
                              )
                            ],
                          ),
                        ),
                        title: Text(addressController.selectedAddress!.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            )),
                        subtitle: Text(addressController.selectedAddress!.address!,style: TextStyle(
                          fontSize: 12.sp,
                        ),),
                      ),
                    ),
                    Text(
                      "Add Payment Method",
                      style: TextStyle(
                          color: const Color(0xff2B3241),
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp),
                    ),
                    GetBuilder<PaymentController>(builder: (vc) {
                      return vc.loadingPaymentOptions
                          ? SizedBox(
                        height: 50.h,
                        child: Padding(
                            padding: EdgeInsets.only(top: 16.h),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return Skeletonizer(
                                    child: Container(
                                      padding: EdgeInsets.all(2.w),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(2.r),
                                        child: CachedNetworkImage(
                                          imageUrl: "",
                                          errorWidget: (b,s,o){
                                            return Image.asset("assets/images/gnxt_logo.png");
                                          },
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  );
                                })
                        ),
                      )
                          : Column(
                        children: [
                          SizedBox(height: 16.h),
                          SizedBox(
                            height: 32.h,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: vc.options.length,
                                itemBuilder: (context, index) {
                                  var option = vc.options[index];
                                  return option.status == 1
                                      ? GestureDetector(
                                    onTap: () {
                                      vc.selectedOption = option;
                                      vc.update();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(2.w),
                                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8.r),
                                          border: Border.all(
                                              color:
                                              vc.selectedOption == option
                                                  ? AppColors.primaryColor
                                                  : Colors.transparent,
                                              width: 0.8)),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(2.r),
                                        child: CachedNetworkImage(
                                          imageUrl: option.image!,
                                          fit: BoxFit.fitWidth,
                                          width: 64.w,
                                          height: 28.h,
                                        ),
                                      ),
                                    ),
                                  )
                                      : const SizedBox();
                                }),
                          ),
                        ],
                      );
                    })
                  ],
                ),
              ),
              bottomNavigationBar: GetBuilder<PaymentController>(builder: (vc) {
                return !vc.confirmingPayment?Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 12.h),
                      GetBuilder<ChooseAddressController>(builder: (ac) {
                        return Padding(
                          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h),
                          child: Column(
                            children: [
                              SummaryItem(
                                  title: "Items Total",
                                  value: "\u{20B9} ${cc.subTotal}"),
                              SummaryItem(
                                  title: "Coupon Discount",
                                  value: "\u{20B9} ${cc.couponAmount}"),
                              SummaryItem(
                                  title: "Tax",
                                  value: "\u{20B9} 0.0"),
                              SummaryItem(
                                  title: "Shipping Charge",
                                  value: "\u{20B9} "+ac.shippingCharge,
                                  load: ac.fetchingShippingCharge
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Divider(
                                  thickness: 0.4,
                                  height: 0.1,
                                ),
                              ),
                              SummaryItem(
                                  title: "Total",
                                  value: "\u{20B9} ${cc.total}"),
                            ],
                          ),
                        );
                      }),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.8,
                        child: CustomButton(
                          child: !vc.isPlacingOrder
                              ? const Text("Place Order",
                                  style: TextStyle(color: Colors.white))
                              : CustomCircularLoader(),
                          onTap: () {
                            if (!vc.isPlacingOrder && !vc.confirmingPayment) {
                              vc.placeOrder();
                            }
                            //Get.to(() => const OrderSuccessScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                ):const SizedBox();
              }),
            ),

            vc.confirmingPayment
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
                              border: Border.all(color: AppColors.primaryColor)
                            ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                vc.successResponse!=null
                                    ? Text("Order Id: ${vc.successResponse!.orderId}")
                                    : const SizedBox(),

                                AnimatedTextKit(
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                      'Confirming Payment',
                                      textStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                      speed: const Duration(milliseconds: 50),
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
      }
    );
  }

  //
  Widget SummaryItem({String title = "", String value = "",bool load = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: TextStyle(
            fontSize: 12.sp
          ),),
          load
              ? Skeletonizer(child: Text(value))
              : Text(
              value,
              style: TextStyle(
                  color: title == "Total"
                      ? AppColors.primaryColor
                      : Colors.black,
                  fontWeight: title == "Total"
                      ? FontWeight.w600
                      : FontWeight.w500,
                  fontSize: 12.sp
              ))
        ],
      ),
    );
  }

}
