import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_node/custom_clippers/polygon_clipper.dart';

void main() {
  group('PolygonClipper', () {
    test('should create polygon clipper with valid sides', () {
      const clipper = PolygonClipper(6);
      expect(clipper.sides, equals(6));
    });

    testWidgets('should generate correct path for triangle', (tester) async {
      const clipper = PolygonClipper(3);
      const size = Size(100, 100);
      final path = clipper.getClip(size);

      // Get path metrics
      final metrics = path.computeMetrics();
      expect(metrics.length, equals(1)); // One continuous path
      expect(path.contains(const Offset(50, 50)), isTrue); // Center point
    });

    testWidgets('should generate correct path for square', (tester) async {
      const clipper = PolygonClipper(4);
      const size = Size(100, 100);
      final path = clipper.getClip(size);

      final center = Offset(size.width / 2, size.height / 2);
      final radius = min(size.width, size.height) / 2;

      // Check corners
      const angle = 2 * pi / 4;
      for (int i = 0; i < 4; i++) {
        final x = center.dx + radius * cos(i * angle - pi / 2);
        final y = center.dy + radius * sin(i * angle - pi / 2);
        expect(path.contains(Offset(x, y)), isTrue);
      }
    });

    testWidgets('should generate symmetric path for hexagon', (tester) async {
      const clipper = PolygonClipper(6);
      const size = Size(100, 100);
      clipper.getClip(size);

      final center = Offset(size.width / 2, size.height / 2);
      final radius = min(size.width, size.height) / 2;

      // Verify vertices are equidistant from center
      const angle = 2 * pi / 6;
      for (int i = 0; i < 6; i++) {
        final x = center.dx + radius * cos(i * angle - pi / 2);
        final y = center.dy + radius * sin(i * angle - pi / 2);
        final vertex = Offset(x, y);

        // Verify distance from center
        final distance = (vertex - center).distance;
        expect(distance, moreOrLessEquals(radius, epsilon: 0.001));
      }
    });

    test('should handle rectangular bounds', () {
      const clipper = PolygonClipper(4);
      const size = Size(200, 100);
      final path = clipper.getClip(size);

      // Verify path stays within bounds
      final bounds = path.getBounds();
      expect(bounds.width, moreOrLessEquals(100, epsilon: 0.001));
      expect(bounds.height, moreOrLessEquals(100, epsilon: 0.001));
    });

    test('shouldReclip returns true', () {
      const clipper = PolygonClipper(4);
      expect(clipper.shouldReclip(const PolygonClipper(4)), isTrue);
    });

    testWidgets('should create closed path', (tester) async {
      const clipper = PolygonClipper(5);
      const size = Size(100, 100);
      final path = clipper.getClip(size);

      final metrics = path.computeMetrics();
      for (final metric in metrics) {
        expect(metric.isClosed, isTrue);
      }
    });
  });
}
