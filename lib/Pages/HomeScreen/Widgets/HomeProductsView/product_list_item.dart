import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/ProductDetailsView/product_details_view.dart';

import '../../../AllProductsView/Model/products_list_model.dart';
import 'curved_cart_add_container.dart';
import 'curved_product_container.dart';

class ProductListItem extends StatelessWidget {
   ProductListItem({super.key,this.index,this.product});

   final GlobalKey widgetKey = GlobalKey();
   Product ?product;
   int ?index;

   CartController cc = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=> ProductDetailsView(productId: product!.prdId,));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.42,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        child: CustomPaint(
          painter: CurvedProductContainer(),
          child: Padding(
            padding:
            EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
            child: Column(
              children: [
                Container(
                  key: widgetKey,
                  child: CachedNetworkImage(
                    imageUrl: product!.imgUrl!,
                    width: MediaQuery.of(context).size.width * 0.38 * 0.6,
                    height: MediaQuery.of(context).size.height * 0.3*0.3,
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height*0.28*0.2,
                    child: Text(
                      product!.title!,
                      maxLines: 2,
                      style: TextStyle(fontSize: 12.sp),
                      textAlign: TextAlign.center,
                    )),
                Row(
                  children: [
                    Text(
                      "\u{20B9}${product!.price.toString()}",
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12.sp),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "52% Off",
                      style: TextStyle(fontSize: 10.sp),
                    ),
                    Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "\u{20B9}${product!.discountPrice.toString()}",
                            style: TextStyle(color: Colors.red),
                          ),
                        ))
                  ],
                ),

                SizedBox(height: 20.h),

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
                                    await cc.runAddToCartAnimation(widgetKey);
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
                                      await cc.runAddToCartAnimation(widgetKey);
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
                                    await cc.runAddToCartAnimation(widgetKey);
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
      ),
    );
  }
}
