// ignore_for_file: avoid_redundant_argument_values

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_line/breadcrumb_clipper.dart';
import 'package:step_progress/src/step_line/step_line.dart';
import 'package:step_progress/step_progress.dart';

import '../helper/test_theme_wrapper.dart';

void main() {
  group('StepLine Widget Tests', () {
    const lineThickness = 5.0;
    const dummyStepLineStyle = StepLineStyle(lineThickness: lineThickness);
    testWidgets(
      'Horizontal StepLine active has full width and specified thickness',
      (tester) async {
        const testKey = Key('step_line_active_horizontal');

        await tester.pumpWidget(
          const TestThemeWrapper(
            child: SizedBox(
              width: 200,
              height: 50,
              child: Row(
                children: [
                  StepLine(
                    key: testKey,
                    stepLineStyle: dummyStepLineStyle,
                    highlighted: true,
                  ),
                ],
              ),
            ),
          ),
        );

        // Wait for animations to finish.
        await tester.pumpAndSettle();

        // The AnimatedContainer inside StepLine is used for the active color
        // fill.
        final animatedContainerFinder = find.descendant(
          of: find.byKey(testKey),
          matching: find.byType(AnimatedContainer),
        );
        expect(animatedContainerFinder, findsOneWidget);

        // For horizontal active, the animated container width should equal
        // the parent's width (200)
        // and its height should equal the defined lineThickness.
        final animatedSize = tester.getSize(animatedContainerFinder);
        expect(animatedSize.width, equals(200));
        expect(animatedSize.height, equals(lineThickness));
      },
    );

    testWidgets(
      'Horizontal StepLine inactive has zero width for AnimatedContainer',
      (tester) async {
        const testKey = Key('step_line_inactive_horizontal');

        await tester.pumpWidget(
          const TestThemeWrapper(
            child: SizedBox(
              width: 200,
              height: 50,
              child: Row(
                children: [
                  StepLine(stepLineStyle: dummyStepLineStyle, key: testKey),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final animatedContainerFinder = find.descendant(
          of: find.byKey(testKey),
          matching: find.byType(AnimatedContainer),
        );
        expect(animatedContainerFinder, findsOneWidget);

        final animatedSize = tester.getSize(animatedContainerFinder);
        // For horizontal inactive, the animated container width should be 0
        // while the height remains equal to lineThickness.
        expect(animatedSize.width, equals(0));
        expect(animatedSize.height, equals(lineThickness));
      },
    );

    testWidgets(
      'Vertical StepLine active has full height and  specified thickness',
      (tester) async {
        const testKey = Key('step_line_active_vertical');

        await tester.pumpWidget(
          const TestThemeWrapper(
            child: SizedBox(
              width: 50,
              height: 200,
              child: Column(
                children: [
                  StepLine(
                    key: testKey,
                    stepLineStyle: dummyStepLineStyle,
                    axis: Axis.vertical,
                    highlighted: true,
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final animatedContainerFinder = find.descendant(
          of: find.byKey(testKey),
          matching: find.byType(AnimatedContainer),
        );
        expect(animatedContainerFinder, findsOneWidget);

        final animatedSize = tester.getSize(animatedContainerFinder);
        // For vertical active, the width is set to the lineThickness
        // and height should match parent's height (200).
        expect(animatedSize.width, equals(lineThickness));
        expect(animatedSize.height, equals(200));
      },
    );

    testWidgets(
      'Vertical StepLine inactive has zero height for  AnimatedContainer',
      (tester) async {
        const testKey = Key('step_line_inactive_vertical');

        await tester.pumpWidget(
          const TestThemeWrapper(
            child: SizedBox(
              width: 50,
              height: 200,
              child: Column(
                children: [
                  StepLine(
                    key: testKey,
                    stepLineStyle: dummyStepLineStyle,
                    axis: Axis.vertical,
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final animatedContainerFinder = find.descendant(
          of: find.byKey(testKey),
          matching: find.byType(AnimatedContainer),
        );
        expect(animatedContainerFinder, findsOneWidget);

        final animatedSize = tester.getSize(animatedContainerFinder);
        // For vertical inactive, the animated container height should be 0
        // while the width remains equal to lineThickness.
        expect(animatedSize.width, equals(lineThickness));
        expect(animatedSize.height, equals(0));
      },
    );

    testWidgets('StepLine onTap callback is triggered', (tester) async {
      bool tapped = false;
      const testKey = Key('step_line_tap');

      await tester.pumpWidget(
        TestThemeWrapper(
          child: Row(
            children: [
              StepLine(
                key: testKey,
                highlighted: true,
                onTap: () {
                  tapped = true;
                },
              ),
            ],
          ),
        ),
      );

      // Ensure the widget is present.
      expect(find.byKey(testKey), findsOneWidget);

      // Simulate tapping the StepLine.
      await tester.tap(find.byKey(testKey));
      await tester.pumpAndSettle();

      // Check that the callback was executed.
      expect(tapped, isTrue);
    });

    testWidgets('StepLine handles absence of theme and uses default values', (
      tester,
    ) async {
      // In this test, no StepProgressTheme is provided, so the widget should
      // fallback to default colors and values.
      const testKey = Key('step_line_no_theme');

      await tester.pumpWidget(
        const TestThemeWrapper(
          child: Row(children: [StepLine(key: testKey, highlighted: true)]),
        ),
      );

      await tester.pumpAndSettle();

      // We cannot directly check colors without accessing the rendering
      // details,
      // but we can at least verify that the widget tree contains the
      // expected containers.
      final containerFinder = find.descendant(
        of: find.byKey(testKey),
        matching: find.byType(Container),
      );
      expect(containerFinder, findsWidgets);
    });

    testWidgets('StepLine with breadcrumb style creates ClipPath widget', (
      tester,
    ) async {
      const testKey = Key('step_line_breadcrumb');
      const chevronAngle = 30.0;

      const breadcrumbStyle = StepLineStyle(
        lineThickness: lineThickness,
        isBreadcrumb: true,
        chevronAngle: chevronAngle,
      );

      await tester.pumpWidget(
        const TestThemeWrapper(
          child: Row(
            children: [
              StepLine(
                key: testKey,
                stepLineStyle: breadcrumbStyle,
                highlighted: true,
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify ClipPath is used when isBreadcrumb is true
      final clipPathFinder = find.descendant(
        of: find.byKey(testKey),
        matching: find.byType(ClipPath),
      );
      expect(
        clipPathFinder,
        findsOneWidget,
      ); // Ensure that the ClipPath is present in the widget tree.

      // Verify BreadcrumbClipper parameters
      final clipPath = tester.widget<ClipPath>(clipPathFinder);
      final clipper = clipPath.clipper! as BreadcrumbClipper;
      expect(clipper.angle, equals(chevronAngle));
      expect(clipper.axis, equals(Axis.horizontal));
      expect(clipper.isReversed, equals(false));
    });

    testWidgets(
      'StepLine with reversed breadcrumb style sets correct direction',
      (tester) async {
        const testKey = Key('step_line_breadcrumb_reversed');
        const chevronAngle = 30.0;

        const breadcrumbStyle = StepLineStyle(
          lineThickness: lineThickness,
          isBreadcrumb: true,
          chevronAngle: chevronAngle,
        );

        await tester.pumpWidget(
          const TestThemeWrapper(
            child: Row(
              children: [
                StepLine(
                  key: testKey,
                  stepLineStyle: breadcrumbStyle,
                  highlighted: true,
                  isReversed: true,
                ),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();

        final clipPathFinder = find.descendant(
          of: find.byKey(testKey),
          matching: find.byType(ClipPath),
        );

        final clipPath = tester.widget<ClipPath>(clipPathFinder.first);
        final clipper = clipPath.clipper! as BreadcrumbClipper;
        expect(clipper.isReversed, equals(true));
      },
    );

    testWidgets(
      'StepLine with dotted border style renders DottedBorder widget',
      (tester) async {
        const testKey = Key('step_line_dotted');
        const dottedBorderStyle = OuterBorderStyle(
          isDotted: true,
          borderWidth: 2,
          dashPattern: [4, 2],
          defaultBorderColor: Colors.grey,
          activeBorderColor: Colors.blue,
        );
        const style = StepLineStyle(
          lineThickness: 8,
          borderStyle: dottedBorderStyle,
        );

        await tester.pumpWidget(
          const TestThemeWrapper(
            child: Row(
              children: [
                StepLine(
                  key: testKey,
                  stepLineStyle: style,
                  highlighted: true,
                ),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();

        // DottedBorder should be present
        expect(
          find.descendant(
            of: find.byKey(testKey),
            matching: find.byType(DottedBorder),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'StepLine with dotted border and breadcrumb style uses customPath',
      (tester) async {
        const testKey = Key('step_line_dotted_breadcrumb');
        const dottedBorderStyle = OuterBorderStyle(
          isDotted: true,
          borderWidth: 2,
          dashPattern: [4, 2],
          defaultBorderColor: Colors.grey,
          activeBorderColor: Colors.blue,
        );
        const chevronAngle = 25.0;
        const style = StepLineStyle(
          lineThickness: 8,
          borderStyle: dottedBorderStyle,
          isBreadcrumb: true,
          chevronAngle: chevronAngle,
        );

        await tester.pumpWidget(
          const TestThemeWrapper(
            child: Row(
              children: [
                StepLine(
                  key: testKey,
                  stepLineStyle: style,
                  highlighted: true,
                ),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();

        // DottedBorder should be present
        final dottedBorderFinder = find.descendant(
          of: find.byKey(testKey),
          matching: find.byType(DottedBorder),
        );
        expect(dottedBorderFinder, findsOneWidget);

        // ClipPath should also be present inside DottedBorder
        final clipPathFinder = find.descendant(
          of: find.byKey(testKey),
          matching: find.byType(ClipPath),
        );
        expect(clipPathFinder, findsOneWidget);
      },
    );
  });
}
