import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  Path path;
   Color color;
  CurvePainter({required this.path, this.color = Colors.white});
  @override
  void paint(Canvas canvas, Size size) {
    // paint the line
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}