import 'dart:math' as math;

import 'package:flutter/material.dart';

class ElectronicMoneyLogoPainter extends CustomPainter {
  final Color baseColor;
  final Color strokeColor;

  const ElectronicMoneyLogoPainter({
    this.baseColor = const Color(0xFF7A4DFF),
    this.strokeColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.height * 0.22);
    final baseRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      radius,
    );
    final basePaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(baseRect, basePaint);

    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final padding = size.width * 0.12;
    final centerShift = size.width * 0.04;
    final innerWidth = size.width * 0.36;
    final innerHeight = size.height * 0.22;
    final innerRect = Rect.fromLTWH(
      padding + centerShift,
      (size.height - innerHeight) / 2,
      innerWidth,
      innerHeight,
    );
    canvas.drawRect(innerRect, strokePaint);

    final waveStartX = innerRect.right + padding * 0.6 + centerShift * 0.4;
    final waveEndX = size.width - padding * 0.6;
    final availableWidth = (waveEndX - waveStartX).clamp(0, size.width);
    if (availableWidth > 0) {
      final waveY = size.height * 0.5;
      final maxRadius = math.min(availableWidth, size.height * 0.32);
      final minRadius = maxRadius * 0.4;
      final step = (maxRadius - minRadius) / 2;
      final center = Offset(waveStartX, waveY);
      final startAngle = -math.pi / 3;
      final sweepAngle = (2 * math.pi) / 3;

      for (int i = 0; i < 3; i++) {
        final radius = minRadius + (step * i);
        if (radius <= 0) {
          continue;
        }
        final rect = Rect.fromCircle(center: center, radius: radius);
        canvas.drawArc(rect, startAngle, sweepAngle, false, strokePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
