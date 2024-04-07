import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import '../../../Constants/app_colors.dart';
import '../../AllProductsView/Model/products_list_model.dart';

class CartItem extends StatelessWidget {
  CartItem({super.key,this.isLast=false,this.product,this.index=0});

  Product? product;
  CartController cc = Get.find<CartController>();
  bool isLast;
  int  index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(color: index==0?Colors.transparent:Colors.grey.shade200),
            bottom: BorderSide(color: isLast?Colors.grey.shade200:Colors.transparent)
        )
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 17.h),
        child: Row(
          children: [
            SizedBox(
              width: 48.w,
              height: 42.h,
              child: Hero(
                tag: product!.prdId!,
                child: CachedNetworkImage(
                    imageUrl: product!.imgUrl!,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product!.title!,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        )),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(product!.productColor != null
                            ? product!.productColor!.name
                            : ""),
                        SizedBox(width: 4.w,),
                        Text("\u{20B9}${product!.discountPrice!}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),

                  ],
                )),
            SizedBox(width: 12.w),
            Expanded(
                flex: 3,
                child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    cc.addToCart(product: product, isSub: true);
                  },
                  child: Container(
                    width: 40.w,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30.w,
                  child: Center(
                      child: Text(
                    product!.cartQuantity.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  )),
                ),
                GestureDetector(
                  onTap: () {
                    cc.addToCart(product: product);
                  },
                  child: Container(
                    width: 40.w,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.8),
                        shape: BoxShape.circle),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
