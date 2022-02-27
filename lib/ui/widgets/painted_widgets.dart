import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    paint0.shader = ui.Gradient.linear(
        Offset(size.width * 0.50, size.height),
        Offset(size.width * 0.50, size.height * 0.30),
        [kRedColor, kLightPurpleColor],
        [0.00, 1.00]);

    Path path0 = Path();
    path0.moveTo(0, size.height * 0.7000000);
    path0.quadraticBezierTo(size.width * 0.5000000, size.height * 0.2995000,
        size.width, size.height * 0.7020000);
    path0.quadraticBezierTo(
        size.width, size.height * 0.7765000, size.width, size.height);
    path0.lineTo(0, size.height);
    path0.lineTo(0, size.height * 0.7000000);

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RPSCustomPainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    paint0.shader = ui.Gradient.linear(
        Offset(size.width * 0.50, size.height),
        Offset(size.width * 0.50, size.height * 0.30),
        [kRedColor.withOpacity(0.3), kLightPurpleColor.withOpacity(0.3)],
        [0.00, 1.00]);

    Path path0 = Path();
    path0.moveTo(0, size.height * 0.7000000);
    path0.quadraticBezierTo(size.width * 0.5000000, size.height * 0.2995000,
        size.width, size.height * 0.7020000);
    path0.quadraticBezierTo(
        size.width, size.height * 0.7765000, size.width, size.height);
    path0.lineTo(0, size.height);
    path0.lineTo(0, size.height * 0.7000000);

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RPSCustomPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    paint0.shader = ui.Gradient.linear(
        Offset(size.width * 0.50, size.height),
        Offset(size.width * 0.50, size.height * 0.30),
        [kRedColor.withOpacity(0.1), kLightPurpleColor.withOpacity(0.1)],
        [0.00, 1.00]);

    Path path0 = Path();
    path0.moveTo(0, size.height * 0.7000000);
    path0.quadraticBezierTo(size.width * 0.5000000, size.height * 0.2995000,
        size.width, size.height * 0.7020000);
    path0.quadraticBezierTo(
        size.width, size.height * 0.7765000, size.width, size.height);
    path0.lineTo(0, size.height);
    path0.lineTo(0, size.height * 0.7000000);

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
