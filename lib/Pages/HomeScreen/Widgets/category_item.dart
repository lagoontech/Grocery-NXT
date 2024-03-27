import 'dart:math';
import 'package:flutter/foundation.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      findPositionOfWidget();
    });

    return GetBuilder<HomeController>(
      builder: (vc) {
        double offsetY = calculateOffsetY(context);
        return Transform.translate(
          offset: Offset(0, offsetY),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 2000),
            key: positionKey,
            width: MediaQuery.of(context).size.width * 0.18,
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            height: 30.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffe9f5fa),
            ),
            child: const Icon(Icons.person,color: Colors.white),
          ),
        );
      },
    );
  }

  //
  double calculateOffsetY(BuildContext context) {
    if (positionKey.currentContext != null) {
      RenderBox renderBox =
      positionKey.currentContext!.findRenderObject() as RenderBox;
      Offset position = renderBox.localToGlobal(Offset.zero);
      double centerX  = MediaQuery.of(context).size.width / 2;
      double centerY  = MediaQuery.of(context).size.height / 2;
      double distanceToCenter = sqrt(pow(position.dx - centerX, 2) + pow(position.dy - centerY, 2));

      if (kDebugMode) {
        print("positionx-->$index-->${position.dx}");
        print("dtc-->$index-->$distanceToCenter");
      }
      double offsetY = (centerX - distanceToCenter) * 0.1;

      if(centerX-distanceToCenter<50){
        offsetY = (centerX - distanceToCenter) * 0.3;
      }
      /*if(centerX-distanceToCenter>250&&(centerX-distanceToCenter)<300){
        offsetY = (centerX - distanceToCenter) * 0.1;
      }*/
      if(position.dx>centerX){
        offsetY = (centerX - distanceToCenter) * 0.35;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.7){
        offsetY = (centerX - distanceToCenter) * 0.4;
      }
      return offsetY;
    }
    return 0.0;
  }

  //
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
