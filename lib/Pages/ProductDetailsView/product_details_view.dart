import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/CartView/cart_view.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/HomeProductsView/product_list_item.dart';
import 'package:grocery_nxt/Pages/ProductDetailsView/Controller/product_details_controller.dart';
import 'package:grocery_nxt/Pages/ProductDetailsView/Widgets/animated_bottom_curved_container.dart';
import 'package:grocery_nxt/Widgets/custom_button.dart';
import 'package:grocery_nxt/Widgets/internet_checker.dart';
import 'package:readmore/readmore.dart';
import '../AllProductsView/Model/products_list_model.dart' hide Badge;

class ProductDetailsView extends StatefulWidget {
   ProductDetailsView({super.key,this.productId,this.product});

   int ?productId;
   Product ?product;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {

  ProductDetailsController vc = Get.put(ProductDetailsController());
  CartController cc = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(vc.productId==null){
        print(vc.productId);
        vc.productId = widget.productId;
        vc.product = widget.product;
        vc.getProductDetails();
      }
    });
    return Scaffold(
      body: GetBuilder<ProductDetailsController>(builder: (vc) {
        return !vc.isLoading
            ? Stack(
              children: [
                SingleChildScrollView(
                    child: GetBuilder<ProductDetailsController>(builder: (vc) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.01 +
                                      MediaQuery.of(context).size.height *
                                          0.45 *
                                          vc.animation.value,
                                  child: CustomPaint(
                                    painter: AnimatedBottomCurvedContainer(vc.animation.value),
                                    child: Center(
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width / 2,
                                        height: MediaQuery.of(context).size.height * 0.20,
                                        child: FittedBox(
                                          child: Hero(
                                            tag: vc.productDetails!.product!.id!,
                                            child: CachedNetworkImage(
                                                imageUrl: vc.selectedImage,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: MediaQuery.of(context).size.height * 0.02,
                                  left: MediaQuery.of(context).size.width * 0.12,
                                  right: MediaQuery.of(context).size.width * 0.12,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width * 0.75,
                                      height: 32.h,
                                      margin: EdgeInsets.only(top: 24.h),
                                      child: vc.productDetails!.product!.galleryImages!
                                              .isNotEmpty
                                          ? ListView.builder(
                                              padding: EdgeInsets.only(left: 12.w),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: vc.productDetails!.product!
                                                  .galleryImages!.length,
                                              itemBuilder: (context, index) {
                                                var image = vc.productDetails!.product!
                                                    .galleryImages![index];
                                                return GestureDetector(
                                                  onTap: (){
                                                    vc.selectedImage = image;
                                                    vc.update();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                                                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.black,
                                                            width: 0.4)),
                                                    child: CachedNetworkImage(
                                                      imageUrl: image,
                                                      width: 30.w,
                                                      height: 24.h,
                                                    ),
                                                  ),
                                                );
                                              })
                                          : const SizedBox()),
                                )
                              ],
                            ),

                            SizedBox(height: MediaQuery.of(context).size.height*0.06),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [

                                      Expanded(
                                          child: Text(
                                              vc.productDetails!.product!.name!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.sp
                                              ),
                                          )
                                      ),

                                      SizedBox(width: 8.w),

                                      GetBuilder<CartController>(
                                        builder: (cc) {
                                          return Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if(vc.quantity!-1!=0) {
                                                    vc.quantity = vc.quantity!-1;
                                                  }
                                                  vc.update();
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
                                                      vc.quantity.toString(),
                                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                                    )),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  vc.quantity = vc.quantity!+1;
                                                  vc.update();
                                                },
                                                child: Container(
                                                  width: 40.w,
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
                                          );
                                        }
                                      )

                                    ],
                                  ),

                                  SizedBox(height: 4.h),

                                  Row(
                                    children: [
                                      /*Text(
                                          "\u{20B9} ${vc.productDetails!.product!.price!.toString()}",
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                          decoration: TextDecoration.lineThrough
                                        ),
                                      ),
                                      SizedBox(width: 2.w),*/
                                      Text(
                                        "\u{20B9} ${vc.productDetails!.product!.salePrice!.toString()}",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 8.h),

                                  vc.productDetails!.productSizes!.isNotEmpty?
                                  SizedBox(
                                    height: 35.h,
                                    child: ListView.builder(
                                        itemCount: vc.productDetails!.productSizes!.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context,index){
                                          var unit = vc.productDetails!.productSizes![index];
                                          bool isSelected = vc.selectedVariant==unit;
                                          return GestureDetector(
                                            onTap: (){
                                              vc.selectedVariant = unit;
                                              vc.changeVariant();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                                              margin: EdgeInsets.only(right: 4.w),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? AppColors.primaryColor
                                                    : Colors.transparent,
                                                border: Border.all(color: AppColors.primaryColor),
                                                borderRadius: BorderRadius.circular(4.w),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                      unit.name,
                                                      style: TextStyle(
                                                        color: isSelected
                                                           ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                  )
                                              ),
                                            ),
                                          );
                                        }
                                    ),
                                  ): const SizedBox(),

                                  SizedBox(height: 8.h),

                                  Row(
                                    children: [

                                      Text(
                                          "In Stock",
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w600
                                          ),
                                      ),

                                      //Text(vc.product!.stockCount.toString()),
                                    ],
                                  ),

                                  SizedBox(height: 8.h),

                                  vc.productDetails!.allUnits!=null
                                      && vc.productDetails!.allUnits!.isNotEmpty?
                                  ListView.builder(
                                      itemCount: vc.productDetails!.allUnits!.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context,index){
                                        var unit = vc.productDetails!.allUnits![index];
                                        return GestureDetector(
                                          onTap: (){},
                                          child: Container(
                                            padding: EdgeInsets.all(2.w),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppColors.primaryColor),
                                              borderRadius: BorderRadius.circular(4.w),
                                            ),
                                            child: Text(unit),
                                          ),
                                        );
                                      }
                                  ): SizedBox(),

                                  ReadMoreText(
                                    HtmlParser.parseHTML(
                                            vc.productDetails!.product!.description!)
                                        .text,
                                    trimMode: TrimMode.Line,
                                    trimLines: 4,
                                    colorClickableText: Colors.pink,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: 'Show less',
                                    moreStyle: const TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.bold),
                                  ),

                                  SizedBox(height: 12.h),

                                ],
                              ),
                            ),

                            vc.productDetails!.relatedProducts.isNotEmpty?Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Related Products",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20.sp
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12.h),

                                SizedBox(
                                  height: MediaQuery.of(context).size.height*0.3,
                                  child: ListView.builder(
                                      itemCount: vc.productDetails!.relatedProducts.length,
                                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context,index){
                                        var product = Product.fromJson(vc.productDetails!.relatedProducts[index]!.toJson());
                                        return ProductListItem(
                                          product: product,
                                          fromDetailsPage: true,
                                        );
                                      }
                                  ),
                                )
                              ],
                            ):const SizedBox(),


                          ],
                        ),
                      );
                    }),
                  ),

                Positioned(
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 4.h),
                    margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: Container(
                            width: 50.w,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                            ),
                            padding: EdgeInsets.all(4.w),
                            child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: 18.sp,
                                )),
                          ),
                        ),

                        GetBuilder<CartController>(
                          builder: (vc) {
                            return GestureDetector(
                              onTap: (){
                                Get.to(()=>CartView());
                              },
                              child: Badge(
                                label: Text(vc.totalProducts.toString()),
                                offset: Offset(0.w,1),
                                child: Container(
                                  width: 50.w,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle
                                  ),
                                  padding: EdgeInsets.all(4.w),
                                  child: Center(
                                      child: Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.black,
                                        size: 18.sp,
                                      )),
                                ),
                              ),
                            );
                          }
                        ),

                      ],
                    ),
                  ),
                )

              ],
            )
            : const Center(child: CircularProgressIndicator());
      }),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            bottom: 16.h),
        child: CustomButton(
          child: const Text(
            "Add to cart",
            style: TextStyle(color: Colors.white)),
          onTap: (){
            vc.product!.cartQuantity = vc.quantity!;
            cc.addToCartFromDetailsPage(product: vc.product);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<ProductDetailsController>();
    super.dispose();
  }
}
