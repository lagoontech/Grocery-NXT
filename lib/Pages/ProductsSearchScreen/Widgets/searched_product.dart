import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/AllProductsView/Controller/all_products_controller.dart';
import 'package:grocery_nxt/Pages/AllProductsView/Widgets/all_products_list_item_curved_container.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/HomeProductsView/discount_wavy_bottom_container.dart';
import 'package:grocery_nxt/Pages/ProductsSearchScreen/Controller/products_search_controller.dart';
import '../../../Constants/app_colors.dart';
import '../../../Services/network_util.dart';
import '../../../Utils/toast_util.dart';
import '../../AllProductsView/Model/products_list_model.dart';
import '../../HomeScreen/Widgets/HomeProductsView/curved_cart_add_container.dart';
import '../../ProductDetailsView/product_details_view.dart';
import '../../ProfileView/Views/WishlistView/Controller/wishlist_controller.dart';

class SearchedProduct extends StatelessWidget {
  SearchedProduct({
    super.key,
    this.index,
    this.product});

  ProductsSearchController vc = Get.find<ProductsSearchController>();
  CartController           cc = Get.find<CartController>();

  int ?index;
  Product ?product;
  GlobalKey cartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: AllProductsCurvedProductContainer(),
          child: Padding(
            padding: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
            child: Column(
              children: [

                GestureDetector(
                  onTap: (){
                    if(!NetworkUtil().isConnected()){
                      ToastUtil().showToast(noInternet: true);
                      return;
                    }
                    Product copyProduct = Product.fromJson(product!.toJson());
                    Get.to(()=> ProductDetailsView(
                      productId: product!.prdId,
                      product: copyProduct,
                    ));
                  },
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
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height*0.28*0.2,
                          child: AutoSizeText(
                            product!.title!,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff222222),
                                fontFamily: ""
                            ),
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.28*0.2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Row(
                            children: [
                              Text(
                                "\u{20B9}${product!.price}",
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "\u{20B9}${product!.discountPrice}",
                                      style: TextStyle(
                                        color: AppColors.secondaryColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                SizedBox(height: 6.h),

                product!.stockCount!=0?GetBuilder<CartController>(
                    builder: (cc) {
                      bool hasProductInCart
                      = cc.products.firstWhere((element) => element.prdId==product!.prdId&&element.variantInfo==null,
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                hasProductInCart? GestureDetector(
                                    onTap: () async {
                                      cc.addToCart(product: product,isSub: true);
                                    },
                                    child: const Center(
                                        child: Icon(Icons.remove,
                                          color: Colors.grey,size: 20,))).animate(
                                    effects: [
                                      const SlideEffect(
                                          begin: Offset(1,0),
                                          duration: Duration(milliseconds: 300)
                                      ),
                                      const FadeEffect()
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
                                          begin: Offset(-1,0),
                                          duration: Duration(milliseconds: 300)
                                      ),
                                      const FadeEffect()
                                    ]
                                )
                                    :const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ): const Text("Out of stock",style: TextStyle(color: Colors.red),)

              ],
            ),
          ),
        ),

        Positioned(
          right: 8.w,
          top: 8.h,
          child:
          GetBuilder<WishlistController>(builder: (wc) {
            var isFavourite = wc.products
                .firstWhere(
                    (element) =>
                element.prdId == product!.prdId,
                orElse: () => Product())
                .prdId !=
                null;
            return GestureDetector(
              onTap: () {
                wc.addOrRemoveProduct(
                    product: product,
                    isFavourite: isFavourite);
              },
              child: isFavourite
                  ? Icon(
                Icons.favorite,
                color: AppColors.primaryColor.withOpacity(0.6),
              )
                  : Icon(
                Icons.favorite_border,
                color: Colors.grey.shade400,
              ),
            );
          }),
        ),

        CustomPaint(
          painter: WavyPainter(),
          child: Container(
            width: 32.w,
            height: 28.h,
            padding: EdgeInsets.only(left: 4.w),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8)),
              //color: AppColors.primaryColor.withOpacity(0.8)
            ),
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${ (((product!.price-product!.discountPrice)/product!.price)*100).toStringAsFixed(0) }%",
                    style: TextStyle(fontSize: 8.sp,fontWeight: FontWeight.w600),
                  ),
                  Text("OFF",style: TextStyle(fontSize: 8.sp,fontWeight: FontWeight.w600),),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
