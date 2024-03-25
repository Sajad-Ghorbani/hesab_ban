import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';

class RPSCustomPainter extends CustomPainter {
  final bool isDark;

  RPSCustomPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()..style = PaintingStyle.fill;
    paint0.shader = ui.Gradient.linear(Offset(size.width * 0.50, size.height),
        Offset(size.width * 0.50, size.height * 0.35), [
      isDark ? kSurfaceColor.withOpacity(0.1) : kWhiteTealColor,
      isDark ? kWhiteBlueColor.withOpacity(0.7) : kTealColor,
    ], [
      0.00,
      1.00
    ]);

    Path path0 = Path();
    path0.moveTo(0, size.height * 0.7);
    path0.quadraticBezierTo(
        size.width * 0.5, size.height * 0.4, size.width, size.height * 0.7);
    path0.quadraticBezierTo(
        size.width, size.height * 0.7765000, size.width, size.height);
    path0.lineTo(0, size.height);
    path0.lineTo(0, size.height * 0.7);

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
