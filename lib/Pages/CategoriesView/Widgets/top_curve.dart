import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_nxt/Pages/CategoriesView/Widgets/top_curve_paint.dart';

class TopCurve extends StatelessWidget {
  const TopCurve({super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: kToolbarHeight*2.6,
      child: CustomPaint(
        painter: TopCurvePaint(),
        child: Center(
          child: Text("CATEGORIES",style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.75
          ))
        )
      )
    );
  }
}
