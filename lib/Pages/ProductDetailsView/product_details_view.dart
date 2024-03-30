import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/ProductDetailsView/Controller/product_details_controller.dart';
import 'package:grocery_nxt/Pages/ProductDetailsView/Widgets/animated_bottom_curved_container.dart';
import 'package:grocery_nxt/Widgets/custom_button.dart';
import 'package:readmore/readmore.dart';

class ProductDetailsView extends StatefulWidget {
   ProductDetailsView({super.key,this.productId});

   int ?productId;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {

  ProductDetailsController vc = Get.put(ProductDetailsController());

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(vc.productId==null){
        vc.productId = widget.productId;
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
                                          child: CachedNetworkImage(
                                              imageUrl:
                                                  vc.productDetails!.product!.image!),
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
                                                return Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 0.4)),
                                                  child: CachedNetworkImage(
                                                    imageUrl: image,
                                                    width: 30.w,
                                                    height: 24.h,
                                                  ),
                                                );
                                              })
                                          : SizedBox()),
                                )
                              ],
                            ),

                            SizedBox(height: MediaQuery.of(context).size.height*0.12,),

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

                                      Container(
                                        width: 30.w,
                                        padding: EdgeInsets.all(2.w),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          shape: BoxShape.circle
                                        ),
                                        child: Icon(Icons.remove,color: Colors.grey,),
                                      ),
                                      Container(
                                        width: 40.w,
                                        child: Center(
                                            child: Text(
                                                "1",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600
                                                ),
                                            )),
                                      ),
                                      Container(
                                        width: 40.w,
                                        padding: EdgeInsets.all(2.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor.withOpacity(0.8),
                                          shape: BoxShape.circle
                                        ),
                                        child: Icon(Icons.add,color: Colors.white,),
                                      ),

                                    ],
                                  ),

                                  SizedBox(height: 4.h),

                                  Text(
                                      "\u{20B9} ${vc.productDetails!.product!.salePrice!.toString()}",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600),
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


                                ],
                              ),
                            )

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

                        Container(
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

                        Badge(
                          label: const Text("1"),
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

                      ],
                    ),
                  ),
                )

              ],
            )
            : const Center(child: CircularProgressIndicator());
      }),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20.w,right: 20.w,bottom: 16.h),
        child: CustomButton(
          child: const Text("Add to cart",style: TextStyle(color: Colors.white),),
          onTap: (){},
        ),
      ),
    );
  }
}
