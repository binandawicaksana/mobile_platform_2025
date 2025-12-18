import 'package:flutter/material.dart';

class MoneyLogoPainter extends CustomPainter {
  final Color color;
  final double waveHeightFactor;

  const MoneyLogoPainter(this.color, {this.waveHeightFactor = 0.13});

  @override
  void paint(Canvas canvas, Size size) {
    final waveHeight = size.height * waveHeightFactor;

    final path = Path()
      ..moveTo(0, waveHeight)
      ..quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, waveHeight)
      ..quadraticBezierTo(size.width * 0.75, waveHeight * 2, size.width, waveHeight)
      ..lineTo(size.width, size.height - waveHeight)
      ..quadraticBezierTo(size.width * 0.75, size.height, size.width * 0.5, size.height - waveHeight)
      ..quadraticBezierTo(size.width * 0.25, size.height - (waveHeight * 2), 0, size.height - waveHeight)
      ..close();

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
