import 'package:flutter/material.dart';

import 'constants/constants.dart';

class BottomBarPainter extends CustomPainter {
  BottomBarPainter({
    required this.horizontalPosition,
    required this.color,
    required this.showShadow,
    required this.notchColor,
    this.notchBorderColor,
    required this.height,
    required this.margin,
  })  : _paint = Paint()
          ..color = color
          ..isAntiAlias = true,
        _shadowColor = Colors.grey.shade600,
        _notchPaint = Paint()
          ..color = notchColor
          ..isAntiAlias = true;

  /// position
  final double horizontalPosition;

  /// Color for the bottom bar
  final Color color;

  /// Paint value to custom painter
  final Paint _paint;

  /// Shadow Color
  final Color _shadowColor;

  /// Boolean to show shadow
  final bool showShadow;

  /// Paint Value of notch
  final Paint _notchPaint;

  /// Color for the notch
  final Color notchColor;

  /// Color for the notch border
  final Color? notchBorderColor;

  final double margin;

  final double height;

  static const heightOffset = 32.0;

  static const borderWidth = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBar(canvas, size);
    _drawFloatingCircle(canvas);
  }

  @override
  bool shouldRepaint(BottomBarPainter oldDelegate) {
    return horizontalPosition != oldDelegate.horizontalPosition ||
        color != oldDelegate.color;
  }

  /// draw bottom bar
  void _drawBar(Canvas canvas, Size size) {
    final double left = margin;
    final double right = size.width - margin;
    final double top = margin;
    final double bottom = top + height;
    final a = Offset(left + kBottomRadius, bottom);
    final b = Offset(-kBottomRadius, -kBottomRadius);

    final path = Path()
      ..moveTo(left + kTopRadius, top)
      ..lineTo(horizontalPosition - kTopRadius, top + 0)
      ..relativeArcToPoint(
        const Offset(kTopRadius, kTopRadius),
        radius: const Radius.circular(kTopRadius),
      )
      ..relativeArcToPoint(
        const Offset((kCircleRadius + kCircleMargin) * 2, 0.0),
        radius: const Radius.circular(kCircleRadius + kCircleMargin),
        clockwise: false,
      )
      ..relativeArcToPoint(
        const Offset(kTopRadius, -kTopRadius),
        radius: const Radius.circular(kTopRadius),
      )
      ..lineTo(right - kTopRadius, top)
      ..relativeArcToPoint(
        const Offset(kTopRadius, kTopRadius),
        radius: const Radius.circular(kTopRadius),
      )
      ..lineTo(right, bottom - kBottomRadius)
      ..relativeArcToPoint(
        const Offset(-kBottomRadius, kBottomRadius),
        radius: const Radius.circular(kBottomRadius),
      )
      ..lineTo(left + kBottomRadius, bottom)
      ..relativeArcToPoint(
        const Offset(-kBottomRadius, -kBottomRadius),
        radius: const Radius.circular(kBottomRadius),
      )
      ..lineTo(left, top + kTopRadius)
      ..relativeArcToPoint(
        const Offset(kTopRadius, -kTopRadius),
        radius: const Radius.circular(kTopRadius),
      );
    if (this.showShadow) {
      canvas..drawShadow(path, _shadowColor, 5.0, true);
    }
    canvas.drawPath(path, _paint);
    canvas.drawLine(
      a,
      b,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
  }

  /// Function used to draw the circular indicator
  void _drawFloatingCircle(Canvas canvas) {
    final path = Path()
      ..addArc(
        Rect.fromCircle(
          center: Offset(
            horizontalPosition + kCircleMargin + kCircleRadius,
            margin + kCircleMargin + heightOffset,
          ),
          radius: kCircleRadius -
              (notchBorderColor != null ? borderWidth : kCircleRadius),
        ),
        0,
        kPi * 2,
      );
    if (this.showShadow) {
      canvas..drawShadow(path, _shadowColor, 5.0, true);
    }
    canvas.drawPath(path, _notchPaint);

    if (notchBorderColor != null) {
      final borderPaint = _notchPaint
        ..color = notchBorderColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth
        ..isAntiAlias = true;
      canvas.drawPath(path, borderPaint);
    }
  }
}
