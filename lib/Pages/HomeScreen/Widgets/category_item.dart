import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';

class CategoryItem extends StatelessWidget {
  final int? index;

  CategoryItem({Key? key, this.index}) : super(key: key);

  GlobalKey positionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      findPositionOfWidget();
    });

    return GetBuilder<HomeController>(
      builder: (vc) {
        double center = MediaQuery.of(context).size.width / 2;
        //double angle = 2 * pi / 7;
        //double xOffset = 4 * cos(angle);
        double yOffset;

        if (positionKey.currentContext != null) {
          double position = findPositionOfWidget();
          if (position < MediaQuery.of(context).size.width) {
            yOffset = 50;
            if (position < center) {
              var value = center - position;
              yOffset = (60 - (60 * (value / center)));
            } else {
              var value = position - center;
              yOffset = 60;
            }
          } else {
            yOffset = 50 ;
          }
        } else {
          yOffset = 0;
        }

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 2000),
            key: positionKey,
            width: MediaQuery.of(context).size.width * 0.22,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            height: 30.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Icon(Icons.person),
          ),
        );
      },
    );
  }

  findPositionOfWidget() {
    if (positionKey.currentContext != null) {
      RenderBox renderBox =
      positionKey.currentContext!.findRenderObject() as RenderBox;
      Offset position = renderBox.localToGlobal(Offset.zero);
      return position.dx;
    }
    return 0.0;
  }
}
