import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/Top%20Content/category_item.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Models/home_categories_model.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/ScrollIndicator/category_scroll_indicator.dart';
import '../../../../Constants/app_size.dart';

class TopContent extends StatelessWidget {
  TopContent({super.key});

  HomeController hc = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      hc.sc.animateTo(
          -1,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn);
    });

    return Column(
      children: [

        Stack(
          clipBehavior: Clip.none,
          children: [

            ClipPath(
              clipper: BottomOutwardBezierClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.27,
                color: AppColors.primaryColor,
              ),
            ),

            Positioned(
              top: 40.h,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.29,
                child: NotificationListener(
                  onNotification: (ScrollNotification v){
                    hc.update();
                    return true;
                  },
                  child: GetBuilder<HomeController>(
                    id: "categories",
                    builder: (vc) {
                      return AnimationLimiter(
                        child: ListView.builder(
                            controller: hc.sc,
                            padding: EdgeInsets.only(
                                top: isIpad
                                    ? MediaQuery.of(context).size.height*0.14
                                    : MediaQuery.of(context).size.height*0.17),
                            physics: const BouncingScrollPhysics(),
                            itemCount: vc.exploreCategories.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if(vc.exploreCategories.isEmpty){
                                return const SizedBox();
                              }
                              var category = vc.exploreCategories[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                child: SlideAnimation(
                                  horizontalOffset: 200.w,
                                  duration: const Duration(milliseconds: 600),
                                  child: FadeInAnimation(
                                    duration: const Duration(milliseconds: 600),
                                    child: CategoryItem(
                                        index:index,
                                        category: category
                                    ),
                                  )
                                ),
                              );
                            }),
                      );
                    }
                  ),
                ),
              ),
            )

          ],
        ),
      ],
    );
  }
}

class BottomOutwardBezierClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40); // Adjust the curve height as needed
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 1.1,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
