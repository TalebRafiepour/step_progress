import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_line/step_value_line.dart';

void main() {
  group('StepValueLine', () {
    testWidgets('renders a Container with correct color and borderRadius',
        (tester) async {
      const color = Colors.red;
      const borderRadius = Radius.circular(8);
      const size = Size(100, 10);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StepValueLine(
              activeColor: color,
              borderRadius: borderRadius,
              lineSize: size,
              highlighted: true,
              isHorizontal: true,
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, color);
      expect(decoration.borderRadius, const BorderRadius.all(borderRadius));
    });

    testWidgets('has correct width and height for horizontal orientation',
        (tester) async {
      const size = Size(120, 8);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StepValueLine(
              activeColor: Colors.blue,
              borderRadius: Radius.zero,
              lineSize: size,
              highlighted: true,
              isHorizontal: true,
              duration: Duration(milliseconds: 100),
            ),
          ),
        ),
      );

      // At start of animation, width should be 0
      final container0 = tester.widget<Container>(find.byType(Container));
      expect(container0.constraints?.minWidth ?? 0, 0);

      // Complete the animation
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.minWidth ?? 0, size.width);
      expect(container.constraints?.minHeight ?? 0, size.height);
    });

    testWidgets('has correct width and height for vertical orientation',
        (tester) async {
      const size = Size(12, 60);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StepValueLine(
              activeColor: Colors.green,
              borderRadius: Radius.zero,
              lineSize: size,
              highlighted: true,
              isHorizontal: false,
              duration: Duration(milliseconds: 100),
            ),
          ),
        ),
      );

      // At start of animation, height should be 0
      final container0 = tester.widget<Container>(find.byType(Container));
      expect(container0.constraints?.minHeight ?? 0, 0);

      // Complete the animation
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.minHeight ?? 0, size.height);
      expect(container.constraints?.minWidth ?? 0, size.width);
    });

    testWidgets('sets width/height to 0 when highlighted is false',
        (tester) async {
      const size = Size(50, 20);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StepValueLine(
              activeColor: Colors.black,
              borderRadius: Radius.zero,
              lineSize: size,
              highlighted: false,
              isHorizontal: true,
              duration: Duration(milliseconds: 100),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.minWidth ?? 0, 0);
      expect(container.constraints?.minHeight ?? 0, size.height);
    });

    testWidgets('calls onAnimationCompleted when animation finishes',
        (tester) async {
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepValueLine(
              activeColor: Colors.orange,
              borderRadius: Radius.zero,
              lineSize: const Size(40, 8),
              highlighted: true,
              isHorizontal: true,
              duration: const Duration(milliseconds: 50),
              onAnimationCompleted: () {
                completed = true;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(completed, isTrue);
    });

    testWidgets('disposes animationController without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StepValueLine(
              activeColor: Colors.purple,
              borderRadius: Radius.zero,
              lineSize: Size(30, 5),
              highlighted: true,
              isHorizontal: true,
              duration: Duration(milliseconds: 10),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pumpWidget(Container()); // Unmount widget
      // No exceptions should be thrown
    });
  });
}
