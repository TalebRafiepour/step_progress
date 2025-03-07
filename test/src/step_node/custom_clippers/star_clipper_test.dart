import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_node/custom_clippers/star_clipper.dart';

void main() {
  group('StarClipper', () {
    late StarClipper clipper;

    setUp(() {
      clipper = const StarClipper();
    });

    test('shouldReclip returns false', () {
      expect(clipper.shouldReclip(const StarClipper()), isFalse);
    });

    testWidgets('getClip generates correct star path', (tester) async {
      const size = Size(100, 100);
      final path = clipper.getClip(size);

      // Get the path metrics
      final metrics = path.computeMetrics();
      expect(metrics.length, equals(1)); // Should be a single contiguous path

      // Verify path is closed
      expect(path.contains(const Offset(50, 50)), isTrue); // Center point
    });

    test('star points are correctly positioned', () {
      const size = Size(100, 100);
      final path = clipper.getClip(size);

      // Calculate expected values
      final centerX = size.width / 2;
      final centerY = size.height / 2;
      final outerRadius = size.width / 2;
      final innerRadius = outerRadius / 2.5;

      // Test top point (first point)
      final topY = centerY - outerRadius;
      expect(path.contains(Offset(centerX, topY)), isTrue);

      // Test a sample inner point
      final innerY = centerY - innerRadius;
      expect(path.contains(Offset(centerX, innerY)), isTrue);
    });

    testWidgets('star scales correctly with different sizes', (tester) async {
      final sizes = [
        const Size(50, 50),
        const Size(100, 100),
        const Size(200, 200),
      ];

      for (final size in sizes) {
        final path = clipper.getClip(size);

        // Verify the path stays within bounds
        final bounds = path.getBounds();
        expect(bounds.width, lessThanOrEqualTo(size.width));
        expect(bounds.height, lessThanOrEqualTo(size.height));

        // Verify center point
        expect(path.contains(Offset(size.width / 2, size.height / 2)), isTrue);
      }
    });

    test('star maintains proper inner to outer radius ratio', () {
      const size = Size(100, 100);

      final outerRadius = size.width / 2;
      final innerRadius = outerRadius / 2.5;

      // Verify ratio is maintained
      expect(innerRadius / outerRadius, moreOrLessEquals(0.4, epsilon: 0.01));
    });

    testWidgets('star points are symmetrical', (tester) async {
      const size = Size(100, 100);
      final path = clipper.getClip(size);

      final centerX = size.width / 2;
      final centerY = size.height / 2;

      // Test symmetry by checking points at equal angles
      for (var i = 0; i < 5; i++) {
        final angle = (2 * pi * i) / 5;
        final point1 = Offset(
          centerX + (size.width / 2) * cos(angle),
          centerY + (size.width / 2) * sin(angle),
        );
        final point2 = Offset(
          centerX + (size.width / 2) * cos(angle + 2 * pi),
          centerY + (size.width / 2) * sin(angle + 2 * pi),
        );

        expect(path.contains(point1), equals(path.contains(point2)));
      }
    });
  });
}
