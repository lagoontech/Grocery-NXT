import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/CartView/Widgets/cart_item.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:lottie/lottie.dart';
import '../../Widgets/custom_button.dart';

class CartView extends StatelessWidget {
   CartView({super.key});

   CartController cc = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: GetBuilder<CartController>(
          builder: (cc) {
            return cc.products.isNotEmpty?Text(
              "Cart",
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600
              )):const SizedBox();
          }
        ),
      ),
      body: GetBuilder<CartController>(
        builder: (cc){
          return cc.products.isNotEmpty?Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
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
                                child: CartItem(
                                  product: product,
                                  isLast: index==cc.products.length-1,
                                ),
                              ));
                        }),
                      );
                    }
                  ),

                  SizedBox(
                    height: 32.h,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: TextFormField(
                      decoration: decoration(),
                      onChanged: (v){},
                    ),
                  ),

                  SizedBox(
                    height: 32.h,
                  ),

                  GetBuilder<CartController>(
                    builder: (cc) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 158.h,
                        margin: EdgeInsets.symmetric(horizontal: 30.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [

                            ListTile(
                              title: Text(
                                "Total Products",
                                style: TextStyle(
                                    color: const Color(0xff06161c),
                                    fontSize: 16.sp
                                ),),
                              trailing: Text(cc.totalProducts.toString()),
                            ),

                            ListTile(
                              title: Text(
                                "Shipping",
                                style: TextStyle(
                                    color: const Color(0xff06161c),
                                    fontSize: 16.sp
                                ),),
                              trailing: Text(cc.products.length.toString()),
                            ),

                            ListTile(
                              title: Text(
                                "Total Cost",
                                style: TextStyle(
                                    color: const Color(0xff06161c),
                                    fontSize: 16.sp
                                ),),
                              trailing: Text("\u{20B9}${cc.totalCost}"),
                            ),

                          ],
                        ),
                      );
                    }
                  )

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
          return cc.products.isNotEmpty?Padding(
            padding: EdgeInsets.only(left: 20.w,right: 20.w,bottom: 16.h),
            child: CustomButton(
              child: const Text("Checkout",style: TextStyle(color: Colors.white),),
              onTap: (){},
            ),
          ):SizedBox();
        }
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
        margin: EdgeInsets.symmetric(vertical: 8.h,horizontal: 14.w),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(4.r)
        ),
        child: Center(
            child: Text(
              "Apply",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp),)),
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
