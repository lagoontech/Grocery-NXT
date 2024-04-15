import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';

class CurvedCartAddContainer extends CustomPainter {
  CurvedCartAddContainer({this.curvePercent,this.hasProduct=false});
  final double? curvePercent;
  bool ?hasProduct;

  @override
  void paint(Canvas canvas, Size size) {
    var height = size.height;
    var width = size.width;
    var cornerRadius = 8.0; // Adjust the corner radius as needed

    var path = Path()
      ..moveTo(0, height - height * 0.1)
      ..quadraticBezierTo(width/2,height*1.8,width,height-height*0.1)
      ..lineTo(width,0)
      ..quadraticBezierTo(width/2,height*0.1,0,0)
      ..close();

    // Define a Paint object for filling the path
    var fillPaint = Paint()
      ..color = hasProduct!
          ? AppColors.primaryColor.withOpacity(0.2)
          : Colors.grey.shade100 // Set the fill color
      ..style = PaintingStyle.fill; // Set the painting style to fill

    // Draw the filled area of the path
    canvas.drawPath(path, fillPaint);
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
