import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/ProductsSearchScreen/Widgets/searched_product.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../AllProductsView/Widgets/all_products_list_item.dart';
import '../AllProductsView/Widgets/all_products_list_item_curved_container.dart';
import '../CartView/cart_view.dart';
import '../HomeScreen/Controller/cart_controller.dart';
import '../HomeScreen/Widgets/HomeProductsView/curved_cart_add_container.dart';
import 'Controller/products_search_controller.dart';

class ProductsSearchScreen extends StatelessWidget {

  ProductsSearchScreen({super.key});

  ProductsSearchController vc = Get.put(ProductsSearchController());

  @override
  Widget build(BuildContext context) {

    return AddToCartAnimation(
      cartKey: vc.cartIconKey,
      height: 30,
      width: 30,
      opacity: 1,
      dragAnimation: const DragToCartAnimationOptions(
        rotation: true,
      ),
      jumpAnimation: const JumpAnimationOptions(
          curve: Curves.easeOutSine,
          duration: Duration(milliseconds: 250)
      ),
      createAddToCartAnimation: (runAddToCartAnimation) {
        vc.runAddToCartAnimation = runAddToCartAnimation;
      },
      child: Scaffold(
        body: CustomScrollView(
          controller: vc.sc,
          slivers: [

            SliverAppBar(
              pinned: true,
              floating: true,
              automaticallyImplyLeading: false,
              toolbarHeight: kToolbarHeight*1.4,
              flexibleSpace: Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).viewPadding.top + 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: TextFormField(
                      focusNode: vc.focusNode,
                      controller: vc.searchTEC,
                      onChanged: (v){
                        vc.listenToSearch();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 4.h),
                        hintText: "Search Products",
                        isDense: true,
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.primaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(12.r)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                GetBuilder<ProductsSearchController>(
                  builder: (vc) {
                    return vc.suggestedCategories.isNotEmpty
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Updated header text with better style and spacing
                        Text(
                          "Suggested Categories",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        SizedBox(
                          height: 40.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: vc.suggestedCategories.length,
                            itemBuilder: (context, index) {
                              var category = vc.suggestedCategories[index];
                              bool isSelected = vc.selectedCategory == category;

                              return GestureDetector(
                                onTap: () {
                                  vc.selectedCategory = category;
                                  vc.searchProducts(isRefresh: true);
                                  vc.update();
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200), // Smooth transition on selection
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primaryColor : Colors.white,
                                    border: Border.all(color: AppColors.primaryColor.withOpacity(0.8)),
                                    borderRadius: BorderRadius.circular(20.r),
                                    boxShadow: isSelected
                                        ? [
                                      BoxShadow(
                                        color: AppColors.primaryColor.withOpacity(0.3),
                                        offset: Offset(0, 4),
                                        blurRadius: 8,
                                      ),
                                    ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      category.name!,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : AppColors.primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                        : SizedBox.shrink(); // Replaced SizedBox() with SizedBox.shrink() for cleaner code
                  },
                ),

                SizedBox(height: 20.h), // Extra space for padding at the bottom
              ],
            ),
          ),
        ),


        SliverToBoxAdapter(
              child: Column(
                children: [

                  SizedBox(
                    height: 20.h,
                  ),

                  GetBuilder<ProductsSearchController>(builder: (vc) {
                    return !vc.loading && vc.searchedProducts.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                  "assets/animations/not_found.json"),
                              SizedBox(height: 20.h),
                              Text(
                                "No Products Found",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 16.sp),
                              ),
                            ],
                          )
                        : !vc.loading
                            ? AnimationLimiter(
                                child: GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 8.h),
                                    itemCount: vc.searchedProducts.length,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisExtent: MediaQuery.of(context)
                                                        .size
                                                        .height * 0.28,
                                            mainAxisSpacing: 2.h,
                                            crossAxisSpacing: 8.w),
                                    itemBuilder: (context, index) {
                                      var product = vc.searchedProducts[index];
                                      return AnimationConfiguration
                                          .staggeredGrid(
                                        columnCount: 2,
                                        position: index,
                                        child: SlideAnimation(
                                          verticalOffset: 50.h,
                                          duration: const Duration(
                                              milliseconds: 750),
                                          child: FadeInAnimation(
                                            duration: const Duration(
                                                milliseconds: 750),
                                            child: SearchedProduct(
                                                index: index,
                                                product: product),
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            : GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                                itemCount: 9,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent:
                                            MediaQuery.of(context).size.height * 0.28,
                                        mainAxisSpacing: 2.h,
                                        crossAxisSpacing: 8.w),
                                itemBuilder: (context, index) {
                                  return loader(context);
                                });
                  }),

                  GetBuilder<ProductsSearchController>(
                    builder: (vc) {
                      return vc.showNextLoading
                          ? GetBuilder<ProductsSearchController>(
                          builder: (vc){
                            return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(bottom: 8.h),
                                decoration: BoxDecoration(
                                    color: AppColors.secondaryColor
                                ),
                                height: vc.showNextLoading?36.h:0,
                                child: Center(
                                  child: SizedBox(
                                      width: 24.w,
                                      height: 24.w,
                                      child: Lottie.asset("assets/animations/preloader_white.json")
                                  ),
                                )
                            );}): const SizedBox();
                    }
                  )

                ],
              ),
            ),

          ],
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 60.h),
          child: FloatingActionButton(
            onPressed: (){
              Get.to(()=>CartView());
            },
            child: AddToCartIcon(
                key: vc.cartIconKey,
                badgeOptions: const BadgeOptions(active: false),
                icon: GetBuilder<CartController>(builder: (vc) {
                  return Badge(
                      label: Text(vc.totalProducts.toString()),
                      child: const Icon(Icons.shopping_bag_outlined));
                })),
          ),
        ),
      ),
    );
  }

  //
  Widget loader(BuildContext context) {
    return Skeletonizer(
      child: CustomPaint(
        painter: AllProductsCurvedProductContainer(),
        child: Padding(
          padding: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.38 * 0.6,
                height: MediaQuery.of(context).size.height * 0.28 * 0.3,
              ),
              SizedBox(height: 4.h),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.28 * 0.3,
                  child: AutoSizeText(
                    "safasf fdsdss ggdfgfdg gdfgdfg",
                    maxLines: 3,
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )),
              Row(
                children: [
                  Text(
                    "\u{20B9}${1}",
                    style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 11.sp),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "\u{20B9}${1}",
                      style: TextStyle(color: Colors.red, fontSize: 10.sp),
                    ),
                  ))
                ],
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                height: 20.h,
                child: CustomPaint(
                  painter: CurvedCartAddContainer(curvePercent: 1),
                  child: GestureDetector(
                      onTap: () async {
                        //await cc.runAddToCartAnimation(widgetKey);
                      },
                      child: const Center(
                          child: Icon(Icons.add, color: Colors.green))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
