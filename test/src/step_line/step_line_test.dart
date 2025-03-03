import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_line/step_line.dart';

void main() {
  group('StepLine Widget Tests', () {
    testWidgets(
      'Horizontal StepLine active has full width and specified thickness',
      (tester) async {
        const lineThickness = 5.0;
        const testKey = Key('step_line_active_horizontal');

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 200,
                height: 50,
                child: Row(children: [StepLine(key: testKey, isActive: true)]),
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
        const lineThickness = 5.0;
        const testKey = Key('step_line_inactive_horizontal');

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 200,
                height: 50,
                child: Row(children: [StepLine(key: testKey)]),
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
        const lineThickness = 5.0;
        const testKey = Key('step_line_active_vertical');

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 50,
                height: 200,
                child: Column(
                  children: [
                    StepLine(key: testKey, axis: Axis.vertical, isActive: true),
                  ],
                ),
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
        const lineThickness = 5.0;
        const testKey = Key('step_line_inactive_vertical');

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 50,
                height: 200,
                child: Column(
                  children: [StepLine(key: testKey, axis: Axis.vertical)],
                ),
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
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                StepLine(
                  key: testKey,
                  isActive: true,
                  onTap: () {
                    tapped = true;
                  },
                ),
              ],
            ),
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
        const MaterialApp(
          home: Scaffold(
            body: Row(children: [StepLine(key: testKey, isActive: true)]),
          ),
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
  });
}
