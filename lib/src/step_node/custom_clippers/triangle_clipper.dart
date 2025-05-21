import 'package:flutter/material.dart';

/// A custom clipper that clips a widget into a triangle shape.
///
/// This class extends [CustomClipper] and overrides the [getClip] method
/// to define a triangular path. The triangle is formed by drawing lines
/// from the top-left corner to the top-right corner, then to the bottom
/// center, and finally closing the path.
///
/// The [shouldReclip] method returns `false` indicating that the clip
/// does not need to be recalculated when the widget is rebuilt.
class TriangleClipper extends CustomClipper<Path> {
  const TriangleClipper();

  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
