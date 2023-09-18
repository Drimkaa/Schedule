import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  Path path;
   Color color;
   Gradient gradient;
  CurvePainter({required this.path, this.color = Colors.white,
    this.gradient = const LinearGradient( begin: Alignment.topLeft,
        end: Alignment.bottomRight,colors: [Colors.white, Colors.white], stops:  [0, 1])});
  @override
  void paint(Canvas canvas, Size size) {
    // paint the line
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
    ..shader = gradient.createShader(path.getBounds());
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}