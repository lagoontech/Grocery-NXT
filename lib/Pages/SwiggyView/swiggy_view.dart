import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/CartView/cart_view.dart';
import 'package:grocery_nxt/Pages/SwiggyView/Controller/swiggy_view_controller.dart';
import 'package:grocery_nxt/Pages/SwiggyView/Widgets/sub_category_item.dart';
import 'package:grocery_nxt/Pages/SwiggyView/Widgets/swiggy_view_product.dart';
import 'package:grocery_nxt/Widgets/custom_button.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../Constants/app_colors.dart';
import '../HomeScreen/Controller/cart_controller.dart';
import '../HomeScreen/Widgets/HomeProductsView/discount_wavy_bottom_container.dart';

class SwiggyView extends StatelessWidget {
   SwiggyView({super.key,this.categoryId,this.categoryName,this.imageUrl,this.subCategoryId});

   SwiggyViewController svc = Get.put(SwiggyViewController());
   int    ?categoryId;
   String ?categoryName;
   String ?imageUrl;
   int    ?subCategoryId;

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(svc.categoryId==null){
        svc.categoryId = categoryId;
        svc.subCategoryId = subCategoryId;
        svc.categoryName = categoryName;
        svc.fetchSubCategories();
        svc.fetchCategoryProducts();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        actions: [
          GestureDetector(
            onTap: (){
              Get.to(()=>CartView());
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: GetBuilder<CartController>(builder: (cc) {
                return Badge(
                    backgroundColor: AppColors.secondaryColor,
                    label: Text(cc.totalProducts.toString()),
                    child: const Icon(Icons.shopping_bag_outlined));
              }),
            ),
          )
        ],
        title: GetBuilder<SwiggyViewController>(
          builder: (vc) {
            return GestureDetector(
              onTap: (){
                showCategoriesDialog(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl ?? "",
                    width: 40.w,
                    errorWidget: (b,s,o){
                      return Image(image: AssetImage("assets/images/gnxt_logo.png"));
                    },
                    height: 40.h,
                  ),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width*0.4
                            ),
                            child: Text(
                              vc.categoryName??"",
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.9)
                              ),
                            ),
                          ),

                          Icon(
                              Icons.keyboard_arrow_down,
                              size: 16.sp),
                        ],
                      ),

                      GetBuilder<SwiggyViewController>(
                          builder: (vc) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                Text(
                                    "${svc.totalCategoryProducts} items",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black.withOpacity(0.9)
                                    ),
                                )

                              ]
                            );
                          }
                      ),

                    ],
                  ),
                ],
              ),
            );
          }
        ),
      ),
      body: Container(
        color: Colors.grey.shade100,
        padding: EdgeInsets.only(top: 4.h),
        child: GetBuilder<SwiggyViewController>(
          builder: (vc) {
            return Row(
              children: [

                GetBuilder<SwiggyViewController>(
                  builder: (vc) {
                    return Expanded(
                        flex: 3,
                        child: Container(
                          height: MediaQuery.of(context).size.height-(kToolbarHeight+MediaQuery.of(context).viewPadding.top),
                          padding: EdgeInsets.only(top: 24.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400,width: 0.4),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12.r))
                          ),
                          child: !vc.isLoadingSubCategories ?Stack(
                            children: [

                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  controller: svc.scrollController,
                                  itemCount: vc.subCategories.length,
                                  itemBuilder: (context,index){
                                    var sub = vc.subCategories[index];
                                    return SubCategoryItem(subcategory: sub);
                                  }
                              ),

                              AnimatedPositioned(
                                left: 0,
                                top: svc.scrollOffset,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  height: 88.h,
                                  width: 3.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12.r),
                                        bottomRight: Radius.circular(12.r)
                                    )
                                  ),
                                ),
                              )

                            ],
                          ):ListView.builder(
                              shrinkWrap: true,
                              itemCount: 6,
                              itemBuilder: (context,index){
                                return categoriesLoader();
                              }
                          ),
                        )
                    );
                  }
                ),

                SizedBox(width: 4.w),

                Expanded(
                    flex: 12,
                    child: GetBuilder<SwiggyViewController>(
                      builder: (vc) {
                        return !vc.isLoadingSubCategories&&vc.subCategories.isNotEmpty?PageView(
                          scrollDirection: Axis.vertical,
                          controller: svc.pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: svc.subCategories.map((e){
                            String previousSub = "";
                            String nextSub     = "";
                            try{
                              if(vc.subIndex!=vc.subCategories.length-1){
                                nextSub = vc.subCategories[vc.subCategories.indexOf(
                                    vc.selectedSubCategory!)+1].name!;
                              }
                              if(vc.subIndex!=0) {
                                previousSub = vc.subCategories[vc.subCategories.indexOf(
                                    vc.selectedSubCategory!)-1].name!;
                              }
                            }catch(e){
                              if (kDebugMode) {
                                print(e);
                              }
                            }
                            return Container(
                              clipBehavior: Clip.antiAlias,
                              height: MediaQuery.of(context).size.height-(kToolbarHeight+MediaQuery.of(context).viewPadding.top),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade400,width: 0.4),
                                  borderRadius: BorderRadius.circular(12.r)),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [

                                    vc.products.isNotEmpty && vc.products.length>=5&&vc.subIndex!=0?Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: AppColors.secondaryColor,
                                            ).animate(
                                                onPlay: (v){
                                                  v.repeat(reverse: true);
                                                },
                                                effects: [
                                                  const SlideEffect()
                                                ]
                                            ),Transform.translate(
                                              offset: Offset(0,-4.h),
                                              child: Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: AppColors.secondaryColor,
                                              ).animate(
                                                  onPlay: (v){
                                                    v.repeat(reverse: true);
                                                  },
                                                  effects: [
                                                    const SlideEffect()
                                                  ]
                                              ),
                                            ),
                                            Text(previousSub),
                                          ],
                                        ),
                                      )):SizedBox(),

                                  vc.products.length>5 && vc.isLastPage?Padding(
                                    padding: EdgeInsets.only(bottom: 12.h),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(nextSub),
                                        Icon(
                                            Icons.keyboard_arrow_up_rounded,
                                            color: AppColors.secondaryColor,
                                        ).animate(
                                          onPlay: (v){
                                            v.repeat(reverse: true);
                                          },
                                          effects: [
                                            const SlideEffect()
                                          ]
                                        ),
                                        Transform.translate(
                                          offset: Offset(0,-4.h),
                                          child: Icon(
                                            Icons.keyboard_arrow_up_outlined,
                                            color: AppColors.secondaryColor,
                                          ).animate(
                                              onPlay: (v){
                                                v.repeat(reverse: true);
                                              },
                                              effects: [
                                                const SlideEffect()
                                              ]
                                          ),
                                        ),
                                      ],
                                    ),
                                  ):const SizedBox(),

                                  SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    controller: e.scrollController,
                                    child: Column(
                                      children: [

                                        Container(
                                          height: kToolbarHeight*0.9,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12.r),
                                                bottomLeft: Radius.circular(12.r)
                                            )
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: GetBuilder<SwiggyViewController>(
                                                    builder: (vc) {
                                                      return !vc.isLoading?Row(
                                                        children: [

                                                          Text(
                                                              "${svc.totalProducts} items",
                                                              style: const TextStyle(fontWeight: FontWeight.w600)),

                                                          Text(" in ${svc.selectedSubCategory!=null
                                                              ? svc.selectedSubCategory!.name!
                                                              : ""}")

                                                        ],
                                                      ): Container(
                                                        width: MediaQuery.of(context).size.width * 0.20,
                                                        height: MediaQuery.of(context).size.height*0.32*0.08,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey.shade100,
                                                        ),
                                                      );
                                                    }
                                                ),
                                              ),

                                              Expanded(
                                                  child: Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Divider(color: Colors.grey.shade300,thickness: 0.6,height: 0)))

                                            ],
                                          ),
                                        ),

                                        GetBuilder<SwiggyViewController>(
                                            builder: (vc) {
                                              return !vc.isLoading?GridView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: svc.products.length,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisExtent: MediaQuery.of(context).size.height*0.34,
                                                  ),
                                                  itemBuilder: (context,index){
                                                    var product = svc.products[index];
                                                    return SwiggyViewProduct(
                                                      product: product,
                                                      index: index,
                                                    );
                                                  }
                                              ):GridView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: 6,
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisExtent: MediaQuery.of(context).size.height*0.34,
                                                  ),
                                                  itemBuilder: (context,index){
                                                    return loader(context,index);
                                                  }
                                              );
                                            }
                                        ),

                                        GetBuilder<SwiggyViewController>(
                                            builder: (vc){
                                          return AnimatedContainer(
                                            duration: const Duration(milliseconds: 300),
                                            width: MediaQuery.of(context).size.width,
                                            margin: EdgeInsets.only(bottom: 8.h),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondaryColor
                                            ),
                                            height: vc.isLoadingNextPage?36.h:0,
                                            child: Center(
                                              child: SizedBox(
                                                width: 24.w,
                                                height: 24.w,
                                                child: Lottie.asset("assets/animations/preloader_white.json")
                                              ),
                                            )
                                        );})

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ): vc.products.isNotEmpty
                            ? SingleChildScrollView(
                                  controller: svc.noSubScrollController,
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: kToolbarHeight * 0.9,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12.r),
                                                bottomLeft: Radius.circular(12.r))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(12),
                                              child:
                                                  GetBuilder<SwiggyViewController>(
                                                      builder: (vc) {
                                                return !vc.isLoading
                                                    ? Row(
                                                        children: [
                                                          Text(
                                                              "${svc.totalProducts} items",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                          Text(
                                                              " in ${svc.selectedSubCategory != null ? svc.selectedSubCategory!.name! : ""}")
                                                        ],
                                                      )
                                                    : Container(
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.20,
                                                        height:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height *
                                                                0.32 *
                                                                0.08,
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey.shade100,
                                                        ),
                                                      );
                                              }),
                                            ),
                                            Expanded(
                                                child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Divider(
                                                        color: Colors.grey.shade300,
                                                        thickness: 0.6,
                                                        height: 0)))
                                          ],
                                        ),
                                      ),
                                      GetBuilder<SwiggyViewController>(
                                          builder: (vc) {
                                        return !vc.isLoading
                                            ? GridView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemCount: svc.products.length,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  mainAxisExtent:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.34,
                                                ),
                                                itemBuilder: (context, index) {
                                                  var product = svc.products[index];
                                                  return SwiggyViewProduct(
                                                    product: product,
                                                    index: index,
                                                  );
                                                })
                                            : GridView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemCount: 6,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  mainAxisExtent:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.34,
                                                ),
                                                itemBuilder: (context, index) {
                                                  return loader(context, index);
                                                });
                                      }),
                                      GetBuilder<SwiggyViewController>(
                                          builder: (vc) {
                                        return AnimatedContainer(
                                            duration:
                                                const Duration(milliseconds: 300),
                                            width:
                                                MediaQuery.of(context).size.width,
                                            margin: EdgeInsets.only(bottom: 8.h),
                                            decoration: BoxDecoration(
                                                color: AppColors.secondaryColor),
                                            height: vc.isLoadingNextPage ? 36.h : 0,
                                            child: Center(
                                              child: SizedBox(
                                                  width: 24.w,
                                                  height: 24.w,
                                                  child: Lottie.asset(
                                                      "assets/animations/preloader_white.json")),
                                            ));
                                      })
                                    ],
                                  ),
                                )
                              : initialLoader(context);
                      }
                    )
                ),

              ],
            );
          }
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 36.h),
        child: FloatingActionButton.small(
          onPressed: (){
            showFilterSheet(context);
          },
          child: Icon(Icons.filter_list)
        ),
      ),
    );
  }

   //
   showFilterSheet(BuildContext context) async {

    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context){
          return GetBuilder<SwiggyViewController>(
            builder: (vc) {
              return SizedBox(
                height: MediaQuery.of(context).size.height*0.8,
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: EdgeInsets.only(top: 20.h,left: 20.w),
                        child: Text(
                            "Choose price range",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                        ),
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height*0.1,
                        child: RangeSlider(
                            values: vc.filterPriceRange!,
                            min: 1,
                            max: 2000,
                            labels: RangeLabels(
                                vc.filterPriceRange!.start.toString(),
                                vc.filterPriceRange!.end.toString()),
                            onChanged: (v){
                              vc.filterPriceRange = v;
                              vc.update();
                            }),
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        //height: MediaQuery.of(context).size.height*0.1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text("\u{20B9} "+vc.filterPriceRange!.start.toStringAsFixed(0)),
                              Text("\u{20B9} "+vc.filterPriceRange!.end.toStringAsFixed(0)),

                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 12.h,
                      ),

                      Center(
                        child: CustomButton(
                          onTap: (){
                            Get.back();
                            svc.fetchProducts(isRefresh: true);
                          },
                          child: Text(
                              "Apply Filters",
                              style: TextStyle(
                                color: Colors.white
                              ),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              );
            }
          );
        }
    );
   }

  //
  initialLoader(BuildContext context){

    return Container(
      height: MediaQuery.of(context).size.height-(kToolbarHeight+MediaQuery.of(context).viewPadding.top),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400,width: 0.4),
          borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: [
          Container(
            height: kToolbarHeight*0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    bottomLeft: Radius.circular(12.r)
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GetBuilder<SwiggyViewController>(
                      builder: (vc) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          height: MediaQuery.of(context).size.height*0.32*0.08,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                          ),
                        );
                      }
                  ),
                ),

                Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Divider(color: Colors.grey.shade300,thickness: 0.6,height: 0)))

              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: MediaQuery.of(context).size.height*0.34,
                ),
                itemBuilder: (context,index){
                  return loader(context,index);
                }
            ),
          ),
        ],
      ),
    );
  }


  //
   showCategoriesDialog(BuildContext context) async {

    await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.all(1.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.r)),
            ),
            content: GetBuilder<SwiggyViewController>(builder: (vc){
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r)
                    ),
                    width: MediaQuery.of(context).size.width*0.9,
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Container(
                          height: kToolbarHeight,
                          margin: EdgeInsets.only(top: 16.h),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                  "Shop By Categories",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600
                                ),
                              ),

                              Text("${vc.categories.length} Categories")

                            ],
                          ),
                        ),

                        const Divider(height: 0.4,thickness: 0.4),

                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height*0.5,
                          ),
                          child: SingleChildScrollView(
                            child: GridView.builder(
                              itemCount: svc.categories.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisExtent: 90.h,
                                  crossAxisSpacing: 4.w,
                                  mainAxisSpacing: 4.h
                              ), itemBuilder: (BuildContext context, int index) {
                              var category = svc.categories[index];
                              return GestureDetector(
                                onTap: (){
                                  vc.categoryId = category.id;
                                  vc.categoryName = category.name;
                                  imageUrl = category.imageUrl;
                                  vc.fetchSubCategories();
                                  vc.fetchCategoryProducts();
                                  Get.back();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 0.h, left: 0.w, right: 0.w),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4.r),
                                      border: Border.all(
                                        color: AppColors.primaryColor.withOpacity(0.4),
                                        width: 0.5,
                                      )
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: category!.imageUrl ?? "",
                                        fit: BoxFit.fitHeight,
                                        height: MediaQuery.of(context).size.height * 0.20,
                                        errorWidget: (c, w, o) {
                                          return Image.asset(
                                              "assets/images/gnxt_logo.png");
                                        },
                                      ),
                                      SizedBox(height: 16.h),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          width: double.infinity,
                                          height: MediaQuery.of(context).size.height * 0.04,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    //AppColors.primaryColor.withOpacity(0.9),
                                                    //AppColors.primaryColor.withOpacity(0.2)
                                                    Colors.black.withOpacity(0.9),
                                                    Colors.black.withOpacity(0.01)
                                                  ])
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 6.h,left: 2.w,right: 2.w),
                                          child: Text(
                                            category.name!.toUpperCase(),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(fontSize: 10.sp,color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              );
            }),
          );
        });
   }

  //
  Widget loader(BuildContext context,int index){

    return Skeletonizer(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: index==0
                ? Border(
                right: BorderSide(
                  color: Colors.grey.shade200,
                ),
                bottom: BorderSide(color: Colors.grey.shade200)
            )
                : Border(
                right: BorderSide(color: Colors.grey.shade200),
                bottom: BorderSide(color: Colors.grey.shade200)
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
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                              width: MediaQuery.of(context).size.width * 0.34,
                              height: MediaQuery.of(context).size.height*0.32*0.4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12.r)
                              ),
                            ),

                            SizedBox(height: 12.h),

                            Container(
                              width: MediaQuery.of(context).size.width * 0.32,
                              height: MediaQuery.of(context).size.height*0.32*0.08,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                              ),
                            ),

                            SizedBox(height: 6.h),

                            Container(
                              width: MediaQuery.of(context).size.width * 0.20,
                              height: MediaQuery.of(context).size.height*0.32*0.08,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                              ),
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.28*0.4,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "",
                                      style: TextStyle(
                                        color: AppColors.secondaryColor,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child:  Container(
                                          width: MediaQuery.of(context).size.width * 0.20,
                                          height: MediaQuery.of(context).size.height*0.32*0.08,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                          ),
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
              ],
            )
          ],
        ),
      ),
    );
  }

  //
  categoriesLoader(){

    return SizedBox(
      height: 100.h,
      child: Column(
        children: [

          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            width: 50.w,
            height: 56.h,
            padding: EdgeInsets.only(top: 12.h),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey.shade400,width: 0.2),
              color:  Colors.grey.shade200,
              borderRadius: BorderRadius.all(Radius.circular(6.r)),
            )
          ),

        ],
      ),
    );
  }

}
