import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/ProfileView/Views/WishlistView/Controller/wishlist_controller.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:lottie/lottie.dart';
import '../../../../Constants/app_colors.dart';
import '../../../../Services/network_util.dart';
import '../../../../Utils/toast_util.dart';
import '../../../AllProductsView/Model/products_list_model.dart';
import '../../../AllProductsView/Widgets/all_products_list_item_curved_container.dart';
import '../../../ProductDetailsView/product_details_view.dart';

class WishListView extends StatelessWidget {
  WishListView({super.key});

  WishlistController wc = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Wishlist",
      ),
      body: GetBuilder<WishlistController>(builder: (wc) {
        return Container(
          color: Colors.white,
          child: wc.products.isNotEmpty
              ? SingleChildScrollView(
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      shrinkWrap: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent:
                              MediaQuery.of(context).size.height * 0.28,
                          mainAxisSpacing: 2.h,
                          crossAxisSpacing: 8.w),
                      itemCount: wc.products.length,
                      itemBuilder: (context, index) {
                        var product = wc.products[index];
                        return Stack(
                          children: [
                            CustomPaint(
                              painter: AllProductsCurvedProductContainer(),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8.h, left: 4.w, right: 4.w),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (!NetworkUtil().isConnected()) {
                                          ToastUtil()
                                              .showToast(noInternet: true);
                                          return;
                                        }
                                        Product copyProduct =
                                            Product.fromJson(product.toJson());
                                        Get.to(() => ProductDetailsView(
                                              productId: product.prdId,
                                              product: copyProduct,
                                            ));
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            color: Colors.transparent,
                                            child: CachedNetworkImage(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.38 *
                                                  0.6,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.28 *
                                                  0.3,
                                              imageUrl: product.imgUrl!,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.28 *
                                                  0.2,
                                              child: AutoSizeText(
                                                product.title!,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: ""),
                                                textAlign: TextAlign.center,
                                              )),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.28 *
                                                0.2,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "\u{20B9}${product.price}",
                                                    style: TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(width: 2.w),
                                                  Expanded(
                                                      child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      "\u{20B9}${product.discountPrice}",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                          color: AppColors.primaryColor,
                                        )
                                      : Icon(
                                          Icons.favorite_border,
                                          color: Colors.grey.shade400,
                                        ),
                                );
                              }),
                            ),
                            Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8)),
                                //color: AppColors.primaryColor.withOpacity(0.8)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${product.discountPrice!}%",
                                    style: TextStyle(fontSize: 8.sp),
                                  ),
                                  Text(
                                    "OFF",
                                    style: TextStyle(fontSize: 8.sp),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                ))
              : Padding(
                padding: EdgeInsets.only(top: 80.h),
                child: Center(
                  child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Lottie.asset(
                            "assets/animations/fav_animation.json",

                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                              "You have no favourites yet",
                          ),
                        )

                      ],
                    ),
                ),
              ),
        );
      }),
    );
  }
}
