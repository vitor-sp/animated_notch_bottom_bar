import 'dart:ui';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
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
    required this.animation,
    required this.itemAnimationType,
    required this.overallAnimationPercentage,
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

  final Animation<double> animation;

  final double overallAnimationPercentage;

  final ItemAnimationType itemAnimationType;

  @override
  void paint(Canvas canvas, Size size) {
    final circleRadius = kCircleRadius -
        (notchBorderColor != null ? borderWidth : kCircleRadius);

    _drawBar(canvas, size, circleRadius);

    _drawFloatingCircle(canvas, circleRadius);
  }

  @override
  bool shouldRepaint(BottomBarPainter oldDelegate) {
    return horizontalPosition != oldDelegate.horizontalPosition ||
        color != oldDelegate.color;
  }

  /// draw bottom bar
  void _drawBar(Canvas canvas, Size size, double circleRadius) {
    final double left = margin;
    final double right = size.width - margin;
    final double top = margin;
    //We need this +3 adjustment to make the bottom bar look good, without it the bottom bar looks a bit off
    final double bottom = top + height;

    final sidesHeightDecaynment = size.height * .35;

    double firstItemDecaynment = 0.0;

    if (overallAnimationPercentage < .33) {
      firstItemDecaynment =
          sidesHeightDecaynment * (1 - (overallAnimationPercentage / .33));
    }

    double lastItemDecaynment = 0.0;

    if (overallAnimationPercentage > .66) {
      lastItemDecaynment =
          sidesHeightDecaynment * ((overallAnimationPercentage - .66) / .33);
    }

    final topLeft = Offset(left, top + firstItemDecaynment);
    final bottomLeft = Offset(left, bottom);
    final topRight = Offset(right, top + lastItemDecaynment);
    final bottomRight = Offset(right, bottom);

    final rectLeft = (horizontalPosition + (kCircleMargin + kCircleRadius) * 2)
        .roundToDouble();

    final rectBottom = bottom - 8;

    final rectTopLeft = Offset(horizontalPosition, top + firstItemDecaynment);

    final rectTopRight = Offset(
      rectLeft,
      top + lastItemDecaynment,
    );

    final rectBottomLeft = Offset(horizontalPosition, rectBottom);
    final rectBottomRight = Offset(rectLeft, rectBottom);

    // bottomLeft,
    // bottomRight,
    // topRight,
    // rectTopRight,
    // rectBottomRight,
    // rectBottomLeft,
    // rectTopLeft,
    // topLeft,
    // bottomLeft,

    final path = Path()
      ..moveTo(bottomLeft.dx, bottomLeft.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(topRight.dx, topRight.dy)
      //Concave curve where the notch is
      ..lineTo(rectTopRight.dx, rectTopRight.dy)
      ..lineTo(rectBottomRight.dx, rectBottomRight.dy)
      ..lineTo(rectBottomLeft.dx, rectBottomLeft.dy)
      ..lineTo(rectTopLeft.dx, rectTopLeft.dy)
      //End of concave curve
      ..lineTo(topLeft.dx, topLeft.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy);
    if (this.showShadow) {
      canvas..drawShadow(path, _shadowColor, 5.0, true);
    }
    canvas.drawPath(path, _paint);
  }

  /// Function used to draw the circular indicator
  void _drawFloatingCircle(Canvas canvas, double circleRadius) {
    final path = Path()
      ..addArc(
        Rect.fromCircle(
          center: Offset(
            horizontalPosition + kCircleMargin + kCircleRadius,
            margin + kCircleMargin + heightOffset,
          ),
          radius: circleRadius,
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
