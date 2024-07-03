import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/SwiggyView/swiggy_view.dart';
import '../../Models/home_categories_model.dart';

class CategoryItem extends StatelessWidget {
  final int? index;
  CategoryModel ?category;

  CategoryItem({Key? key, this.index,this.category}) : super(key: key);

  GlobalKey positionKey = GlobalKey();
  HomeController hc = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      findPositionOfWidget();
    });

    return GetBuilder<HomeController>(
      builder: (vc) {
        double offsetY = calculateOffsetY(context);
        return GestureDetector(
          onTap: (){
            Get.to(()=> SwiggyView(
              categoryId: category!.id,
              categoryName: category!.name,
              imageUrl: category!.imageUrl,
            ));
          },
          child: Transform.translate(
            offset: Offset(0, offsetY),
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.25,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      key: positionKey,
                      width: MediaQuery.of(context).size.width * 0.16,
                      margin: EdgeInsets.symmetric(horizontal: 12.w),
                      height: 30.h,
                      decoration: const BoxDecoration(
                       shape: BoxShape.circle,
                        color: Color(0xffE9F5FA)
                        ),
                      child: FractionallySizedBox(
                        widthFactor: 0.6,
                        heightFactor: 0.6,
                        child: CachedNetworkImage(
                            imageUrl: category!.imageUrl??"",
                            width: 30,
                            height: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.20,
                  child: Center(
                    child: Text(category!.name??"",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                      ),),
                  ),
                )
              ],
            ),
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
      Offset position = renderBox.localToGlobal(Offset(0,hc.homeSc.offset));
      double centerX  = MediaQuery.of(context).size.width / 2.5;
      double centerY  = MediaQuery.of(context).size.height / 2.1;
      double distanceToCenter = sqrt(pow(position.dx - centerX, 2) + pow(position.dy - centerY*0.96, 2));

      /*if (kDebugMode) {
        print("positionx-->$index-->${position.dx}");
        print("dtc-->$index-->$distanceToCenter");
      }*/
      double offsetY = (centerX - distanceToCenter) * 0.1;

      if(centerX-distanceToCenter<50){
        offsetY = (centerX - distanceToCenter) * 0.32;
      }
      /*if(position.dx>=MediaQuery.of(context).size.width*0.64){
        offsetY = (centerX - distanceToCenter) * 0.33;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.65){
        offsetY = (centerX - distanceToCenter) * 0.34;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.66){
        offsetY = (centerX - distanceToCenter) * 0.35;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.67){
        offsetY = (centerX - distanceToCenter) * 0.36;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.68){
        offsetY = (centerX - distanceToCenter) * 0.37;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.69){
        offsetY = (centerX - distanceToCenter) * 0.38;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.70){
        offsetY = (centerX - distanceToCenter) * 0.39;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.71){
        offsetY = (centerX - distanceToCenter) * 0.40;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.72){
        offsetY = (centerX - distanceToCenter) * 0.41;
      }
      if(position.dx>=MediaQuery.of(context).size.width*0.75){
        offsetY = (centerX - distanceToCenter) * 0.42;
      }*/
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
