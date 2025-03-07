import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_node/custom_clippers/triangle_clipper.dart';

void main() {
  group('TriangleClipper', () {
    const clipper = TriangleClipper();

    test('should create a valid triangular path', () {
      const size = Size(100, 100);
      final path = clipper.getClip(size);

      expect(path, isA<Path>());
      expect(path.getBounds(), equals(const Rect.fromLTWH(0, 0, 100, 100)));
    });

    test('should create correct triangle vertices', () {
      const size = Size(100, 100);
      final path = clipper.getClip(size);

      final metrics = path.computeMetrics();
      expect(metrics.length, equals(1)); // 1 path metric for triangle

      // Verify path contains expected points
      expect(path.contains(Offset.zero), isTrue);
      expect(path.contains(Offset(size.width, size.height / 2)), isTrue);
      expect(path.contains(Offset(0, size.height)), isTrue);
    });

    test('should handle zero size correctly', () {
      const size = Size.zero;
      final path = clipper.getClip(size);

      expect(path, isA<Path>());
      expect(path.getBounds(), equals(Rect.zero));
    });

    test('should maintain proportions with different sizes', () {
      const size1 = Size(200, 100);
      const size2 = Size(100, 200);

      final path1 = clipper.getClip(size1);
      final path2 = clipper.getClip(size2);

      expect(path1.getBounds().width, equals(size1.width));
      expect(path1.getBounds().height, equals(size1.height));
      expect(path2.getBounds().width, equals(size2.width));
      expect(path2.getBounds().height, equals(size2.height));
    });

    test('shouldReclip should always return false', () {
      const oldClipper = TriangleClipper();

      expect(clipper.shouldReclip(oldClipper), isFalse);
    });

    testWidgets('should clip widget content correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ClipPath(
            clipper: clipper,
            child: Container(width: 100, height: 100, color: Colors.blue),
          ),
        ),
      );

      final clipPath = tester.widget<ClipPath>(find.byType(ClipPath));
      expect(clipPath.clipper, isA<TriangleClipper>());

      // Verify container is rendered
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
