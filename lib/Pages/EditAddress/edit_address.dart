import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/ChooseAddressView/Models/shipping_addresses_model.dart';
import 'package:grocery_nxt/Pages/EditAddress/Controller/edit_address_controller.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:grocery_nxt/Widgets/custom_button.dart';
import '../../Constants/app_colors.dart';
import '../../Widgets/custom_circular_loader.dart';
import '../../Widgets/custom_list_view.dart';
import '../../Widgets/custom_textfield.dart';

class EditAddress extends StatelessWidget {
   EditAddress({super.key,this.addressId,this.address,this.fromCheckout = false});

   int ?addressId;
   ShippingAddress ?address;
   EditAddressController vc = Get.put(EditAddressController());
   bool fromCheckout = false;

  @override
  Widget build(BuildContext context) {

    if(vc.addressId == null){
      vc.addressId = addressId;
      vc.address = address;
      vc.setAddressValues();
    }

    return Scaffold(
      appBar: CustomAppBar(title: fromCheckout ?"Edit/Choose Address":"Edit Address",action: TextButton(
          onPressed: (){
            vc.chooseAddress();
          },
          child: Text("Choose",style: TextStyle(color: AppColors.primaryColor),)
      ),),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Delivery Address",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp),
                      ),
                    ),
                  ],
                ),
                label("Title"),
                customTextField(context,
                    borderRadius: 12.r,
                    borderColor: const Color(0xffD7DFE9),
                    hint: "Enter a title",
                    controller: vc.titleTEC,
                    onChanged: (v) {}),
                label("Email"),
                customTextField(context,
                    borderRadius: 12.r,
                    borderColor: const Color(0xffD7DFE9),
                    hint: "Enter your email",
                    controller: vc.emailTEC,
                    onChanged: (v) {}),
                label("Phone"),
                customTextField(context,
                    borderRadius: 12.r,
                    borderColor: const Color(0xffD7DFE9),
                    hint: "Enter a phone number",
                    textInputType: TextInputType.number,
                    controller: vc.phoneTEC,
                    onChanged: (v) {}),
                GetBuilder<EditAddressController>(builder: (vc) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label("State"),
                      customTextField(context,
                          readOnly: true,
                          controller: vc.stateTEC,
                          borderRadius: 12.r,
                          borderColor: const Color(0xffD7DFE9),
                          hint: "Select a state", onTap: () {
                            showStatesBottomSheet(context);
                          }),
                    ],
                  );
                }),
                GetBuilder<EditAddressController>(builder: (vc) {
                  return vc.selectedState != null
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label("City"),
                      customTextField(context,
                          readOnly: true,
                          controller: vc.cityTEC,
                          borderRadius: 12.r,
                          borderColor: const Color(0xffD7DFE9),
                          hint: "Select a city", onTap: () {
                            showCitiesBottomSheet(context);
                          }),
                    ],
                  )
                      : const SizedBox();
                }),
                label("Address"),
                customTextField(context,
                    borderRadius: 12.r,
                    borderColor: const Color(0xffD7DFE9),
                    hint: "Enter an address",
                    controller: vc.addressTEC,
                    onChanged: (v) {}),
                label("Zipcode"),
                customTextField(context,
                    borderRadius: 12.r,
                    borderColor: const Color(0xffD7DFE9),
                    textInputType: TextInputType.number,
                    hint: "Enter zipcode",
                    controller: vc.zipcodeTEC,
                    onChanged: (v) {
                      if(v!.length==6){
                        vc.getShippingCharge();
                      }
                    }),
                SizedBox(height: 8.h),
                GetBuilder<EditAddressController>(builder: (vc){
                  return vc.fetchingShippingCharge
                      ? AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Calculating delivery charge',
                        textStyle: TextStyle(
                          fontSize: 12.0.sp,
                          color: AppColors.primaryColor,
                        ),
                        speed: const Duration(milliseconds: 10),
                      ),
                    ],
                    totalRepeatCount: 4,
                    pause: const Duration(milliseconds: 10),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  )
                      : vc.shippingCost.isNotEmpty
                      ? Row(
                    children: [
                      Text("Shipping Cost is  \u{20B9}"),
                      Text(
                        vc.shippingCost,
                        style: TextStyle(
                            color: AppColors.primaryColor
                        ),
                      ),
                      Text(" for your current cart"),
                    ],
                  )
                      : SizedBox();
                }),
                label("Order Note"),
                customTextField(context,
                    borderRadius: 12.r,
                    borderColor: const Color(0xffD7DFE9),
                    hint: "Enter Order Note",
                    controller: vc.orderNoteTEC,
                    onChanged: (v) {}),
                SizedBox(
                  height: 32.h,
                ),

                !fromCheckout?Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: GetBuilder<EditAddressController>(
                      builder: (vc) {
                        return CustomButton(
                          child: !vc.creatingAddress?Text("Edit Address"): CustomCircularLoader(),
                          onTap: () {
                            vc.editAddress();
                          }
                        );
                      }
                    ),
                  ),
                ): const SizedBox(),

                SizedBox(
                  height: 32.h,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

//
  showStatesBottomSheet(BuildContext context) async {
    vc.getStates();
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: customTextField(context,
                        borderRadius: 12.r,
                        borderColor: const Color(0xffD7DFE9),
                        hint: "Search State",
                        controller: vc.stateSearchTEC, onChanged: (v) {
                          vc.debounceSearch(isStateSearch: true);
                        }),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    "Select State",
                    style: TextStyle(
                      color: const Color(0xff798397),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  GetBuilder<EditAddressController>(builder: (vc) {
                    return !vc.loadingStates
                        ? CustomListView(
                      itemCount: vc.states.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                vc.stateTEC.text =
                                vc.states[index]!.name!;
                                vc.selectedState = vc.states[index];
                                Get.back();
                              },
                              title: Text(vc.states[index]!.name!),
                            ),
                            const Divider(height: 0)
                          ],
                        );
                      },
                    )
                        : CustomCircularLoader(
                      color: AppColors.primaryColor,
                    );
                  }),
                ],
              ),
            ),
          );
        });
  }

  //
  showCitiesBottomSheet(BuildContext context) async {
    if(vc.cities.isEmpty) {
      vc.getCities();
    }
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: customTextField(context,
                        borderRadius: 12.r,
                        borderColor: const Color(0xffD7DFE9),
                        hint: "Search Cities",
                        controller: vc.citySearchTEC, onChanged: (v) {
                          vc.debounceSearch(isCitySearch: true);
                        }),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    "Select City",
                    style: TextStyle(
                      color: const Color(0xff798397),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  GetBuilder<EditAddressController>(builder: (vc) {
                    return !vc.loadingStates
                        ? CustomListView(
                      itemCount: vc.cities.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                vc.cityTEC.text =
                                vc.cities[index].name!;
                                vc.selectedCity = vc.cities[index];
                                Get.back();
                              },
                              title: Text(vc.cities[index].name!),
                            ),
                            const Divider(height: 0)
                          ],
                        );
                      },
                    )
                        : CustomCircularLoader(
                      color: AppColors.primaryColor,
                    );
                  }),
                ],
              ),
            ),
          );
        });
  }

  //
  InputDecoration decoration({String hint = "", Color? borderColor}) {
    borderColor = Color(0xffD7DFE9);
    return InputDecoration(
      disabledBorder: InputBorder.none,
      //errorStyle: GoogleFonts.jost(),
      focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.3)),
      isDense: true,
      filled: true,
      //contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 15.h),
      fillColor: Colors.white.withOpacity(0.2),
      counterText: "",
      hintText: hint,
      hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.4),
          fontSize: 12,
          fontWeight: FontWeight.w400),
      enabled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          // width: 0.90,
          color: borderColor ?? Colors.transparent,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
            color: borderColor ??
                Colors.transparent), // Set border color to transparent
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
            color: borderColor ??
                Colors.transparent), // Set border color to transparent
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: 0.3), // Set border color to transparent
      ),
    );
  }

   //
   Widget label(String text) {

     return Padding(
       padding: EdgeInsets.symmetric(vertical: 16.h),
       child: Text(
           text,
           style: TextStyle(
               color: const Color(0xff2b3241).withOpacity(0.9),
               fontSize: 13.sp,
               fontWeight: FontWeight.w600)),
     );
   }

}
