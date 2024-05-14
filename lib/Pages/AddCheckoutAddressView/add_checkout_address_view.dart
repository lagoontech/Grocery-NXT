import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:grocery_nxt/Widgets/custom_list_view.dart';
import 'package:grocery_nxt/Widgets/custom_textfield.dart';
import '../../Widgets/custom_button.dart';
import 'Controller/checkout_address_controller.dart';

class AddCheckoutAddressView extends StatelessWidget {
  AddCheckoutAddressView({super.key});

  AddCheckoutAddressController vc = Get.put(AddCheckoutAddressController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (v) {
        Get.delete<AddCheckoutAddressController>().then((value) {
          //Get.back();
        });
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Checkout Address",
        ),
        body: Stack(
          children: [
            Container(
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
                      GetBuilder<AddCheckoutAddressController>(builder: (vc) {
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

                      GetBuilder<AddCheckoutAddressController>(builder: (vc){
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
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
        bottomNavigationBar:
            GetBuilder<AddCheckoutAddressController>(builder: (cc) {
          return Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h),
            child: CustomButton(
              child: !vc.creatingAddress?const Text(
                "Create Address",
                style: TextStyle(color: Colors.white),
              ): CustomCircularLoader(),
              onTap: () {
                vc.createAddress();
                //Get.to(()=> CheckoutAddressView());
              },
            ),
          );
        }),
      ),
    );
  }

  //
  showCountriesBottomSheet(BuildContext context) async {
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
                        borderColor: Color(0xffD7DFE9),
                        hint: "Search Country",
                        controller: vc.searchTEC, onChanged: (v) {
                      vc.debounceSearch();
                    }),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    "Select Country",
                    style: TextStyle(
                      color: Color(0xff798397),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  GetBuilder<AddCheckoutAddressController>(builder: (vc) {
                    return !vc.loadingCountries
                        ? CustomListView(
                            itemCount: vc.countries.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      vc.countryTEC.text =
                                          vc.countries[index]!.name!;
                                      vc.selectedCountry = vc.countries[index];
                                      Get.back();
                                    },
                                    title: Text(vc.countries[index]!.name!),
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
                  GetBuilder<AddCheckoutAddressController>(builder: (vc) {
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
      // enabledBorder: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(borderRadius ?? 24.5.r),
      // ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: 0.3), // Set border color to transparent
      ),
      // focusedBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(borderRadius ?? 24.5.r),
      //     borderSide: const BorderSide(width: 0.5))
    );
  }

  //
  Widget label(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(text,
          style: TextStyle(color: Color(0xff2b3241), fontSize: 14.sp)),
    );
  }
}
