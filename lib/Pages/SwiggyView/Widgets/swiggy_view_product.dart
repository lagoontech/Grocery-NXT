import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Constants/app_colors.dart';
import '../../../Services/network_util.dart';
import '../../../Utils/toast_util.dart';
import '../../AllProductsView/Model/products_list_model.dart';
import '../../HomeScreen/Controller/cart_controller.dart';
import '../../HomeScreen/Widgets/HomeProductsView/discount_wavy_bottom_container.dart';
import '../../ProductDetailsView/product_details_view.dart';
import '../../ProfileView/Views/WishlistView/Controller/wishlist_controller.dart';

class SwiggyViewProduct extends StatelessWidget {
   SwiggyViewProduct({super.key,this.product,this.index});

   Product ?product;
   int ?index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: index==0
            ? Border(
            right: BorderSide(
                color: Colors.grey.shade300,
            ),
            bottom: BorderSide(color: Colors.grey.shade300)
        )
            : Border(
            right: BorderSide(color: Colors.grey.shade300),
            bottom: BorderSide(color: Colors.grey.shade300)
        )
      ),
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              Padding(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Center(
                            child: Container(
                              child: Hero(
                                tag: product!.prdId!,
                                child: CachedNetworkImage(
                                  width: MediaQuery.of(context).size.width * 0.38 * 0.7,
                                  height: MediaQuery.of(context).size.height * 0.34*0.40,
                                  imageUrl: product!.imgUrl!,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.32,
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
                                  textAlign: TextAlign.left,
                                )),
                          ),

                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.32*0.12,
                            child: Center(
                              child: Text(
                                product!.vendorName!=null
                                    ? product!.vendorName.toString()
                                    : product!.productColor!=null
                                      ? product!.productColor!.name!
                                      : ""),
                            ),
                          ),

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.28*0.2,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "\u{20B9}${product!.price}",
                                        style: TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey.shade700,
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "\u{20B9}${product!.discountPrice}",
                                        style: TextStyle(
                                          color: AppColors.secondaryColor,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*0.22,
                                        height: 28.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.r),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 0.8
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              blurRadius: 4,
                                              offset: Offset(-0.5, 0.5),
                                            )
                                          ]
                                        ),
                                        child: GetBuilder<CartController>(
                                          builder: (cc) {
                                            bool hasProductInCart
                                            = cc.products.firstWhere((element) => element.prdId==product!.prdId&&element.variantInfo==null,
                                                orElse: ()=>Product()).prdId!=null;
                                            int ?quantity;
                                            if(hasProductInCart){
                                              quantity = cc.products.where((element) => element.prdId==product!.prdId).toList()[0].cartQuantity;
                                            }
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [

                                                hasProductInCart? GestureDetector(
                                                    onTap: () async {
                                                      cc.addToCart(product: product,isSub: true);
                                                    },
                                                    child: SizedBox(
                                                      width: 20.w,
                                                      child: Center(
                                                          child: Icon(Icons.remove,
                                                            color: AppColors.primaryColor ,size: 16,)),
                                                    )).animate(
                                                    effects: [
                                                      const SlideEffect(
                                                          begin: Offset(1,0),
                                                          duration: Duration(milliseconds: 300)
                                                      ),
                                                      const FadeEffect()
                                                    ]
                                                )
                                                    :const SizedBox(),

                                                SizedBox(
                                                  height: 28.h,
                                                  child: Center(
                                                    child: !hasProductInCart
                                                        ? GestureDetector(
                                                            onTap: () async {
                                                              cc.addToCart(
                                                                  product: product);
                                                            },
                                                            child: Text(
                                                              "ADD",
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight.w700,
                                                                fontSize: 12.sp,
                                                              ),
                                                            ))
                                                        : GestureDetector(
                                                            onTap: () async {},
                                                            child: SizedBox(
                                                              width: 20.w,
                                                              child: Center(
                                                                child: Text(
                                                                  quantity
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .primaryColor),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                hasProductInCart? SizedBox(
                                                  width: 20.w,
                                                  child: GestureDetector(
                                                      onTap: () async {
                                                        cc.addToCart(product: product);
                                                      },
                                                      child: const Center(
                                                          child: Icon(Icons.add,
                                                            color: Colors.green,size: 16,))).animate(
                                                      effects: [
                                                        const SlideEffect(
                                                            begin: Offset(-1,0),
                                                            duration: Duration(milliseconds: 300)
                                                        ),
                                                        const FadeEffect()
                                                      ]
                                                  ),
                                                )
                                                    :const SizedBox(),
                                              ],
                                            );
                                          }
                                        )
                                      ),
                                    ),
                                  )

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

              /*Positioned(
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
              )*/

              CustomPaint(
                painter: WavyPainter(curve: false),
                child: Container(
                  width: 24.w,
                  height: 24.h,
                  padding: EdgeInsets.only(left: 4.w),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8)),
                    //color: AppColors.primaryColor.withOpacity(0.8)
                  ),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
          )
        ],
      ),
    );
  }
}
