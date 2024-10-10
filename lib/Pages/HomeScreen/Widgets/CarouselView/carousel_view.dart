import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/SwiggyView/swiggy_view.dart';

class CarouselView extends StatelessWidget {
  CarouselView({super.key});

  List<Color> colors = [const Color(0xffFEE6B4),const Color(0xffFFBFBF)];

  HomeController hc = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: 8.h),
        GetBuilder<HomeController>(
            id: "carousel",
            builder: (vc) {
              return !hc.loadingCarousel
                  ? SizedBox(
                      height: 102.h,
                      child: CarouselSlider(
                        carouselController: hc.carouselController,
                        items: vc.carousels
                            .map((carousel) => GestureDetector(
                                  onTap: () {
                                    if (carousel.category != null) {
                                      Get.to(() => SwiggyView(
                                            categoryId: vc.categories
                                                .firstWhere((element) =>
                                                    element!.name ==
                                                    carousel.category)!
                                                .id,
                                            categoryName: carousel.category,
                                          ));
                                    }
                                  },
                                  child: Stack(
                                    children: [

                                      Container(
                                        width: size.width,
                                        clipBehavior: Clip.antiAlias,
                                        margin: EdgeInsets.only(
                                            right: 16.w, left: 16.w),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(1,1),
                                              blurRadius: 10.sp,
                                              color: Colors.black.withOpacity(0.1)
                                            )
                                          ],
                                          gradient: LinearGradient(
                                              colors: [
                                                AppColors.primaryColor,
                                                AppColors.primaryColor.withOpacity(0.4),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              stops: const [0.3, 0.8]),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.r)),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: 116.h,
                                                child: CachedNetworkImage(
                                                    imageUrl: carousel.image!,
                                                    fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                    ]
                                  ),
                                ))
                            .toList(),
                        options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.24,
                            viewportFraction: 1.0,
                            autoPlay: true,
                            onPageChanged: (i, r) {
                              vc.currentCarouselIndex = i;
                              vc.update(["carouselIndicator"]);
                            }),
                      ),
                    )
                  : const SizedBox();
            }),
        SizedBox(height: 4.h),
        GetBuilder<HomeController>(
            id: "carouselIndicator",
            builder: (vc) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 32.w,
                      width: 32.w,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: vc.carousels.length,
                          itemBuilder: (context, index) {
                            return IndicatorItem(
                                current: vc.currentCarouselIndex == index);
                          }),
                    ),
                  ],
                ),
              );
            })
      ],
    );
  }

  //
  Widget IndicatorItem({bool current = false}) {
    return AnimatedContainer(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      duration: const Duration(milliseconds: 500),
      width: current ? 10.w : 6.w,
      height: current ? 10.w : 6.w,
      decoration:
          BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
    );
  }
}
