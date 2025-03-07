import 'dart:math';
import 'package:flutter/material.dart';

/// A custom clipper that clips a widget into a polygon shape.
///
/// This class extends [CustomClipper] and overrides the [getClip] and
/// [shouldReclip] methods to define the clipping behavior.
///
/// The [PolygonClipper] can be used to create various polygon shapes by
/// specifying the number of sides and other properties.
///
/// Example usage:
/// ```dart
/// ClipPath(
///   clipper: PolygonClipper(6),
///   child: Container(
///     color: Colors.blue,
///   ),
/// )
/// ```
///
/// See also:
///  * [CustomClipper], the base class for creating custom clippers.
class PolygonClipper extends CustomClipper<Path> {
  const PolygonClipper(this.sides);

  /// The number of sides for the polygon.
  final int sides;

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double angle = (2 * pi) / sides;

    // Start at the top center
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = min(size.width, size.height) / 2;

    for (int i = 0; i < sides; i++) {
      final double x = center.dx + radius * cos(i * angle - pi / 2);
      final double y = center.dy + radius * sin(i * angle - pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
