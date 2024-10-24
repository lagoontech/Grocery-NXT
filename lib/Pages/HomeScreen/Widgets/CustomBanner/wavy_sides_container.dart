import 'package:flutter/cupertino.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';

class WavySidesContainer extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {

    var width = size.width;
    var path  = Path()..moveTo(0,0);
    path.quadraticBezierTo(width*0.12,size.height*0.16,width*0.24,-10);
    path.quadraticBezierTo(width*0.26,size.height*0.16,width*0.38,-10);
    path.quadraticBezierTo(width*0.40,size.height*0.16,width*0.52,-10);
    path.quadraticBezierTo(width*0.52,size.height*0.16,width*0.66,-10);
    path.quadraticBezierTo(width*0.66,size.height*0.16,width*0.78,-10);
    path.quadraticBezierTo(width*0.78,size.height*0.16,width,-10);
    path.lineTo(size.width,size.height);
    path.lineTo(0,size.height);
    path.lineTo(0,0);

    var paint = Paint()..color=AppColors.primaryColor;
    canvas.drawPath(path,paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}