import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/AllProductsView/Controller/all_products_controller.dart';
import 'package:grocery_nxt/Pages/AllProductsView/Widgets/all_products_list_item.dart';
import 'package:grocery_nxt/Pages/CartView/cart_view.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Models/home_categories_model.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../HomeScreen/Widgets/HomeProductsView/curved_cart_add_container.dart';
import 'Widgets/all_products_list_item_curved_container.dart';

class AllProductsView extends StatelessWidget {
  AllProductsView({super.key, this.category});

  AllProductsController vc = Get.put(AllProductsController());
  CartController cc = Get.find<CartController>();
  CategoryModel? category;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (category != null && vc.selectedCategory!.name == "") {
        vc.selectedCategory = category;
        vc.fetchProducts(isRefresh: true);
      }
      if (category == null && vc.initialLoading) {
        vc.selectedCategory = CategoryModel(name: "All Products");
        vc.fetchProducts(isRefresh: true);
      }
    });
    return AddToCartAnimation(
      cartKey: vc.cartIconKey,
      height: 30,
      width: 30,
      opacity: 0.95,
      dragAnimation: const DragToCartAnimationOptions(
        rotation: true,
      ),
      jumpAnimation: const JumpAnimationOptions(duration: Duration(milliseconds: 200)),
      createAddToCartAnimation: (runAddToCartAnimation) {
        vc.runAddToCartAnimation = runAddToCartAnimation;
      },
      child: Scaffold(
        appBar: AppBar(
          titleTextStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: AnimatedSearchBar(
              label: 'Products',
              controller: vc.searchTEC,
              labelAlignment: Alignment.center,
              animationDuration: const Duration(milliseconds: 3000),
              duration: const Duration(milliseconds: 3000),
              labelStyle: TextStyle(fontSize: 16.sp),
              searchStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
              cursorColor: Colors.black,
              textInputAction: TextInputAction.done,
              searchIcon: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200)),
                child: const Icon(Icons.search),
              ),
              searchDecoration: InputDecoration(
                hintText: 'Search Products',
                isDense: true,
                alignLabelWithHint: true,
                fillColor: Colors.white,
                focusColor: Colors.white,
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(12.r)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(12.r)
                ),
              ),
              onChanged: (value) {
                //vc.debounceSearch();
              },
              onFieldSubmitted: (value) {
                debugPrint('value on Field Submitted');
              }),
        ),
        body: GetBuilder<AllProductsController>(builder: (vc) {
          return Container(
            color: Colors.grey.shade50,
            child: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                controller: vc.sc,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    toolbarHeight: 55.h,
                    automaticallyImplyLeading: false,
                    flexibleSpace: !vc.isLoadingCategories
                        ? Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50.h,
                                color: Colors.white,
                                child: TabBar(
                                    controller: vc.tabController,
                                    padding: EdgeInsets.zero,
                                    isScrollable: true,
                                    tabAlignment: TabAlignment.start,
                                    indicatorColor: AppColors.primaryColor,
                                    unselectedLabelStyle: const TextStyle(
                                        color: Colors.black),
                                    labelStyle: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w600,
                                    ),
                                    onTap: vc.onTabBarTapped,
                                    tabs: vc.categories
                                        .map((e) => Tab(
                                              text: e!.name!,
                                            ))
                                        .toList()),
                              ),
                            ],
                          )
                        : SizedBox(
                          height: 2.h,
                          child: const LinearProgressIndicator(),
                        ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    vc.isLoading
                        ? GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            itemCount: 9,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: MediaQuery.of(context).size.height * 0.28,
                                    mainAxisSpacing: 2.h,
                                    crossAxisSpacing: 8.w),
                            itemBuilder: (context, index) {
                              return loader(context);
                            })
                        :vc.products.isEmpty?Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Lottie.asset("assets/animations/not_found.json"),
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
                        : Column(
                            children: [

                              Padding(
                                padding: EdgeInsets.only(left: 16.w,top: 12.h,bottom: 4.h),
                                child: Row(
                                  children: [

                                    Text(
                                        vc.totalProducts.toString()+" items ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp
                                        ),
                                    ),

                                    Text(
                                      "in ${vc.selectedCategory!.name}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                              AnimationLimiter(
                                child: GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 8.h),
                                    itemCount: vc.products.length,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisExtent:
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.28,
                                            mainAxisSpacing: 2.h,
                                            crossAxisSpacing: 8.w),
                                    itemBuilder: (context, index) {
                                      var product = vc.products[index];
                                      return AnimationConfiguration
                                          .staggeredGrid(
                                        columnCount: 2,
                                        position: index,
                                        child: SlideAnimation(
                                          verticalOffset: 50.h,
                                          duration:
                                              const Duration(milliseconds: 750),
                                          child: FadeInAnimation(
                                            duration: const Duration(
                                                milliseconds: 750),
                                            child: AllProductsListItem(
                                                index: index, product: product),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              GetBuilder<AllProductsController>(builder: (vc) {
                                return vc.showNextLoading
                                    ? SizedBox(
                                        height: 60.h,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Lottie.asset(
                                            "assets/animations/next_page_loader.json"),
                                      )
                                    : const SizedBox();
                              })
                            ],
                          )
                  ]))
                ],
              ),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [];
              },
            ),
          );
        }),
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
                      label: Text(cc.totalProducts.toString()),
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
                          child: Icon(
                              Icons.add,
                              color: Colors.green))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
