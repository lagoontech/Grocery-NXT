import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/AllProductsView/Controller/all_products_controller.dart';
import 'package:grocery_nxt/Pages/AllProductsView/Widgets/all_products_list_item_curved_container.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import '../../../Constants/app_colors.dart';
import '../../HomeScreen/Widgets/HomeProductsView/curved_cart_add_container.dart';
import '../../ProductDetailsView/product_details_view.dart';
import '../Model/products_list_model.dart';

class AllProductsListItem extends StatelessWidget {
   AllProductsListItem({super.key,this.index,this.product});

   AllProductsController vc = Get.find<AllProductsController>();
   CartController cc        = Get.find<CartController>();

   int ?index;
   Product ?product;
   GlobalKey cartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=> ProductDetailsView(productId: product!.prdId,));
      },
      child: Stack(
        children: [
          CustomPaint(
            painter: AllProductsCurvedProductContainer(),
            child: Padding(
              padding:
              EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
              child: Column(
                children: [
                  Container(
                    key: cartKey,
                    color: Colors.transparent,
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.width * 0.38 * 0.6,
                      height: MediaQuery.of(context).size.height * 0.28*0.3,
                      imageUrl: product!.imgUrl!,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height*0.28*0.3,
                      child: AutoSizeText(
                        product!.title!,
                        maxLines: 3,
                        style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      )),
                  Row(
                    children: [
                      Text(
                        "\u{20B9}${product!.price}",
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12.sp),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "\u{20B9}${product!.discountPrice}",
                              style: TextStyle(color: Colors.red,fontSize: 12.sp),
                            ),
                          ))
                    ],
                  ),

                  SizedBox(height: 12.h),

                  GetBuilder<CartController>(
                    builder: (cc) {
                      bool hasProductInCart
                      = cc.products.firstWhere((element) => element.prdId==product!.prdId,
                          orElse: ()=>Product()).prdId!=null;
                      int ?quantity;
                      if(hasProductInCart){
                        quantity = cc.products.where((element) => element.prdId==product!.prdId).toList()[0].cartQuantity;
                      }
                      return SizedBox(
                        width: double.infinity,
                        height: 20.h,
                        child: CustomPaint(
                          painter: CurvedCartAddContainer(
                              curvePercent: 1,
                              hasProduct: hasProductInCart
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              hasProductInCart? GestureDetector(
                                    onTap: () async {
                                      await vc.runAddToCartAnimation(cartKey);
                                      cc.addToCart(product: product);
                                    },
                                    child: const Center(
                                        child: Icon(Icons.remove,
                                            color: Colors.grey,size: 20,))).animate(
                                effects: [
                                  const SlideEffect(
                                    begin: Offset(1,0),
                                    duration: Duration(milliseconds: 750)
                                  )
                                ]
                              )
                                :const SizedBox(),

                              Padding(
                                padding: EdgeInsets.only(top: 2.h),
                                child: !hasProductInCart?GestureDetector(
                                    onTap: () async {
                                      await vc.runAddToCartAnimation(cartKey);
                                      cc.addToCart(product: product);
                                    },
                                    child: const Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.green)
                                    )):Text(quantity.toString()),
                              ),

                              hasProductInCart? GestureDetector(
                                  onTap: () async {
                                    await vc.runAddToCartAnimation(cartKey);
                                    cc.addToCart(product: product);
                                  },
                                  child: const Center(
                                      child: Icon(Icons.add,
                                          color: Colors.green,size: 20,))).animate(
                                  effects: [
                                    const SlideEffect(
                                        begin: Offset(0,0),
                                        duration: Duration(milliseconds: 750)
                                    )
                                  ]
                              )
                                  :const SizedBox(),
                            ],
                          ),
                        ),
                      );
                    }
                  )

                ],
              ),
            ),
          ),

          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
              color: AppColors.primaryColor.withOpacity(0.4)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "${product!.discountPrice!}%",
                    style: TextStyle(fontSize: 8.sp),
                ),
                Text("OFF",style: TextStyle(fontSize: 8.sp),),
              ],
            ),
          )
        ],
      ),
    );
  }
}
