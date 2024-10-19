import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_nxt/Pages/CartView/Widgets/cart_item.dart';
import 'package:grocery_nxt/Pages/ChooseAddressView/choose_address_view.dart';
import 'package:grocery_nxt/Pages/CouponsPage/coupons_page.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/LoginScreen/login_screen.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:lottie/lottie.dart';
import '../../Constants/app_size.dart';
import '../../Widgets/custom_button.dart';
import '../DashBoardView/Controller/dashboard_controller.dart';

class CartView extends StatelessWidget {
   CartView({super.key,this.showBack = true});

   bool showBack;
   CartController cc      = Get.find<CartController>();
   DashboardController dc = Get.find<DashboardController>();


   @override
  Widget build(BuildContext context) {

     if(kDebugMode){
       cc.calculateWeight();
     }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: showBack,
        title: GetBuilder<CartController>(
          builder: (cc) {
            return cc.products.isNotEmpty?Padding(
              padding: showBack
                  ? EdgeInsets.only(right: 48.w)
                  : EdgeInsets.zero,
              child: Row(
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
              ),
            ):const SizedBox();
          }
        ),
      ),
      body: GetBuilder<CartController>(
        builder: (cc){
          return cc.products.isNotEmpty?Column(
            children: [

              Expanded(
                flex: 4,
                child: GetBuilder<CartController>(
                  builder: (cc) {
                    return Scrollbar(
                      controller: cc.scrollController,
                      trackVisibility: true,
                      thumbVisibility: true,
                      thickness: 3,
                      radius: Radius.circular(30.r),
                      child: AnimationLimiter(
                        child: ListView.builder(
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
                      ),
                    );
                  }
                ),
              ),

              Expanded(
                flex: isIpad
                    ? 3
                    : 2,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 4,
                        offset: Offset(0,-4.h)
                      )
                    ]
                  ),
                  child: Column(
                  children: [
                  
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
                                  value: "\u{20B9} ${cc.subTotal}"
                              ),
                              SummaryItem(
                                  title: "Coupon Discount",
                                  value: "\u{20B9} ${cc.couponAmount.toString()}"
                              ),
                              SummaryItem(
                                  title: "Tax",
                                  value: "\u{20B9} 0.0"
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
                                  value: "\u{20B9} ${cc.subTotal - cc.couponAmount}"
                              ),
                  
                              SizedBox(
                                  height: 8.h
                              )
                  
                            ],
                          );
                        }
                    ),
                  
                  ]),
                ),),

            ],
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
          return cc.products.isNotEmpty?GetBuilder<CartController>(
            builder: (cc) {
              return cc.products.isNotEmpty? Padding(
                padding: EdgeInsets.only(left: 20.w,right: 20.w,bottom: 16.h),
                child: CustomButton(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: const Text(
                    "Checkout",
                    style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    if(!dc.signedIn){
                      ToastUtil().showToast(message: "Login to continue");
                      Get.to(()=> LoginScreen());
                      return;
                    }
                    if(cc.couponController.text.isNotEmpty){
                      await cc.applyCoupon();
                    }
                    cc.calculateWeight();
                    Get.to(()=> ChooseAddressView());
                  },
                ),
              ):const SizedBox();
            }
          ):const SizedBox();
        }
      ),
      floatingActionButton: kDebugMode?FloatingActionButton(
          onPressed: (){},
          child: kDebugMode ? Text(cc.weight.toStringAsFixed(2)+"kg") : SizedBox(),
      ):SizedBox(),
    );
  }

   /*Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w,bottom: 16.h),
                  child: TextFormField(
                    controller: cc.couponController,
                    decoration: decoration(),
                    onChanged: (v){},
                  ),
                ),
              ),*/

  //
  Widget SummaryItem({String title="", String value=""}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(title,style: TextStyle(
            fontSize: 13.sp
          ),),

          title.contains("Coupon") ? Row(
            children: [
              
              cc.couponAmount != 0.0 
                  ? GestureDetector(
                    onTap: (){
                      cc.couponAmount = 0.0;
                      cc.couponController.text = "";
                      cc.calculateTotal();
                      cc.update();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Icon(Icons.close,size: 18.sp,color: Colors.red),
                    ),
                  )
                  : const SizedBox(),

              GetBuilder<CartController>(
                id: "coupon",
                builder: (vc) {
                  return SizedBox(
                    width: 50.w,
                    height: 24.h,
                    child: CustomButton(
                      onTap: () async{
                       var coupon = await Get.to(()=> CouponsPage());
                       if(coupon!=null && coupon is String){
                         cc.couponController.text = coupon;
                         cc.applyCoupon();
                       }
                      },
                      borderRadius: 8.r,
                      child: cc.applyingCoupon
                          ? CustomCircularLoader(color: Colors.white,width: 10.w,height: 10.w,)
                          : Text(
                          "Apply",
                          style: TextStyle(fontSize: 10.sp))
                    ),
                  );
                }
              ),

              SizedBox(width: 4.w),

              Text(
                value,
                style: TextStyle(
                    fontSize: 13.sp
              ),)

            ],
          ) : Text(value,style: TextStyle(
            fontSize: 13.sp
          ),)

        ],
      ),
    );
  }

  InputDecoration decoration(){
    return InputDecoration(
      isDense: true,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 1.h),
      suffixIcon: Container(
        width: 40.w,
        height: 24.h,
        margin: EdgeInsets.symmetric(
            vertical: 6.h,
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
                  child: cc.applyingCoupon?CustomCircularLoader(): Icon(Icons.check,color: Colors.white,)),
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
