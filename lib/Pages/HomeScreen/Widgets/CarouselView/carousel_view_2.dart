import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/SwiggyView/swiggy_view.dart';

class CarouselView2 extends StatelessWidget {
  CarouselView2({super.key});

  List<Color> colors = [const Color(0xffFEE6B4),Color(0xffFFBFBF)];

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
              return !hc.loadingCarousel?SizedBox(
                height: 98.h,
                child: CarouselSlider(
                  carouselController: hc.carouselController,
                  items: vc.carousels2.map((carousel) => GestureDetector(
                    onTap: (){
                      Get.to(()=>SwiggyView(
                        categoryId: vc.categories.firstWhere((element) => element!.name==carousel.category)!.id,
                        categoryName: carousel.category,
                      ));
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: size.width,
                          margin: EdgeInsets.only(right: 16.w,left: 16.w),
                          padding: EdgeInsets.only(left: 8.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.primaryColor.withOpacity(0.4),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: const [0.3,0.8]
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8.r)),
                          ),
                          child: Row(
                            children: [

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    SizedBox(
                                      height: 44.h,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          carousel.title??"",
                                          textAlign: TextAlign.left,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 44.h,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: EdgeInsets.all(8.w),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20.r)
                                          ),
                                          child: Text(
                                            carousel.buttonText!,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600
                                            ),),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                              Expanded(
                                child: SizedBox(
                                  height: 124.h,
                                  child: CachedNetworkImage(
                                      imageUrl: carousel.image!
                                  ),
                                ),
                              )

                            ],
                          ),
                        ),

                      ],
                    ),
                  ) ).toList(), options: CarouselOptions(
                    height: MediaQuery.of(context).size.height*0.24,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    onPageChanged: (i,r){
                      vc.carouselIndex = i;
                      vc.update(["carouselIndicator"]);
                    }
                ),),
              ):const SizedBox();
            }
        ),

        SizedBox(height: 4.h),

        GetBuilder<HomeController>(
            id: "carouselIndicator",
            builder: (vc){
              return Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 20.h,
                  child: Center(
                    child: ListView.builder(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width*0.5-20.w),
                        itemCount: vc.carousels.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index){

                          return  AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 2.w),
                            width: index==vc.carouselIndex
                                ? 16.w
                                : vc.carouselIndex<index
                                ? index==1
                                ? 8.w*0.6
                                : (index-vc.carouselIndex)*8.w*0.6
                                : (index+1)*8.w*0.6,
                            height: index==vc.carouselIndex?16.h:8.h,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor.withOpacity((1.0-index*0.2))
                            ),
                          );
                        }),
                  ),
                ),
              );
            })
      ],
    );
  }
}
