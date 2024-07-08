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

  PaymentController vc = Get.put(PaymentController());
  CartController cc = Get.find<CartController>();
  ChooseAddressController addressController =
      Get.find<ChooseAddressController>();

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
                          fontSize: 16.sp),
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
                                offset: Offset(0, 1))
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
                                  child: Icon(Icons.location_on),
                                ),
                              )
                            ],
                          ),
                        ),
                        title: Text(addressController.selectedAddress!.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            )),
                        subtitle: Text(addressController.selectedAddress!.address!),
                      ),
                    ),
                    Text(
                      "Add Payment Method",
                      style: TextStyle(
                          color: const Color(0xff2B3241),
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp),
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
                                      : SizedBox();
                                }),
                          ),
                        ],
                      );
                    })
                  ],
                ),
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(left: 40.w, right: 40.w, bottom: 16.h),
                child: GetBuilder<PaymentController>(builder: (vc) {
                  return CustomButton(
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
                  );
                }),
              ),
            ),

          vc.confirmingPayment?Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.1),
              child: Center(child: CustomCircularLoader())):SizedBox()

        ],
        );
      }
    );
  }
}
