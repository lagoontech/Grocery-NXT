import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'curved_product_container.dart';

class ProductListItem extends StatelessWidget {
   ProductListItem({super.key,this.index});

   int ?index;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      child: CustomPaint(
        painter: CurvedProductContainer(),
        child: Padding(
          padding:
          EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
          child: Column(
            children: [
              Image.asset(
                index == 0
                    ? "assets/demo assets/image 17.png"
                    : "assets/demo assets/front_en.195 1.png",
                width: MediaQuery.of(context).size.width * 0.38 * 0.6,
                height: MediaQuery.of(context).size.height * 0.3*0.3,
              ),
              SizedBox(height: 8.h),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height*0.28*0.2,
                  child: Text(
                    index == 0
                        ? " SKYR Nutella 1 Litre"
                        : "Bell Pepper",
                    maxLines: 2,
                    style: TextStyle(fontSize: 12.sp),
                    textAlign: TextAlign.center,
                  )),
              Row(
                children: [
                  Text(
                    "\u{20B9}${940}",
                    style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12.sp),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    "52% Off",
                    style: TextStyle(fontSize: 10.sp),
                  ),
                  Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "\u{20B9}450",
                          style: TextStyle(color: Colors.red),
                        ),
                      ))
                ],
              ),

              SizedBox(height: 12.h),

              SizedBox(
                width: double.infinity,
                height: 28.h,
                child: CustomPaint(
                  painter: CurvedProductContainer(
                      curvePercent: 1
                  ),
                  child: Center(child: Icon(Icons.add,color: Colors.green,)),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
