import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/HomeProductsView/discount_wavy_bottom_container.dart';
import 'package:grocery_nxt/Pages/ProductDetailsView/Controller/product_details_controller.dart';
import 'package:grocery_nxt/Pages/ProductDetailsView/product_details_view.dart';
import 'package:grocery_nxt/Pages/ProfileView/Views/WishlistView/Controller/wishlist_controller.dart';
import 'package:grocery_nxt/Services/network_util.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import '../../../AllProductsView/Model/products_list_model.dart';
import 'curved_cart_add_container.dart';
import 'curved_product_container.dart';

class ProductListItem extends StatelessWidget {
  ProductListItem(
      {super.key, this.index, this.product, this.fromDetailsPage = false});

  final GlobalKey widgetKey = GlobalKey();
  Product? product;
  int? index;
  bool fromDetailsPage;

  CartController cc = Get.find<CartController>();
  WishlistController wc = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.44,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          child: CustomPaint(
            painter: CurvedProductContainer(),
            child: Padding(
              padding: EdgeInsets.only(top: 16.h, left: 4.w, right: 4.w),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!NetworkUtil().isConnected()) {
                        ToastUtil().showToast(noInternet: true);
                        return;
                      }
                      Product copyProduct = Product.fromJson(product!.toJson());
                      Get.delete<ProductDetailsController>();
                      Get.to(()=> new ProductDetailsView(
                          productId: product!.prdId,
                          product: copyProduct
                      ),preventDuplicates: false);
                      print("product tapped");
                    },
                    child: Column(
                      children: [
                        Container(
                          key: widgetKey,
                          child: CachedNetworkImage(
                            imageUrl: product!.imgUrl!,
                            width: MediaQuery.of(context).size.width *
                                0.38 *
                                0.6,
                            height: MediaQuery.of(context).size.height *
                                0.3 *
                                0.3,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.3 * 0.2,
                            child: Text(
                              product!.title!,
                              maxLines: 2,
                              style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            children: [
                              Text(
                                "\u{20B9}${product!.price.toString()}",
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12.sp),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "\u{20B9}${product!.discountPrice.toString()}",
                                  style: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontWeight: FontWeight.w600,

                                  ),
                                ),
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  GetBuilder<CartController>(builder: (cc) {
                    bool hasProductInCart = cc.products
                            .firstWhere(
                                (element) =>
                                    element.prdId == product!.prdId &&
                                    element.variantInfo == null,
                                orElse: () => Product())
                            .prdId !=
                        null;
                    int? quantity;
                    if (hasProductInCart) {
                      quantity = cc.products
                          .where((element) => element.prdId == product!.prdId)
                          .toList()[0]
                          .cartQuantity;
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 20.h,
                      child: CustomPaint(
                        painter: CurvedCartAddContainer(
                            curvePercent: 1, hasProduct: hasProductInCart),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: product!.inventoryattribute!="Yes"?Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              hasProductInCart
                                  ? GestureDetector(
                                      onTap: () async {
                                        cc.addToCart(
                                            product: product, isSub: true);
                                      },
                                      child: const Center(
                                          child: Icon(
                                        Icons.remove,
                                        color: Colors.grey,
                                        size: 20,
                                      ))).animate(effects: [
                                      const SlideEffect(
                                          begin: Offset(1, 0),
                                          duration:
                                              Duration(milliseconds: 300)),
                                      const FadeEffect()
                                    ])
                                  : const SizedBox(),
                              Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: !hasProductInCart
                                    ? GestureDetector(
                                        onTap: () async {
                                          if (!fromDetailsPage) {
                                            await cc.runAddToCartAnimation(
                                                widgetKey);
                                          }
                                          cc.addToCart(product: product);
                                        },
                                        child: const Center(
                                            child: Icon(Icons.add,
                                                color: Colors.green)))
                                    : Text(quantity.toString()),
                              ),
                              hasProductInCart
                                  ? GestureDetector(
                                      onTap: () async {
                                        if (!fromDetailsPage) {
                                          await cc
                                              .runAddToCartAnimation(widgetKey);
                                        }
                                        cc.addToCart(product: product);
                                      },
                                      child: const Center(
                                          child: Icon(
                                        Icons.add,
                                        color: Colors.green,
                                        size: 20,
                                      ))).animate(effects: [
                                      const SlideEffect(
                                          begin: Offset(-1, 0),
                                          duration:
                                              Duration(milliseconds: 300)),
                                      const FadeEffect()
                                    ])
                                  : const SizedBox(),
                            ],
                          ) : GestureDetector(
                              onTap: (){
                                Get.to(()=> ProductDetailsView(product: product,productId: product!.prdId));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Icon(Icons.remove_red_eye,color: AppColors.primaryColor),
                              )
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ),

        (((product!.price-product!.discountPrice)/product!.price)*100).toStringAsFixed(0)!="0"
            && !(((product!.price-product!.discountPrice)/product!.price)*100).toStringAsFixed(0).contains("-") ?Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: CustomPaint(
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
          ),
        ): const SizedBox(),

        Positioned(
          right: 16.w,
          top: 8.h,
          child: GetBuilder<WishlistController>(builder: (wc) {
            var isFavourite = wc.products
                    .firstWhere((element) => element.prdId == product!.prdId,
                        orElse: () => Product())
                    .prdId !=
                null;
            return GestureDetector(
              onTap: () {
                wc.addOrRemoveProduct(
                    product: product, isFavourite: isFavourite);
              },
              child: isFavourite
                  ? Icon(
                      Icons.favorite,
                      color: AppColors.primaryColor,
                    )
                  : Icon(
                      Icons.favorite_border,
                      color: Colors.grey.shade400,
                    ),
            );
          }),
        )
      ],
    );
  }
}
