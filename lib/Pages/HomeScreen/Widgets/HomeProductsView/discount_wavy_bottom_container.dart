import 'package:flutter/material.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';

class WavyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.primaryColor.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(8,0);
    path.quadraticBezierTo(0,0,0,8);
    path.lineTo(0,size.height);
    path.lineTo(size.width*0.25,size.height * 0.9);
    path.lineTo(size.width*0.5,size.height);
    path.lineTo(size.width*0.75, size.height*0.9);
    path.lineTo(size.width,size.height);
    path.lineTo(size.width,0);
    path.lineTo(8,0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}