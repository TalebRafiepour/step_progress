import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_node/step_node_shaped_container.dart';
import 'package:step_progress/step_progress.dart';

void main() {
  const testSize = 100.0;
  const testChild = Text('Test');
  const testDecoration = BoxDecoration(color: Colors.blue);

  Future<void> pumpShapedContainer(
    WidgetTester tester,
    StepNodeShape shape, {
    Widget? child,
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    BoxDecoration? decoration,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: StepNodeShapedContainer(
              stepNodeShape: shape,
              width: width,
              height: height,
              padding: padding,
              margin: margin,
              decoration: decoration,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  group('StepNodeShapedContainer', () {
    testWidgets('renders circle shape correctly', (tester) async {
      await pumpShapedContainer(
        tester,
        StepNodeShape.circle,
        width: testSize,
        height: testSize,
        child: testChild,
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(
        (container.decoration as BoxDecoration?)?.shape,
        equals(BoxShape.circle),
      );
      expect(container.constraints?.biggest.width, equals(testSize));
      expect(container.constraints?.biggest.height, equals(testSize));
      expect(find.byWidget(testChild), findsOneWidget);
    });

    testWidgets('renders square shape correctly', (tester) async {
      await pumpShapedContainer(
        tester,
        StepNodeShape.square,
        width: testSize,
        height: testSize,
        child: testChild,
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(
        (container.decoration as BoxDecoration?)?.shape,
        equals(BoxShape.rectangle),
      );
      expect(container.constraints?.biggest.width, equals(testSize));
      expect(container.constraints?.biggest.height, equals(testSize));
    });

    testWidgets('renders diamond shape with rotation', (tester) async {
      await pumpShapedContainer(
        tester,
        StepNodeShape.diamond,
        width: testSize,
        height: testSize,
      );

      expect(find.byType(AnimatedRotation), findsOneWidget);
      final rotation = tester.widget<AnimatedRotation>(
        find.byType(AnimatedRotation),
      );
      expect(rotation.turns, equals(3.141592653589793 / 2));
    });

    testWidgets('renders star shape with clipper', (tester) async {
      await pumpShapedContainer(
        tester,
        StepNodeShape.star,
        width: testSize,
        height: testSize,
      );

      expect(find.byType(ClipPath), findsOneWidget);
      final clipPath = tester.widget<ClipPath>(find.byType(ClipPath));
      expect(clipPath.clipper.runtimeType.toString(), contains('StarClipper'));
    });

    group('Polygon shapes', () {
      for (final shape in [
        StepNodeShape.pentagon,
        StepNodeShape.hexagon,
        StepNodeShape.heptagon,
        StepNodeShape.octagon,
      ]) {
        testWidgets('renders $shape correctly', (tester) async {
          await pumpShapedContainer(
            tester,
            shape,
            width: testSize,
            height: testSize,
          );

          expect(find.byType(ClipPath), findsOneWidget);
          final clipPath = tester.widget<ClipPath>(find.byType(ClipPath));
          expect(
            clipPath.clipper.runtimeType.toString(),
            contains('PolygonClipper'),
          );
        });
      }
    });

    testWidgets('applies padding correctly', (tester) async {
      const testPadding = EdgeInsets.all(8);
      await pumpShapedContainer(
        tester,
        StepNodeShape.square,
        padding: testPadding,
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, equals(testPadding));
    });

    testWidgets('applies margin correctly', (tester) async {
      const testMargin = EdgeInsets.all(8);
      await pumpShapedContainer(
        tester,
        StepNodeShape.square,
        margin: testMargin,
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.margin, equals(testMargin));
    });

    testWidgets('applies decoration correctly', (tester) async {
      await pumpShapedContainer(
        tester,
        StepNodeShape.square,
        decoration: testDecoration,
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(
        (container.decoration as BoxDecoration?)?.color,
        equals(Colors.blue),
      );
    });

    testWidgets('renders triangle shape with clipper', (tester) async {
      await pumpShapedContainer(
        tester,
        StepNodeShape.triangle,
        width: testSize,
        height: testSize,
      );

      expect(find.byType(ClipPath), findsOneWidget);
      final clipPath = tester.widget<ClipPath>(find.byType(ClipPath));
      expect(
        clipPath.clipper.runtimeType.toString(),
        contains('TriangleClipper'),
      );
    });
  });
}
