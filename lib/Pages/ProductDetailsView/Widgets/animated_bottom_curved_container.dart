import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';

class AnimatedBottomCurvedContainer extends CustomPainter{

  AnimatedBottomCurvedContainer(this.curveFactor);
  var curveFactor;

  @override
  void paint(Canvas canvas, Size size) {

    var height = size.height;
    var width  = size.width;

    var path = Path()
      ..moveTo(0, height - height * 0.1)
      ..quadraticBezierTo(width/2,height+(height*0.2*curveFactor),width,height-height*0.1)
      ..lineTo(width,0)
      ..lineTo(0,0);

    var fillPaint = Paint()
      ..color = AppColors.primaryColor.withOpacity(double.parse((0.2*curveFactor).toString()))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}