import 'dart:math';

import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 0.0
      ..color = Colors.white
      ..invertColors = false;

    Rect rect = Rect.fromCenter(
        center: Offset(size.width / 2, 0),
        width: size.width * 2.6,
        height: size.height);
    canvas.drawArc(rect, pi / 8 * 3, 1 * pi / 4, false, paint);
  }

  //在实际场景中正确利用此回调可以避免重绘开销，本示例我们简单的返回true
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
