import 'dart:math' show pi, tan;

import 'package:flutter/material.dart';

/// A custom clipper that defines a breadcrumb-shaped clipping path.
///
/// This class extends [CustomClipper] and is used to create a custom
/// clipping path in the shape of a breadcrumb. It can be used in
/// conjunction with widgets like [ClipPath] to apply the clipping
/// to child widgets.
///
/// Override the [getClip] method to define the breadcrumb shape,
/// and the [shouldReclip] method to determine whether the clip
/// needs to be recalculated when the widget is rebuilt.
class BreadcrumbClipper extends CustomClipper<Path> {
  const BreadcrumbClipper({
    required this.angle,
    required this.axis,
    required this.isReversed,
  });

  /// The angle of the breadcrumb clipper in degrees.
  final double angle;

  /// The axis along which the breadcrumb is oriented (horizontal or vertical).
  final Axis axis;

  /// Indicates whether the breadcrumb direction is reversed.
  final bool isReversed;

  @override
  Path getClip(Size size) {
    final path = Path();

    if (axis == Axis.horizontal) {
      final chevronWidth = size.height * tan(angle * pi / 180);
      if (isReversed) {
        path
          ..moveTo(size.width, 0)
          ..lineTo(chevronWidth, 0)
          ..lineTo(0, size.height / 2)
          ..lineTo(chevronWidth, size.height)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width - chevronWidth, size.height / 2)
          ..close();
      } else {
        path
          ..moveTo(0, 0)
          ..lineTo(size.width - chevronWidth, 0)
          ..lineTo(size.width, size.height / 2)
          ..lineTo(size.width - chevronWidth, size.height)
          ..lineTo(0, size.height)
          ..lineTo(chevronWidth, size.height / 2)
          ..close();
      }
    } else {
      final chevronHeight = size.width * tan(angle * pi / 180);

      if (isReversed) {
        path
          ..moveTo(0, size.height)
          ..lineTo(0, chevronHeight)
          ..lineTo(size.width / 2, 0)
          ..lineTo(size.width, chevronHeight)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width / 2, size.height - chevronHeight)
          ..close();
      } else {
        path
          ..moveTo(0, 0)
          ..lineTo(0, size.height - chevronHeight)
          ..lineTo(size.width / 2, size.height)
          ..lineTo(size.width, size.height - chevronHeight)
          ..lineTo(size.width, 0)
          ..lineTo(size.width / 2, chevronHeight)
          ..close();
      }
    }

    return path;
  }

  @override
  bool shouldReclip(BreadcrumbClipper oldClipper) =>
      angle != oldClipper.angle ||
      axis != oldClipper.axis ||
      isReversed != oldClipper.isReversed;
}
