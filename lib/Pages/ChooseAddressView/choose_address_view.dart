import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/AddCheckoutAddressView/add_checkout_address_view.dart';
import 'package:grocery_nxt/Pages/ChooseAddressView/Controller/choose_address_controller.dart';
import 'package:grocery_nxt/Pages/ChooseAddressView/Models/shipping_addresses_model.dart';
import 'package:grocery_nxt/Pages/EditAddress/edit_address.dart';
import 'package:grocery_nxt/Pages/Payment%20Screen/payment_screen.dart';
import 'package:grocery_nxt/Pages/ProfileView/Views/ViewProfile/view_address.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../Widgets/custom_button.dart';
import '../HomeScreen/Controller/cart_controller.dart';

class ChooseAddressView extends StatelessWidget {
  ChooseAddressView({super.key, this.fromProfile = false});

  ChooseAddressController vc = Get.put(ChooseAddressController());
  bool? fromProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Choose Address",
      ),
      body: GetBuilder<ChooseAddressController>(builder: (vc) {
        return vc.loadingAddresses
            ? Center(child: CustomCircularLoader(color: AppColors.primaryColor))
            : Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 24.h,
                      ),
                      vc.addresses.isNotEmpty
                          ? ScrollbarTheme(
                            data: ScrollbarThemeData(
                                thumbColor: MaterialStateProperty.all(
                                    AppColors.primaryColor)),
                            child: Scrollbar(
                              controller: vc.scrollController,
                              trackVisibility: true,
                              thumbVisibility: true,
                              thickness: 3,
                              radius: Radius.circular(30.r),
                              child: ListView.builder(
                                  controller: vc.scrollController,
                                  reverse: true,
                                  shrinkWrap: true,
                                  itemCount: vc.addresses.length,
                                  itemBuilder: (context, index) {
                                    var address = vc.addresses[index];
                                    print(address.id);
                                    bool selected = address!.id == vc.selectedAddressId;
                                    return GestureDetector(
                                      onTap: () async{
                                        var result = await Get.to(()=> EditAddress(
                                            address: address,
                                            addressId: address.id,
                                            fromCheckout: true
                                        ));
                                        if(result != null && result is ShippingAddress){
                                          vc.selectedAddressId = result.id;
                                          vc.selectedAddress = result;
                                          vc.update();
                                          vc.getShippingCharge();
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey.shade100),
                                                top: BorderSide(color: Colors.grey.shade100))),
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
                                                      blurRadius: 2)
                                                ]),
                                            child: Image.asset(
                                                "assets/images/map.png"),
                                          ),
                                          title: Text(
                                            address.name,
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            selected?vc.selectedAddress!.address!:address.address!,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontSize: 11.sp,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          trailing: !fromProfile!
                                              ? SizedBox(
                                                width: 20.w,
                                                height: 20.w,
                                                child: Transform.scale(
                                                  scale: 1.1,
                                                  child: Radio(
                                                      value: address.id,
                                                      groupValue:
                                                          vc.selectedAddressId,
                                                      onChanged: (v) {
                                                        vc.selectedAddressId = v;
                                                        vc.selectedAddress = vc
                                                            .addresses
                                                            .firstWhere((element) =>
                                                                element.id ==
                                                                vc.selectedAddressId);
                                                        vc.update();
                                                        vc.getShippingCharge();
                                                      }),
                                                ),
                                              )
                                              : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [

                                                  IconButton(
                                                      onPressed: () async {
                                                        var result = await Get.to(()=> EditAddress(addressId: address.id,address: address));
                                                        if(result is bool){
                                                          vc.getAddresses();
                                                        }
                                                      },
                                                      icon: Icon(Icons.edit,size: 18.sp)),

                                                  !vc.addresses[index].deletingAddress! ?IconButton(onPressed: (){
                                                    vc.deleteAddress(index: index,addressId: address.id);
                                                  }, icon: Icon(Icons.delete,size: 18.sp))
                                                      : CustomCircularLoader(color: AppColors.primaryColor),

                                                ],
                                              ),

                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.24,
                              child:
                                  const Center(child: Text("No address added")),
                            ),
                      SizedBox(
                        height: 40.h,
                      ),
                  
                    ],
                  ),
                ),
              );
      }),
      bottomNavigationBar: !fromProfile!
          ? GetBuilder<ChooseAddressController>(builder: (vc) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [

                  SizedBox(height: 12.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () async {
                        var result =
                        await Get.to(() => AddCheckoutAddressView());
                        if (result == 1) {
                          vc.getAddresses();
                        }
                      },
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12.r),
                        color: AppColors.primaryColor,
                        dashPattern: const [6, 3],
                        child: ClipRRect(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                            height: 32.h,
                            margin: EdgeInsets.symmetric(horizontal: 24.w),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "Add New Address",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 12.sp,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  GetBuilder<CartController>(builder: (cc) {
                    return Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h),
                      child: Column(
                        children: [
                          SummaryItem(
                              title: "Items Total",
                              value: "\u{20B9} ${cc.subTotal}"),
                          SummaryItem(title: "Coupon Discount", value: "\u{20B9} ${cc.couponAmount}"),
                          SummaryItem(title: "Tax", value: "\u{20B9} 0.0"),
                          SummaryItem(
                              title: "Shipping Charge",
                              value: "\u{20B9} ${vc.shippingCharge}",
                              load: vc.fetchingShippingCharge
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
                          SizedBox(height: 12.h),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: CustomButton(
                              child: Text(
                                "Proceed To Payment",
                                style: TextStyle(color: Colors.white,fontSize: 13.sp),
                              ),
                              onTap: () {
                                if (vc.selectedAddress != null && !vc.fetchingShippingCharge) {
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
                  }),

                ],
              );
            })
          : const SizedBox(),
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
              : Text(value,style: TextStyle(
            fontSize: 12.sp
          ),)
        ],
      ),
    );
  }
}
