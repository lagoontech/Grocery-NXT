import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';

class TopCurvePaint extends CustomPainter{

  TopCurvePaint();
  var curveFactor;

  @override
  void paint(Canvas canvas, Size size) {

    var height = size.height;
    var width  = size.width;

    var path = Path()
      ..moveTo(0,0)
      ..lineTo(0,height*0.4)
      ..quadraticBezierTo(width/2,height,width,height*0.4)
      ..lineTo(size.width,0)
      ..lineTo(0,0);

    var fillPaint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}