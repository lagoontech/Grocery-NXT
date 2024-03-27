import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import '../Models/home_categories_model.dart';

class CategoryItem extends StatelessWidget {
  final int? index;
  CategoryModel ?category;

  CategoryItem({Key? key, this.index,this.category}) : super(key: key);

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
          child: Column(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 2000),
                  key: positionKey,
                  width: MediaQuery.of(context).size.width * 0.18,
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffe9f5fa),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.6,
                    heightFactor: 0.6,
                    child: CachedNetworkImage(
                        imageUrl: category!.imageUrl!,
                        width: 30,
                        height: 30,
                    ),
                  ),
                ),
              ),
              Text(category!.name!,
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600
                ),)
            ],
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
      if(position.dx>centerX*1.1){
        offsetY = (centerX - distanceToCenter) * 0.31;
      }
      if(position.dx>centerX*1.2){
        offsetY = (centerX - distanceToCenter) * 0.32;
      }
      if(position.dx>centerX*1.3){
        offsetY = (centerX - distanceToCenter) * 0.33;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.6){
        offsetY = (centerX - distanceToCenter) * 0.34;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.62){
        offsetY = (centerX - distanceToCenter) * 0.4;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.64){
        offsetY = (centerX - distanceToCenter) * 0.41;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.66){
        offsetY = (centerX - distanceToCenter) * 0.42;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.68){
        offsetY = (centerX - distanceToCenter) * 0.43;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.72){
        offsetY = (centerX - distanceToCenter) * 0.44;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.75){
        offsetY = (centerX - distanceToCenter) * 0.45;
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
