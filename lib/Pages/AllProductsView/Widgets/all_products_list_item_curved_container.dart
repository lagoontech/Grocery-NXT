import 'package:flutter/material.dart';
import '../../../Constants/app_colors.dart';

class AllProductsCurvedProductContainer extends CustomPainter {
  AllProductsCurvedProductContainer({this.curvePercent});
  double? curvePercent;

  @override
  void paint(Canvas canvas, Size size) {
    var height = size.height;
    var width = size.width;
    var cornerRadius = 8.0; // Adjust the corner radius as needed

    var path = Path()
      ..moveTo(0, height - height * 0.1)
      ..quadraticBezierTo(width / 2, curvePercent == null ? height : height * 1.4, width, height - height * 0.1)
      ..lineTo(width, cornerRadius) // Top-right corner
      ..quadraticBezierTo(width, 0, width - cornerRadius, 0) // Top-right to top-left curve
      ..lineTo(cornerRadius, 0) // Top-left corner
      ..quadraticBezierTo(0, 0, 0, cornerRadius) // Top-left to bottom-left curve
      ..lineTo(0, height - height * 0.1)
      ..close();

    // Define a Paint object for filling the path
    var fillPaint = Paint()
      ..color = curvePercent != null ? const Color(0xfff5f5f5) : Colors.white // Set the fill color
      ..style = PaintingStyle.fill; // Set the painting style to fill

    // Draw the filled area of the path
    canvas.drawPath(path, fillPaint);

    // Define a Paint object for drawing the border
    var borderPaint = Paint()
      ..color = AppColors.primaryColor // Set the border color
      ..style = PaintingStyle.stroke // Set the painting style to stroke
      ..strokeWidth = 0.0; // Set the border width

    // Draw the border of the path
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
