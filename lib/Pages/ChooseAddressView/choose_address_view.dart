import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/AddCheckoutAddressView/add_checkout_address_view.dart';
import 'package:grocery_nxt/Pages/ChooseAddressView/Controller/choose_address_controller.dart';
import 'package:grocery_nxt/Pages/Payment%20Screen/payment_screen.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';

import '../../Widgets/custom_button.dart';
import '../HomeScreen/Controller/cart_controller.dart';

class ChooseAddressView extends StatelessWidget {
  ChooseAddressView({super.key, this.fromProfile = false});

  ChooseAddressController vc = Get.put(ChooseAddressController());
  bool ?fromProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Choose Address",
      ),
      body: GetBuilder<ChooseAddressController>(
          builder: (vc) {
            return vc.loadingAddresses
                ? Center(
                child: CustomCircularLoader(color: AppColors.primaryColor))
                : Container(
              color: Colors.white,
              child: Column(
                children: [

                  SizedBox(
                    height: 24.h,
                  ),

                  vc.addresses.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: vc.addresses.length,
                      itemBuilder: (context, index) {
                        var address = vc.addresses[index];
                        return Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade100
                                  ),
                                  top: BorderSide(
                                      color: Colors.grey.shade100
                                  )
                              )
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 55.w,
                              height: 55.w,
                              padding: EdgeInsets.all(0.4.w),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 2
                                    )
                                  ]
                              ),
                              child: Image.asset("assets/images/map.png"),
                            ),
                            title: Text(address.name, style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),),
                            subtitle: Text(address.address!),
                            trailing: !fromProfile! ? Radio(
                                value: address.id,
                                groupValue: vc.selectedAddressId,
                                onChanged: (v) {
                                  vc.selectedAddressId = v;
                                  vc.selectedAddress
                                  = vc.addresses.firstWhere((element) =>
                                  element.id == vc.selectedAddressId);
                                  vc.update();
                                  vc.getShippingCharge();
                                }
                            ) : const SizedBox(),
                          ),
                        );
                      }) : SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.24,
                    child: const Center(child: Text(
                        "No address added"
                    )),
                  ),

                  SizedBox(
                    height: 90.h,
                  ),

                  InkWell(
                    onTap: () {
                      Get.to(() => AddCheckoutAddressView());
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        color: AppColors.primaryColor,
                        dashPattern: const [6, 3],
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(
                              12)),
                          child: Container(
                            height: 52.h,
                            margin: EdgeInsets.symmetric(horizontal: 24.w),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Icon(
                                  Icons.add,
                                  color: AppColors.primaryColor,
                                ),

                                SizedBox(width: 4.w),

                                Text("Add New Address", style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 14.sp,
                                ),)

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
      ),
      bottomNavigationBar: !fromProfile! ? GetBuilder<ChooseAddressController>(
          builder: (vc) {
            return Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [

                  GetBuilder<CartController>(
                      builder: (cc) {
                        return Column(
                          children: [

                            SummaryItem(
                                title: "Items Total",
                                value: "\u{20B9} ${cc.total}"
                            ),
                            SummaryItem(
                                title: "Coupon Discount",
                                value: "0"
                            ),
                            SummaryItem(
                                title: "Tax",
                                value: "0"
                            ),
                            SummaryItem(
                                title: "Shipping Charge",
                                value: vc.shippingCharge
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
                                value: "\u{20B9} ${vc.finalTotal}"
                            ),

                            SizedBox(
                                height: 12.h
                            )

                          ],
                        );
                      }
                  ),

                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.8,
                    child: CustomButton(
                      child: const Text(
                        "Proceed To Payment",
                        style: TextStyle(color: Colors.white),),
                      onTap: () {
                        if (vc.selectedAddress != null) {
                          Get.to(() => PaymentScreen());
                          return;
                        }
                        ToastUtil().showToast(
                            message: "Choose an address to continue");
                      },
                    ),
                  ),

                ],
              ),
            );
          }
      ) : const SizedBox(),
    );
  }

  //
  Widget SummaryItem({String title = "", String value = ""}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(title),

          Text(value)

        ],
      ),
    );
  }

}
