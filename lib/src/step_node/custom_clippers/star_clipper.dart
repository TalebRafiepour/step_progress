import 'dart:math';
import 'package:flutter/material.dart';

/// A custom clipper that generates a star-shaped [Path].
///
/// This clipper builds a star with 5 points (i.e. 10 vertices by alternating
/// between outer and inner points), based on the provided [Size]. The star is
/// centered within the given size.
class StarClipper extends CustomClipper<Path> {
  const StarClipper();

  /// Generates the star-shaped [Path] based on the provided [size].
  ///
  /// The star is constructed by calculating alternating outer and inner
  /// points. The outer radius is half the width of the provided [size], while
  /// the inner radius is determined by reducing the outer radius by a factor
  /// of 2.5. The shape is drawn by connecting the computed points and then
  /// closing the path.
  ///
  /// Parameters:
  /// - [size]: The size of the widget in which the star is drawn.
  ///
  /// Returns:
  /// - A [Path] object that defines the star shape.
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Number of star points (outer vertices). A standard star with 5 tips
    // requires 10 total points (5 outer and 5 inner).
    const int numPoints = 5;

    // Calculate the outer radius as half the width of the provided size.
    final outerRadius = size.width / 2;

    // Calculate the inner radius by reducing the outer radius.
    final innerRadius = outerRadius / 2.5;

    // The center of the star.
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Initialize the starting angle for the top of the star (rotated -90°
    // from the x-axis).
    double angle = -pi / 2;

    // Angle between each point (outer and inner alternate).
    const angleStep = pi / numPoints;

    // Build the star by connecting outer and inner points alternately.
    for (int i = 0; i < numPoints * 2; i++) {
      // Chooses the radius: use outerRadius for even indices, innerRadius
      // for odd.
      final double radius = i.isEven ? outerRadius : innerRadius;
      final double x = centerX + radius * cos(angle);
      final double y = centerY + radius * sin(angle);

      // For the first point, move the path to the point.
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      angle += angleStep;
    }

    // Close the path to finalize the star shape.
    path.close();
    return path;
  }

  /// Determines whether the clip should be recomputed when a new instance is
  /// provided.
  ///
  /// In this case, since the star shape does not change dynamically with any
  /// properties,
  /// it always returns false.
  ///
  /// Parameters:
  /// - [oldClipper]: The previous instance of [CustomClipper<Path>].
  ///
  /// Returns:
  /// - [bool] indicating that the clip path does not need to be recalculated.
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
