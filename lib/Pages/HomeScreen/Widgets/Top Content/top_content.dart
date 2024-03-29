import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/Top%20Content/category_item.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Models/home_categories_model.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/ScrollIndicator/category_scroll_indicator.dart';

class TopContent extends StatelessWidget {
  TopContent({super.key});

  HomeController hc = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      hc.sc.animateTo(
          -20,
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
                height: MediaQuery.of(context).size.height * 0.3,
                color: AppColors.primaryColor,
              ),
            ),

            Positioned(
              top: 40.h,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.3,
                child: NotificationListener(
                  onNotification: (ScrollNotification v){
                    hc.update();
                    return true;
                  },
                  child: GetBuilder<HomeController>(
                    id: "categories",
                    builder: (vc) {
                      return ListView.builder(
                          controller: hc.sc,
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2,left: 24.w),
                          physics: const BouncingScrollPhysics(),
                          itemCount: vc.categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            if(vc.categories.isEmpty){
                              return const SizedBox();
                            }
                            var category = vc.categories[index];
                            return CategoryItem(
                                index:index,
                                category: category
                            ).animate(
                              effects: [
                                const FadeEffect()
                              ]
                            );
                          }) ;
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
