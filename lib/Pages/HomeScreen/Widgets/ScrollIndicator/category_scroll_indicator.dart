import 'package:flutter/material.dart';

class CategoryScrollIndicator extends CustomPainter {
  final double progress; // Progress percentage (0.0 to 1.0)

  CategoryScrollIndicator({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    var height = size.height;
    var width = size.width;
    var cornerRadius = 8.0;

    // Calculate fill width based on progress
    var fillWidth = width * progress;

    var path = Path()
      ..moveTo(0, height - height * 0.1)
      ..quadraticBezierTo(width / 2, height * 3, width, height - height * 0.1)
      ..lineTo(width, cornerRadius)
      ..quadraticBezierTo(width, 5, width - cornerRadius, 10) // top-right corner
      ..quadraticBezierTo(width / 2, height * 2.2, cornerRadius, 10) // top border
      ..quadraticBezierTo(0, 5, 0, cornerRadius) // top-left corner
      ..lineTo(0, height - height * 0.1) // left border
      ..close();

    var fillGradient = LinearGradient(
      colors: const [Colors.green, Colors.white], // Adjust colors as needed
      begin: Alignment.centerLeft,
      stops: [progress,1],
      end: Alignment.centerRight,
    );

    var fillPaint = Paint()
      ..shader = fillGradient.createShader(
        Rect.fromLTWH(0, 0, fillWidth??0, height??0),
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    var borderPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
