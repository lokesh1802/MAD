import 'package:flutter/material.dart';

class DicePainter extends CustomPainter {
  final int value;
  final bool isHeld;

  DicePainter({required this.value, required this.isHeld});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isHeld ? Colors.amber[100]! : Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

    // Draw shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2, 2, size.width, size.height),
        Radius.circular(10),
      ),
      shadowPaint,
    );

    // Draw dice body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(10),
      ),
      paint,
    );

    // Draw dots
    final dotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final dotSize = size.width / 10;
    final center = Offset(size.width / 2, size.height / 2);

    switch (value) {
      case 1:
        _drawDot(canvas, center, dotSize, dotPaint);
        break;
      case 2:
        _drawDot(canvas, Offset(center.dx - size.width / 4, center.dy - size.height / 4), dotSize, dotPaint);
        _drawDot(canvas, Offset(center.dx + size.width / 4, center.dy + size.height / 4), dotSize, dotPaint);
        break;
      case 3:
        _drawDot(canvas, Offset(center.dx - size.width / 4, center.dy - size.height / 4), dotSize, dotPaint);
        _drawDot(canvas, center, dotSize, dotPaint);
        _drawDot(canvas, Offset(center.dx + size.width / 4, center.dy + size.height / 4), dotSize, dotPaint);
        break;
      case 4:
        _drawDot(canvas, Offset(center.dx - size.width / 4, center.dy - size.height / 4), dotSize, dotPaint);
        _drawDot(canvas, Offset(center.dx + size.width / 4, center.dy - size.height / 4), dotSize, dotPaint);
        _drawDot(canvas, Offset(center.dx - size.width / 4, center.dy + size.height / 4), dotSize, dotPaint);
        _drawDot(canvas, Offset(center.dx + size.width / 4, center.dy + size.height / 4), dotSize, dotPaint);
        break;
      case 5:
        _drawDot(canvas, Offset(center.dx - size.width / 4, center.dy - size.height / 4), dotSize, dotPaint);
        _drawDot(canvas, Offset(center.dx + size.width / 4, center.dy - size.height / 4), dotSize, dotPaint);
        _drawDot(canvas, center, dotSize, dotPaint);
        _drawDot(canvas, Offset(center.dx - size.width / 4, center.dy + size.height / 4), dotSize, dotPaint);
        _drawDot(canvas, Offset(center.dx + size.width / 4, center.dy + size.height / 4), dotSize, dotPaint);
        break;
      case 6:
        _drawDot(canvas, Offset(center.dx - size.width / 4, center.dy - size.height / 4), dotSize, dotPaint);
        _drawDot(canvas, Offset(center.dx + size.width / 4, center.dy - size.height / 4), dotSize, dotPaint);
        _drawDot(canvas, Offset(center.dx - size.width / 4, center.dy), dotSize, dotPaint);
        _drawDot(canvas, Offset(center.dx + size.width / 4, center.dy), dotSize, dotPaint);
        _drawDot(canvas, Offset(center.dx - size.width / 4, center.dy + size.height / 4), dotSize, dotPaint);
        _drawDot(canvas, Offset(center.dx + size.width / 4, center.dy + size.height / 4), dotSize, dotPaint);
        break;
    }

    // Draw border for held dice
    if (isHeld) {
      final borderPaint = Paint()
        ..color = Colors.amber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(10),
        ),
        borderPaint,
      );
    }
  }

  void _drawDot(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawCircle(center, size, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}