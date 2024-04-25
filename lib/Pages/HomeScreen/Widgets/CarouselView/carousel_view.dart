import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';

class CarouselView extends StatelessWidget {
   CarouselView({super.key});

   List<Color> colors = [const Color(0xffFEE6B4),Color(0xffFFBFBF)];

   HomeController hc = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [

        SizedBox(height: 8.h),

        GetBuilder<HomeController>(
          builder: (vc) {
            return !hc.loadingCarousel?SizedBox(
              height: 108.h,
              child: CarouselSlider(
                items: vc.carousels.map((carousel) => Stack(
              children: [
                Container(
                  width: size.width,
                  margin: EdgeInsets.only(right: 16.w,left: 16.w),
                  padding: EdgeInsets.only(left: 8.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          const Color(0xff6de02c),
                          AppColors.primaryColor,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [0.0,0.5]
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
                              height: 54.h,
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
                              height: 54.h,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.r)
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
            ) ).toList(), options: CarouselOptions(
                height: MediaQuery.of(context).size.height*0.24,
                viewportFraction: 1.0,
                autoPlay: true,
              ),),
            ):SizedBox();
          }
        ),
      ],
    );
  }
}
