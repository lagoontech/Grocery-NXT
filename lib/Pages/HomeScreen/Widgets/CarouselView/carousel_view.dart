import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarouselView extends StatelessWidget {
   CarouselView({super.key});

   List<Color> colors = [Color(0xffFEE6B4),Color(0xffFFBFBF)];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [

        SizedBox(height: 8.h),

        SizedBox(
          height: 108.h,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 16.w,right: 16.w),
              itemCount: 2,
              itemBuilder: (context,index){
            return Stack(
              children: [
                Container(
                  width: size.width*0.7,
                  margin: EdgeInsets.only(right: 16.w),
                  padding: EdgeInsets.only(left: 8.w),
                  decoration: BoxDecoration(
                    color: colors[index],
                    borderRadius: BorderRadius.all(Radius.circular(16.r)),
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
                                alignment: Alignment.center,
                                child: Text(
                                    "Banner Content from Api",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600
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
                                    "Buy Now",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 10.sp),),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),

                      Expanded(
                        child: SizedBox(
                          height: 124.h,
                        ),
                      )

                    ],
                  ),
                ),

                Positioned(
                  right: 6.w,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Transform.translate(
                      offset: Offset(4.w,-6.h),
                      child: Image.asset(
                        index==0
                            ? "assets/demo assets/chips.png"
                            : "assets/demo assets/chips2.png",
                        width: MediaQuery.of(context).size.width*0.7*0.5,
                        height: 120.h,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
