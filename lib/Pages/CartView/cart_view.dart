import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/CartView/Widgets/cart_item.dart';
import 'package:grocery_nxt/Pages/ChooseAddressView/choose_address_view.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:lottie/lottie.dart';
import '../../Widgets/custom_button.dart';
import '../AddCheckoutAddressView/add_checkout_address_view.dart';

class CartView extends StatelessWidget {
   CartView({super.key});

   CartController cc = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: GetBuilder<CartController>(
          builder: (cc) {
            return cc.products.isNotEmpty?Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total Products (",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600
                  )),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                            begin: const Offset(0.0, 1),
                            end: const Offset(0.0, 0.0))
                            .animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    cc.totalProducts.toString(),
                    key: ValueKey<String>(cc.totalProducts.toString()),
                    style: TextStyle(fontSize: 16.sp, color: Colors.black),
                  ),
                ),
                Text(
                  ")",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600
                  )),
              ],
            ):const SizedBox();
          }
        ),
      ),
      body: GetBuilder<CartController>(
        builder: (cc){
          return cc.products.isNotEmpty?Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  GetBuilder<CartController>(
                    builder: (cc) {
                      return AnimationLimiter(
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cc.products.length,
                            itemBuilder: (context,index){
                              var product = cc.products[index];
                          return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 750),
                              child: SlideAnimation(
                                verticalOffset: 50.h,
                                curve: Curves.bounceOut,
                                child: CartItem(
                                  product: product,
                                  isLast: index==cc.products.length-1,
                                  index: index,
                                )
                              ));
                        }),
                      );
                    }
                  ),
                ],
              ),
            ),
          ):SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Lottie.asset("assets/animations/empty_cart.json"),
                  Text("No Products Yet",style: TextStyle(
                    fontSize: 22.sp,
                    fontFamily: GoogleFonts.aBeeZee().fontFamily
                  ),),
                  SizedBox(height: 12.h),
                  CustomButton(
                    child: const Text("Go Back",style: TextStyle(color: Colors.white),),
                    onTap: (){
                      Get.back();
                    },
                  )
                ],
              ));
        }
      ),
      bottomNavigationBar: GetBuilder<CartController>(
        builder: (cc) {
          return cc.products.isNotEmpty?Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              SizedBox(
                height: 32.h,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: TextFormField(
                  controller: cc.couponController,
                  decoration: decoration(),
                  onChanged: (v){},
                ),
              ),

              SizedBox(
                height: 24.h,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
                child: Text(
                  "Order Summary",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp
                  ),
                ),
              ),

              GetBuilder<CartController>(
                  builder: (cc) {
                    return Column(
                      children: [

                        SummaryItem(
                            title: "Items Total",
                            value: "\u{20B9} ${cc.totalCost}"
                        ),
                        SummaryItem(
                            title: "Coupon Discount",
                            value: "\u{20B9} ${cc.couponAmount.toString()}"
                        ),
                        SummaryItem(
                            title: "Tax",
                            value: "0"
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
                            value: "\u{20B9} ${cc.totalCost}"
                        ),

                        SizedBox(
                            height: 12.h
                        )

                      ],
                    );
                  }
              ),

              GetBuilder<CartController>(
                builder: (cc) {
                  return cc.products.isNotEmpty?Padding(
                    padding: EdgeInsets.only(left: 20.w,right: 20.w,bottom: 16.h),
                    child: CustomButton(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: const Text(
                        "Checkout",
                        style: TextStyle(color: Colors.white),),
                      onTap: (){
                        Get.to(()=> ChooseAddressView());
                      },
                    ),
                  ):const SizedBox();
                }
              ),

            ],
          ):const SizedBox();
        }
      ),
    );
  }

  //
  Widget SummaryItem({String title="", String value=""}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(title),

          Text(value)

        ],
      ),
    );
  }

  InputDecoration decoration(){
    return InputDecoration(
      isDense: true,
      filled: true,
      suffixIcon: Container(
        width: 60.w,
        height: 32.h,
        margin: EdgeInsets.symmetric(
            vertical: 8.h,
            horizontal: 14.w),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(4.r)
        ),
        child: GetBuilder<CartController>(
          id: "coupon",
          builder: (cc) {
            return GestureDetector(
              onTap: (){
                cc.applyCoupon();
              },
              child: Center(
                  child: cc.applyingCoupon?CustomCircularLoader():Text(
                    "Apply",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp))),
            );
          }
        ),
      ),
      fillColor: const Color(0xfff5f5f5),
      hintText: "Enter Coupon Code",
      hintStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14.sp,
        color: const Color(0xff484848)
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(12.r)
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(12.r)
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(12.r)
      ),
    );
  }
}
