import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/category_item.dart';

class TopContent extends StatelessWidget {
  TopContent({super.key});

  HomeController hc = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {

    return Stack(
      clipBehavior: Clip.none,
      children: [

        ClipPath(
          clipper: BottomOutwardBezierClipper(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.26,
            color: AppColors.primaryColor,
          ),
        ),

        Positioned(
          top: 40.h,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.26,
            child: NotificationListener(
              onNotification: (ScrollNotification v){
                hc.update();
                return true;
              },
              child: ListView.builder(
                  controller: hc.sc,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: 20,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CategoryItem(index:index);
                  }),
            ),
          ),
        )
        
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
