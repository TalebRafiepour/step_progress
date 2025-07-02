// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_label/step_label.dart';
import 'package:step_progress/src/step_node/step_node_ripple.dart';
import 'package:step_progress/src/step_progress_widgets/step_generator.dart';
import 'package:step_progress/step_progress.dart';

import '../helper/test_theme_wrapper.dart';

StepProgressThemeData get dummyThemeData => const StepProgressThemeData(
      enableRippleEffect: true,
      shape: StepNodeShape.circle,
      rippleEffectStyle: RippleEffectStyle(
        borderColor: Colors.blueAccent,
        borderWidth: 30,
      ),
      stepNodeStyle: StepNodeStyle(
        defaultForegroundColor: Colors.grey,
        activeForegroundColor: Colors.green,
      ),
      nodeLabelStyle:
          StepLabelStyle(titleStyle: TextStyle(color: Colors.black)),
      nodeLabelAlignment: StepLabelAlignment.top,
    );

void main() {
  group('StepGenerator Widget Tests', () {
    testWidgets('Displays title and subtitle correctly when provided', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StepProgressTheme(
            data: dummyThemeData,
            child: Scaffold(
              body: StepGenerator(
                width: 50,
                height: 50,
                anyLabelExist: true,
                stepIndex: 1,
                highlighted: true,
                axis: Axis.horizontal,
                title: 'Step 1',
                subTitle: 'Introduction',
                onTap: () {
                  tapped = true;
                },
                stepNodeIcon: const Icon(Icons.check),
              ),
            ),
          ),
        ),
      );

      // Check that the title and subtitle are present.
      expect(find.text('Step 1'), findsOneWidget);
      expect(find.text('Introduction'), findsOneWidget);

      // Check that the onTap callback is triggered.
      await tester.tap(find.byType(StepGenerator));
      expect(tapped, isTrue);
    });

    testWidgets('Does not display label when title and subTitle are null', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StepProgressTheme(
            data: dummyThemeData,
            child: const Scaffold(
              body: StepGenerator(
                width: 30,
                height: 30,
                anyLabelExist: false,
                stepIndex: 0,
                highlighted: false,
              ),
            ),
          ),
        ),
      );

      // Since no title and subTitle were supplied, the StepLabel should not
      // be visible.
      expect(find.byType(StepLabel), findsNothing);
    });

    testWidgets('Renders ripple effect when active and enabled in theme', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StepProgressTheme(
            data: dummyThemeData,
            child: const Scaffold(
              body: StepGenerator(
                width: 60,
                height: 60,
                stepIndex: 2,
                anyLabelExist: false,
                highlighted: true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The ripple effect widget should be present as the theme enables it
      // and isActive is true.
      expect(find.byType(StepNodeRipple), findsOneWidget);
    });

    testWidgets('Does not show ripple effect when inactive', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StepProgressTheme(
            data: dummyThemeData,
            child: const Scaffold(
              body: StepGenerator(
                width: 60,
                height: 60,
                anyLabelExist: false,
                stepIndex: 3,
                highlighted: false,
              ),
            ),
          ),
        ),
      );

      // If step is inactive, the ripple effect should not be visible.
      final finder = find.byType(StepNodeRipple);
      expect(finder, findsOneWidget);
      final stepNodeRippleWidget = tester.widget<StepNodeRipple>(finder);
      expect(stepNodeRippleWidget.isVisible, isFalse);
    });

    testWidgets(
      'Renders correctly with vertical axis and right label alignment',
      (tester) async {
        // Override the theme with a vertical axis scenario for testing.
        final customThemeData = dummyThemeData.copyWith(
          nodeLabelAlignment: StepLabelAlignment.right,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: StepProgressTheme(
              data: customThemeData,
              child: const Scaffold(
                body: StepGenerator(
                  width: 40,
                  height: 40,
                  stepIndex: 4,
                  highlighted: true,
                  axis: Axis.vertical,
                  anyLabelExist: true,
                  title: 'Vertical Step',
                  subTitle: 'Right side label',
                ),
              ),
            ),
          ),
        );

        // For vertical arrangements with right alignment, the label is
        // rendered after the node.
        // We check that the title text is found.
        expect(find.text('Vertical Step'), findsOneWidget);
      },
    );

    testWidgets('Handles tap gracefully when onTap is null', (tester) async {
      // Test that nothing crashes when onTap is null.
      await tester.pumpWidget(
        MaterialApp(
          home: StepProgressTheme(
            data: dummyThemeData,
            child: const Scaffold(
              body: StepGenerator(
                width: 50,
                height: 50,
                stepIndex: 5,
                highlighted: false,
                anyLabelExist: true,
                title: 'No Tap',
              ),
            ),
          ),
        ),
      );

      // Tapping should not throw any errors.
      await tester.tap(find.byType(StepGenerator));
      await tester.pump();
    });

    testWidgets('Throws error when StepProgressTheme is missing', (
      tester,
    ) async {
      // Negative test: Since StepGenerator uses StepProgressTheme.of(context)!,
      // not providing a theme should result in an exception.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StepGenerator(
              width: 40,
              height: 40,
              stepIndex: 6,
              highlighted: false,
              anyLabelExist: true,
              title: 'Error Expected',
            ),
          ),
        ),
      );

      // Expect an exception when we try to pump the widget.
      final exception = tester.takeException();
      expect(exception, isNotNull);
    });

    testWidgets('Supports even/odd step indices with topBottom alignment', (
      tester,
    ) async {
      // Testing the multi-side alignment with alternating label positions.
      final customThemeData = dummyThemeData.copyWith(
        nodeLabelAlignment: StepLabelAlignment.topBottom,
      );

      // Step with even index (should use one ordering)
      await tester.pumpWidget(
        MaterialApp(
          home: StepProgressTheme(
            data: customThemeData,
            child: const Scaffold(
              body: StepGenerator(
                width: 50,
                height: 50,
                stepIndex: 2, // even index
                highlighted: true,
                axis: Axis.horizontal,
                anyLabelExist: true,
                title: 'Even Step',
                subTitle: 'Test Even',
              ),
            ),
          ),
        ),
      );

      // make sure widgets are settle
      await tester.pumpAndSettle();

      expect(find.text('Even Step'), findsOneWidget);

      // Step with odd index (should use the other ordering)
      await tester.pumpWidget(
        MaterialApp(
          home: StepProgressTheme(
            data: customThemeData,
            child: const Scaffold(
              body: StepGenerator(
                width: 50,
                height: 50,
                stepIndex: 3, // odd index
                highlighted: true,
                axis: Axis.horizontal,
                anyLabelExist: true,
                title: 'Odd Step',
                subTitle: 'Test Odd',
              ),
            ),
          ),
        ),
      );

      // make sure widgets are settle
      await tester.pumpAndSettle();

      expect(find.text('Odd Step'), findsOneWidget);
    });

    testWidgets('Works with boundary conditions for size (width/height = 0)', (
      tester,
    ) async {
      // Test that providing zero size does not crash the widget.
      await tester.pumpWidget(
        MaterialApp(
          home: StepProgressTheme(
            data: dummyThemeData,
            child: const Scaffold(
              body: StepGenerator(
                width: 0,
                height: 0,
                stepIndex: 0,
                highlighted: false,
                anyLabelExist: false,
              ),
            ),
          ),
        ),
      );

      // Although size is zero, the widget is built without error.
      expect(find.byType(StepGenerator), findsOneWidget);
    });

    testWidgets('Renders correctly with StepLabelAlignment.left',
        (tester) async {
      final customThemeData = dummyThemeData.copyWith(
        nodeLabelAlignment: StepLabelAlignment.left,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: StepProgressTheme(
            data: customThemeData,
            child: const Scaffold(
              body: StepGenerator(
                width: 40,
                height: 40,
                stepIndex: 0,
                highlighted: true,
                anyLabelExist: true,
                title: 'Left Label',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Left Label'), findsOneWidget);
    });

    testWidgets('Renders correctly with StepLabelAlignment.bottom',
        (tester) async {
      final customThemeData = dummyThemeData.copyWith(
        nodeLabelAlignment: StepLabelAlignment.bottom,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: StepProgressTheme(
            data: customThemeData,
            child: const Scaffold(
              body: StepGenerator(
                width: 40,
                height: 40,
                stepIndex: 0,
                highlighted: true,
                anyLabelExist: true,
                title: 'Bottom Label',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Bottom Label'), findsOneWidget);
    });

    testWidgets('Renders correctly with StepLabelAlignment.bottomTop',
        (tester) async {
      final customThemeData = dummyThemeData.copyWith(
        nodeLabelAlignment: StepLabelAlignment.bottomTop,
      );

      await tester.pumpWidget(
        TestThemeWrapper(
          themeData: customThemeData,
          child: const StepGenerator(
            width: 40,
            height: 40,
            stepIndex: 1, // odd index
            highlighted: true,
            anyLabelExist: true,
            title: 'BottomTop Label',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('BottomTop Label'), findsOneWidget);
    });

    testWidgets('Renders correctly with StepLabelAlignment.rightLeft',
        (tester) async {
      final customThemeData = dummyThemeData.copyWith(
        nodeLabelAlignment: StepLabelAlignment.rightLeft,
      );

      await tester.pumpWidget(
        TestThemeWrapper(
          themeData: customThemeData,
          child: const StepGenerator(
            width: 40,
            height: 40,
            stepIndex: 1, // odd index
            highlighted: true,
            anyLabelExist: true,
            title: 'RightLeft Label',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('RightLeft Label'), findsOneWidget);
    });

    testWidgets('Renders correctly with StepLabelAlignment.leftRight',
        (tester) async {
      final customThemeData = dummyThemeData.copyWith(
        nodeLabelAlignment: StepLabelAlignment.leftRight,
      );

      await tester.pumpWidget(
        TestThemeWrapper(
          themeData: customThemeData,
          child: const StepGenerator(
            width: 40,
            height: 40,
            stepIndex: 2, // even index
            highlighted: true,
            anyLabelExist: true,
            title: 'LeftRight Label',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('LeftRight Label'), findsOneWidget);
    });
  });
}
