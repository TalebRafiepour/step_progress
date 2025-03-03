// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_node/step_node.dart';
import 'package:step_progress/src/step_progress_widgets/horizontal_step_progress.dart';
import 'package:step_progress/src/step_progress_widgets/vertical_step_progress.dart';
import 'package:step_progress/step_progress.dart';

void main() {
  group('StepProgress Widget - Positive Cases', () {
    testWidgets('Should build widget with horizontal axis correctly', (
      tester,
    ) async {
      // Build the widget with horizontal axis and verify presence of
      // HorizontalStepProgress.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepProgress(
              totalSteps: 3,
              currentStep: 1,
              axis: Axis.horizontal,
              nodeTitles: const ['Step 1', 'Step 2', 'Step 3'],
            ),
          ),
        ),
      );

      expect(find.byType(HorizontalStepProgress), findsOneWidget);
      // Verify that a title is rendered (implementation detail of
      // HorizontalStepProgress)
      expect(find.text('Step 2'), findsOneWidget);
    });

    testWidgets('Should build widget with vertical axis correctly', (
      tester,
    ) async {
      // Build the widget with vertical axis and verify presence of
      // VerticalStepProgress.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepProgress(
              totalSteps: 4,
              currentStep: 2,
              axis: Axis.vertical,
              nodeSubTitles: const ['A', 'B', 'C', 'D'],
            ),
          ),
        ),
      );

      expect(find.byType(VerticalStepProgress), findsOneWidget);
      // Verify one of the subtitles is rendered.
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('Should update widget when controller currentStep changes', (
      tester,
    ) async {
      final controller = StepProgressController(initialStep: 0, totalSteps: 5);

      int? changedStep;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepProgress(
              totalSteps: 5,
              controller: controller,
              onStepChanged: (newStep) {
                changedStep = newStep;
              },
            ),
          ),
        ),
      );

      // Update the controller currentStep
      controller.setCurrentStep(2);
      await tester.pumpAndSettle();

      // The onStepChanged callback should have been called with the new value.
      expect(changedStep, equals(2));
    });

    testWidgets(
      'Should call onStepNodeTapped when a step is tapped (if implemented)',
      (tester) async {
        // In this test we simulate a tap event and verify the callback.
        // This test assumes that the HorizontalStepProgress or
        // VerticalStepProgress widget wraps the step nodes with
        // a GestureDetector.
        int tappedIndex = -1;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                currentStep: 1,
                onStepNodeTapped: (index) {
                  tappedIndex = index;
                },
              ),
            ),
          ),
        );

        // Try to tap on a widget that would represent a step node.
        // Here we simply find a widget with text that we expect is inside the
        // step node.
        await tester.tap(find.byType(StepNode).first);
        await tester.pumpAndSettle();

        // Check that the tapped callback was triggered.
        expect(tappedIndex, isNot(-1));
      },
    );
  });

  group('StepProgress Widget - Negative and Boundary Cases', () {
    testWidgets(
      'Should not update or call onStepChanged when new step is same as'
      ' current step',
      (tester) async {
        int onStepChangedCalls = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 4,
                currentStep: 1,
                onStepChanged: (_) {
                  onStepChangedCalls++;
                },
              ),
            ),
          ),
        );

        // Since currentStep is provided via widget property and not via
        // controller in this case,
        // we simulate a new value equal to the current one. Because _changeStep
        // checks for equality,
        // onStepChanged will not be called.
        // Here we rebuild with the same currentStep.
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 4,
                currentStep: 1,
                onStepChanged: (_) {
                  onStepChangedCalls++;
                },
              ),
            ),
          ),
        );
        await tester.pump();

        expect(onStepChangedCalls, equals(0));
      },
    );

    testWidgets('Should not update when an out-of-range step is provided via'
        ' controller', (tester) async {
      final controller = StepProgressController(initialStep: 0, totalSteps: 3);
      int? changedStep;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepProgress(
              totalSteps: 3,
              controller: controller,
              onStepChanged: (newStep) {
                changedStep = newStep;
              },
            ),
          ),
        ),
      );

      // Attempt to update the controller with an out-of-range step value.
      // According to _changeStep, if newStep >= totalSteps the function should
      // return early.
      expect(
        () => controller.setCurrentStep(3),
        throwsAssertionError,
      ); // equal to totalSteps so invalid

      // Because the step is out-of-range, onStepChanged should not be called
      // and the internal state remains.
      expect(changedStep, isNull);

      // Also try a number lower -1.
      expect(() => controller.setCurrentStep(-2), throwsAssertionError);
      await tester.pump();

      expect(changedStep, isNull);
    });

    testWidgets(
      'Should throw an assertion error when totalSteps is less than or'
      ' equal to 0',
      (tester) async {
        // Since an assert is in place for totalSteps > 0,
        // we expect testing in debug mode to throw an AssertionError.
        expect(() => StepProgress(totalSteps: 0), throwsAssertionError);
      },
    );

    testWidgets(
      'Should throw an assertion error when currentStep is not lower than'
      ' totalSteps',
      (tester) async {
        // currentStep must be lower than totalSteps.
        expect(
          () => StepProgress(totalSteps: 3, currentStep: 3),
          throwsAssertionError,
        );
      },
    );

    testWidgets(
      'Should throw assertion error when provided titles list length is'
      ' greater than totalSteps',
      (tester) async {
        expect(
          () => StepProgress(
            totalSteps: 2,
            nodeTitles: const ['Step 1', 'Step 2', 'Step 3'],
          ),
          throwsAssertionError,
        );
      },
    );

    testWidgets(
      'Should throw assertion error when provided subTitles list length is'
      ' greater than totalSteps',
      (tester) async {
        expect(
          () =>
              StepProgress(totalSteps: 2, nodeSubTitles: const ['A', 'B', 'C']),
          throwsAssertionError,
        );
      },
    );
  });

  group('StepProgress Widget - Scalability and Performance', () {
    testWidgets('Should render correctly with a large number of steps', (
      tester,
    ) async {
      const int largeStepCount = 50;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StepProgress(
                totalSteps: largeStepCount,
                width: largeStepCount * 80,
                currentStep: 25,
                nodeTitles: List<String>.generate(
                  largeStepCount,
                  (index) => 'Step ${index + 1}',
                ),
              ),
            ),
          ),
        ),
      );

      // Check that the widget builds and at least one of the many steps
      // is found.
      expect(find.text('Step 26'), findsOneWidget);
    });
  });

  group('StepProgress Widget - Cross-platform/Compatibility', () {
    testWidgets('Should build without issues on different screen sizes', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 600,
                child: StepProgress(totalSteps: 5, currentStep: 2),
              ),
            ),
          ),
        ),
      );

      // Verify that the widget is rendered within the given screen constraints.
      expect(find.byType(StepProgress), findsOneWidget);
    });
  });
}
