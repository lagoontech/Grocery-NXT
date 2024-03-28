import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurvedCartAddContainer extends CustomPainter {
  CurvedCartAddContainer({this.curvePercent});
  final double? curvePercent;

  @override
  void paint(Canvas canvas, Size size) {
    var height = size.height;
    var width = size.width;
    var cornerRadius = 8.0; // Adjust the corner radius as needed

    var path = Path()
      ..moveTo(0, height - height * 0.1)
      ..quadraticBezierTo(width/2,height*1.5,width,height-height*0.1)
      ..lineTo(width,0)
      ..quadraticBezierTo(width/2,height*0.1,0,0)
      ..close();

    // Define a Paint object for filling the path
    var fillPaint = Paint()
      ..color = curvePercent!=null
          ? const Color(0xfff5f5f5)
          : Colors.white // Set the fill color
      ..style = PaintingStyle.fill; // Set the painting style to fill

    // Draw the filled area of the path
    canvas.drawPath(path, fillPaint);

    // Define a Paint object for drawing the border
    var borderPaint = Paint()
      ..color = Colors.grey.shade300 // Set the border color
      ..style = PaintingStyle.stroke // Set the painting style to stroke
      ..strokeWidth = 1.0; // Set the border width

    // Draw the border of the path
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
