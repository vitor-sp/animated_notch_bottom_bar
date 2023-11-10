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
    final double bottom = top + height + 3;

    double firstItemDecaynment = 0.0;

    if (itemAnimationType == ItemAnimationType.showingFirst) {
      firstItemDecaynment = animation.value * (size.height * .35);
    }

    double lastItemDecaynment = 0.0;

    if (itemAnimationType == ItemAnimationType.showingLast) {
      lastItemDecaynment = animation.value * (size.height * .35);
    }

    final topLeft = Offset(left, top + firstItemDecaynment);
    final bottomLeft = Offset(left, bottom);
    final topRight = Offset(right, top + lastItemDecaynment);
    final bottomRight = Offset(right, bottom);

    final path = Path()
      ..moveTo(left + kTopRadius, top)
      ..lineTo(horizontalPosition - kTopRadius, top)
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

    canvas.drawPoints(
      PointMode.polygon,
      [
        topLeft,
        bottomLeft,
        bottomRight,
        topRight,
        rectTopRight,
        rectBottomRight,
        rectBottomLeft,
        rectTopLeft,
        topLeft,
      ],
      Paint()
        ..color = Colors.purple.withOpacity(.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.drawCircle(
      Offset(horizontalPosition + circleRadius * 2, top),
      2,
      Paint()..color = Colors.amber,
    );

    // canvas.drawLine(
    //   bottomLeft,
    //   bottomRight,
    //   Paint()
    //     ..color = Colors.green
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = 2,
    // );
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
