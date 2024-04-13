import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final bool isEditMode;
  final Offset startPoint;
  final Offset endPoint;
  final bool isGridEnabled;

  DrawingPainter(this.points, this.isEditMode,
      {required this.startPoint,
      required this.endPoint,
      required this.isGridEnabled});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 7.0;

    final dotsPaint = Paint()
      ..color = isEditMode ? Colors.white : Colors.blue
      ..style = PaintingStyle.fill;

    final dotsBackPaint = Paint()
      ..color = isEditMode ? Colors.grey : Colors.white
      ..style = PaintingStyle.fill;

    final polygonPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    if (isGridEnabled) {
      const double step = 50.0; // Размер шага сетки
      final gridPaint = Paint()
        ..color = Colors.grey.withOpacity(0.5)
        ..strokeWidth = 1.0;

      for (double i = 0; i < size.width; i += step) {
        canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
      }

      for (double i = 0; i < size.height; i += step) {
        canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
      }
    }

    if (!isEditMode && (startPoint != Offset.zero || endPoint != Offset.zero)) {
      final tempPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 7.0;
      final tempBgDotsPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      final tempDotsPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;

      canvas.drawLine(startPoint, endPoint, tempPaint);
      canvas.drawCircle(startPoint, 7, tempBgDotsPaint);
      canvas.drawCircle(startPoint, 5, tempDotsPaint);
      canvas.drawCircle(endPoint, 7, tempBgDotsPaint);
      canvas.drawCircle(endPoint, 5, tempDotsPaint);
    }

    if (points.isNotEmpty) {
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      if (isEditMode && points.length > 2) {
        path.lineTo(points.first.dx, points.first.dy);
        canvas.drawPath(path, polygonPaint);
        canvas.drawPath(path, linePaint);
      } else {
        canvas.drawPath(path, linePaint);
      }
    }

    for (final point in points) {
      canvas.drawCircle(point, 7, dotsBackPaint);
      canvas.drawCircle(point, isEditMode ? 6 : 5, dotsPaint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.startPoint != startPoint ||
        oldDelegate.endPoint != endPoint ||
        oldDelegate.points != points ||
        oldDelegate.isEditMode != isEditMode ||
        oldDelegate.isGridEnabled != isGridEnabled;
  }
}