import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/CartView/cart_view.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/HomeProductsView/product_list_item.dart';
import 'package:grocery_nxt/Pages/ProductDetailsView/Controller/product_details_controller.dart';
import 'package:grocery_nxt/Pages/ProductDetailsView/Widgets/animated_bottom_curved_container.dart';
import 'package:grocery_nxt/Pages/ProductDetailsView/Widgets/animated_bottom_curved_painter.dart';
import 'package:grocery_nxt/Pages/ProductDetailsView/product_image_screen.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:grocery_nxt/Widgets/custom_button.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:grocery_nxt/Widgets/custom_textfield.dart';
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
  CartController           cc = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(vc.productId==null){
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
                        child: Container(
                          color: AppColors.primaryColor.withOpacity(0.03),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.01 +
                                        MediaQuery.of(context).size.height *
                                            0.42 *
                                            vc.animation.value,
                                    child: CustomPaint(
                                      painter: AnimatedBottomCurvedPainter(vc.animation.value),
                                      child: ClipPath(
                                        clipper: AnimatedBottomCurvedContainer(vc.animation.value),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: GestureDetector(
                                                onTap: (){
                                                  Get.to(()=> ProductImageScreen(imgUrl: vc.selectedImage));
                                                },
                                                child: SizedBox(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: MediaQuery.of(context).size.height,
                                                  child: Transform.scale(
                                                    scale: 1.1,
                                                    child: CachedNetworkImage(
                                                        imageUrl: vc.selectedImage,
                                                        fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IgnorePointer(
                                              child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: MediaQuery.of(context).size.height*0.42,
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.black.withOpacity(0.05),
                                                            Colors.black.withOpacity(0.001),
                                                          ],
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter
                                                      )
                                                  )
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          
                                ],
                              ),
                          
                              SizedBox(height: MediaQuery.of(context).size.height*0.02),
                          
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.75,
                                          height: 32.h,
                                          margin: EdgeInsets.only(top: 24.h),
                                          child: vc.productDetails!.product!.galleryImages!.isNotEmpty
                                              ? Center(
                                            child: SizedBox(
                                              width: vc.productDetails!.product!.galleryImages!.length * 50.w, // Adjust the width to fit items
                                              child: ListView.builder(
                                                padding: EdgeInsets.only(left: 12.w),
                                                scrollDirection: Axis.horizontal,
                                                itemCount: vc.productDetails!.product!.galleryImages!.length,
                                                itemBuilder: (context, index) {
                                                  var image = vc.productDetails!.product!.galleryImages![index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      vc.selectedImage = image;
                                                      vc.update();
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: Duration(milliseconds: 350),
                                                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                                                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: AppColors.primaryColor,
                                                          width: vc.selectedImage == image
                                                              ? 2
                                                              : 0.4,
                                                        ),
                                                      ),
                                                      child: CachedNetworkImage(
                                                        imageUrl: image,
                                                        width: 30.w,
                                                        height: 24.h,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                              : const SizedBox(),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 8.h),

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
                                        Text(
                                            "\u{20B9} ${vc.productDetails!.product!.price!.toString()}",
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                            decoration: TextDecoration.lineThrough
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "\u{20B9}${vc.productDetails!.product!.salePrice!.toString()}",
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

                                    vc.selectedVariant != null
                                        && vc.selectedVariant!.itemTypes!=null
                                        && vc.selectedVariant!.itemTypes!.isNotEmpty?
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Padding(
                                          padding: EdgeInsets.only(top: 8.h,bottom: 4.h),
                                          child: Text(
                                              "Item Types",
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600
                                              )),
                                        ),

                                        SizedBox(
                                          height: 35.h,
                                          child: ListView.builder(
                                              itemCount: vc.selectedVariant!.itemTypes!.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context,index){
                                                var  unit       = vc.selectedVariant!.itemTypes![index];
                                                bool isSelected = vc.selectedType==unit;
                                                return GestureDetector(
                                                  onTap: (){
                                                    vc.selectedType = unit;
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
                                        ),

                                        SizedBox(height: 8.h)

                                      ],
                                    ): const SizedBox(),
                          
                                    SizedBox(height: 4.h),
                          
                                    Row(
                                      children: [
                          
                                        vc.product!.stockCount!=0?Text(
                                            "In Stock",
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w600
                                            ),
                                        ):const Text(
                                          "Out of stock",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                          
                                        //Text(vc.product!.stockCount.toString()),
                                      ],
                                    ),
                          
                                    vc.productDetails!.avgRating!=null?Column(
                                      children: [
                          
                                        SizedBox(height: 8.h),
                          
                                        RatingBar.readOnly(
                                            filledIcon: Icons.star,
                                            emptyIcon: Icons.star_border,
                                            initialRating: double.parse(vc.productDetails!.avgRating.toString()),
                                            size: 20.sp,
                                        ),
                                      ],
                                    ): const SizedBox(),
                          
                                    SizedBox(height: 8.h),
                          
                                    vc.productDetails!.product!.enablePrebook!?Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                          
                                        customTextField(
                                            context,
                                            textInputType: TextInputType.text,
                                            borderColor: AppColors.primaryColor,
                                            hint: "Eg: 5Kg,20Kg",
                                            onChanged: (v){
                                              vc.preBook = v!;
                                            }
                                        ),
                          
                                        SizedBox(height: 8.h),
                          
                                        CustomButton(
                                          height: 36.h,
                                          onTap: (){
                                            vc.preBookAPI();
                                          },
                                          child: !vc.booking?const Text(
                                              "Pre-Book",
                                              style: TextStyle(color: Colors.white)):CustomCircularLoader(),
                                        ),
                          
                                      ],
                                    ):SizedBox(),
                          
                                    SizedBox(height: 12.h),
                          
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
                                    ): const SizedBox(),

                                    Container(
                                      height: 24.h,
                                      width: 200.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.w),
                                        color: Colors.white
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [

                                          Container(
                                            width: 100.w,
                                            height: 24.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor
                                            ),
                                            child: Center(
                                              child: Text("COUPON",style: TextStyle(
                                                color: Colors.white
                                              ),),
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 4.h),
                          
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
                            height: 28.w,
                            padding: EdgeInsets.only(left: 6.w),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                            ),
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
            if(vc.product!.stockCount!<vc.quantity!){
              ToastUtil().showToast(color: AppColors.primaryColor,message: "Availabe stock: ${vc.product!.stockCount}");
              return;
            }
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
