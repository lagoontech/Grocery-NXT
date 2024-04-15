import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';

import 'category_scroll_indicator.dart';

class ScrollIndicator extends StatelessWidget {
  const ScrollIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0,-12.h),
      child: GetBuilder<HomeController>(
        id: "scrollIndicator",
        builder: (vc) {
          return Center(
            child: Container(
              width: 60.w,
              height: 10.h,
              child: CustomPaint(
                painter: CategoryScrollIndicator(progress: vc.currentCategoryScrollProgress),
              ),
            ),
          );
        }
      ),
    );
  }
}
