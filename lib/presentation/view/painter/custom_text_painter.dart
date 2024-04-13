import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomTextPainter extends CustomPainter {
  final List<Offset> points;

  CustomTextPainter({
    super.repaint,
    required this.points,
  });

  double _calculateDistance(Offset point1, Offset point2) {
    final dx = point2.dx - point1.dx;
    final dy = point2.dy - point1.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length >= 2) {
      for (int i = 1; i < points.length; i++) {
        final startPoint = points[i - 1];
        final endPoint = points[i];
        final distance = _calculateDistance(startPoint, endPoint);
        final angle = math.atan2(
            startPoint.dy - endPoint.dy, startPoint.dx - endPoint.dx);

        final textPainter = TextPainter(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: distance.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        final dx = endPoint.dx - startPoint.dx;
        final dy = endPoint.dy - startPoint.dy;
        final normal = Offset(dy, -dx); 
        final normalizedNormal =
            normal / math.sqrt(normal.dx * normal.dx + normal.dy * normal.dy);

        final middlePoint = Offset(
          (startPoint.dx + endPoint.dx) / 2,
          (startPoint.dy + endPoint.dy) / 2,
        );

        const double distanceFromLine = -20;
        final lineStart = startPoint + normalizedNormal * distanceFromLine;
        final lineEnd = endPoint + normalizedNormal * distanceFromLine;

        _drawArrowLine(
            canvas, lineStart, lineEnd, Paint()..color = Colors.grey);

        final textOffset = _calculateTextOffset(
          middlePoint,
          normalizedNormal,
          textPainter.width,
          textPainter.height,
        );

        final matrix4 = Matrix4.identity()
          ..translate(textOffset.dx, textOffset.dy)
          ..rotateZ(angle);
        final matrix = matrix4.storage;
        canvas.transform(matrix);
        textPainter.paint(canvas, Offset.zero);
        canvas.transform(Matrix4.inverted(matrix4).storage);
      }
    }
  }

  Offset _calculateTextOffset(Offset middlePoint, Offset normalizedNormal,
      double textWidth, double textHeight) {
    const double distanceFromLine = -20;
    final bool isHorizontalLine =
        normalizedNormal.dx.abs() > normalizedNormal.dy.abs();
    final bool isPositiveSide = (isHorizontalLine && normalizedNormal.dy > 0) ||
        (!isHorizontalLine && normalizedNormal.dx < 0);

    double offsetX =
        middlePoint.dx - textWidth / 2 + normalizedNormal.dx * distanceFromLine;
    double offsetY = middlePoint.dy -
        textHeight / 2 +
        normalizedNormal.dy * distanceFromLine;

    if (!isHorizontalLine) {
      offsetY += isPositiveSide ? textHeight : -textHeight;
    } else {
      offsetX += isPositiveSide ? -textWidth : textWidth;
    }

    return Offset(offsetX, offsetY);
  }

  void _drawArrowLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const arrowLength = 10.0;

    canvas.drawLine(start, end, paint);

    final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);
    final arrowPoint1 = Offset(
      end.dx - arrowLength * math.cos(angle - math.pi / 6),
      end.dy - arrowLength * math.sin(angle - math.pi / 6),
    );
    final arrowPoint2 = Offset(
      end.dx - arrowLength * math.cos(angle + math.pi / 6),
      end.dy - arrowLength * math.sin(angle + math.pi / 6),
    );
    final arrowPoint3 = Offset(
      start.dx + arrowLength * math.cos(angle - math.pi / 6),
      start.dy + arrowLength * math.sin(angle - math.pi / 6),
    );
    final arrowPoint4 = Offset(
      start.dx + arrowLength * math.cos(angle + math.pi / 6),
      start.dy + arrowLength * math.sin(angle + math.pi / 6),
    );

    final path = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy)
      ..moveTo(start.dx, start.dy)
      ..lineTo(arrowPoint3.dx, arrowPoint3.dy)
      ..lineTo(arrowPoint4.dx, arrowPoint4.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomTextPainter oldDelegate) =>
      oldDelegate.points != points;
}
