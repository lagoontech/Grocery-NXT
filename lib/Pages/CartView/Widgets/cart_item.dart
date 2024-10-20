import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
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

    return Dismissible(
      key: ValueKey(product!.variantInfo!=null && product!.itemType == null
          ? "${product!.variantInfo!.pidId}${product!.productColor!.name}"
          : product!.variantInfo!=null && product!.itemType!=null
          ? "${product!.variantInfo!.pidId}${product!.itemType!.id}${product!.itemType!.name}"
          : product!.prdId),
      onDismissed: (v){
        if(product!.variantInfo!=null && product!.itemType == null){
          cc.products.removeWhere(
                  (element) => element.prdId==product!.prdId
                      && element.variantInfo!.pidId==product!.variantInfo!.pidId
                      && element.productColor!.id == product!.productColor!.id);
        }else if(product!.variantInfo != null && product!.itemType!=null){
          cc.products.removeWhere(
                  (element) => element.prdId==product!.prdId
                  && element.variantInfo!.pidId==product!.variantInfo!.pidId
                  && element.itemType!.id==product!.itemType!.id);
        }else{
          cc.products.removeWhere((element) => element.prdId==product!.prdId);
        }
        cc.calculateTotalProducts();
        cc.calculateTotal();
        ToastUtil().showToast(color: AppColors.primaryColor,message: "Product Removed");
        cc.update();
      },
      background: Container(
        color: Colors.red,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: index==0?Colors.transparent:Colors.grey.shade200),
              bottom: BorderSide(color: isLast?Colors.grey.shade200:Colors.transparent)
          )
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: CachedNetworkImage(
                    imageUrl: product!.imgUrl!,
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
                            fontSize: 12.sp,
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis
                          )),
                      SizedBox(height: 2.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          product!.itemType!=null
                              ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                child: Text(
                                    product!.itemType!.name,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.primaryColor
                                    ),
                                ),
                              )
                              : const SizedBox(),


                          Row(
                            children: [
                              Text(product!.productColor != null
                                  ? product!.productColor!.name
                                  : "",style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp
                              ),),
                              product!.productColor != null
                                  ?SizedBox(width: 4.w,):const SizedBox(),
                              DefaultTextStyle(
                                style: TextStyle(color: Colors.grey.shade600,fontSize: 12.sp),
                                child: Row(
                                  children: [
                                    Text("\u{20B9}${product!.discountPrice!}",),
                                    Text(" x ${product!.cartQuantity} = \u{20B9}"),
                                    Text((product!.cartQuantity * product!.discountPrice).toStringAsFixed(0)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),

                    ],
                  )),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end, children: [
                      GestureDetector(
                        onTap: () {
                          if(product!.cartQuantity==1){
                            return;
                          }
                          cc.addToCart(product: product, isSub: true);
                        },
                        child: Container(
                          width: 32.w,
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
                        width: 28.w,
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
                          width: 32.w,
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.8),
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                                    ],
                                  )

                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
