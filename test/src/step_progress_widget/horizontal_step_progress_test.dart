// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_line/step_line.dart';
import 'package:step_progress/src/step_progress_widgets/horizontal_step_progress.dart';
import 'package:step_progress/src/step_progress_widgets/step_generator.dart';
import 'package:step_progress/step_progress.dart';

import '../helper/test_theme_wrapper.dart';

void main() {
  group('HorizontalStepProgress Widget Tests', () {
    testWidgets('buildStepNodes produces the correct number of StepGenerator'
        ' widgets with highlightCompletedSteps true', (tester) async {
      // Set up parameters.
      const int totalSteps = 5;
      const int currentStep = 2;
      const double stepSize = 50;
      const visibilityOptions = StepProgressVisibilityOptions.both;
      // Optional titles and subtitles.
      final nodeTitles = List.generate(totalSteps, (index) => 'Title $index');
      final nodeSubTitles = List.generate(
        totalSteps,
        (index) => 'SubTitle $index',
      );

      // Build the widget.
      await tester.pumpWidget(
        TestThemeWrapper(
          child: Scaffold(
            body: HorizontalStepProgress(
              totalStep: totalSteps,
              currentStep: currentStep,
              stepSize: stepSize,
              visibilityOptions: visibilityOptions,
              nodeTitles: nodeTitles,
              nodeSubTitles: nodeSubTitles,
              needsRebuildWidget: () {
                tester.pumpAndSettle();
              },
            ),
          ),
        ),
      );

      // Expect that we have totalSteps of StepGenerator.
      final stepGeneratorFinder = find.byType(StepGenerator);
      expect(stepGeneratorFinder, findsNWidgets(totalSteps));

      // Verify active status of each StepGenerator.
      // When highlightCompletedSteps is true, nodes at index <= currentStep
      // should be active.
      for (var i = 0; i < totalSteps; i++) {
        final StepGenerator widget = tester
            .widgetList<StepGenerator>(stepGeneratorFinder)
            .elementAt(i);
        if (i <= currentStep) {
          expect(
            widget.isActive,
            isTrue,
            reason:
                'Step $i should be active when highlightCompletedSteps is '
                'enabled.',
          );
        } else {
          expect(
            widget.isActive,
            isFalse,
            reason:
                'Step $i should be inactive when highlightCompletedSteps is '
                'enabled.',
          );
        }
      }
    });

    testWidgets('buildStepNodes produces the correct active state when '
        'highlightCompletedSteps is false', (tester) async {
      // Set up parameters.
      const int totalSteps = 4;
      const int currentStep = 1;
      const double stepSize = 40;
      const visibilityOptions = StepProgressVisibilityOptions.both;

      await tester.pumpWidget(
        TestThemeWrapper(
          themeData: const StepProgressThemeData(
            highlightCompletedSteps: false,
          ),
          child: Scaffold(
            // Here we pass null for titles and subtitles to simulate
            // missing data.
            body: HorizontalStepProgress(
              totalStep: totalSteps,
              currentStep: currentStep,
              stepSize: stepSize,
              visibilityOptions: visibilityOptions,
              needsRebuildWidget: () {
                tester.pumpAndSettle();
              },
            ),
          ),
        ),
      );

      final stepGeneratorFinder = find.byType(StepGenerator);
      expect(stepGeneratorFinder, findsNWidgets(totalSteps));

      // With highlightCompletedSteps false, only the current step should
      // be active.
      for (var i = 0; i < totalSteps; i++) {
        final StepGenerator widget = tester
            .widgetList<StepGenerator>(stepGeneratorFinder)
            .elementAt(i);
        if (i == currentStep) {
          expect(
            widget.isActive,
            isTrue,
            reason:
                'Only the current step should be active when '
                'highlightCompletedSteps is false.',
          );
        } else {
          expect(
            widget.isActive,
            isFalse,
            reason:
                'Step $i should be inactive when highlightCompletedSteps '
                'is false.',
          );
        }
      }
    });

    testWidgets('Tapping a step node triggers the onStepNodeTapped callback', (
      tester,
    ) async {
      // Set up parameters.
      const int totalSteps = 3;
      const int currentStep = 0;
      const double stepSize = 30;
      const visibilityOptions = StepProgressVisibilityOptions.both;
      int tappedIndex = -1;

      await tester.pumpWidget(
        TestThemeWrapper(
          child: Scaffold(
            body: HorizontalStepProgress(
              totalStep: totalSteps,
              currentStep: currentStep,
              stepSize: stepSize,
              visibilityOptions: visibilityOptions,
              onStepNodeTapped: (index) {
                tappedIndex = index;
              },
              needsRebuildWidget: () {
                tester.pumpAndSettle();
              },
            ),
          ),
        ),
      );

      // Trigger a tap on the second step node.
      final stepGeneratorFinder = find.byType(StepGenerator).at(1);
      await tester.tap(stepGeneratorFinder);
      await tester.pumpAndSettle();

      expect(
        tappedIndex,
        equals(1),
        reason:
            'Tapping step node at index 1 should trigger the callback with '
            'index 1.',
      );
    });

    testWidgets(
      'buildStepLines produces the correct number of StepLine widgets and '
      'active status',
      (tester) async {
        // Set up parameters.
        const int totalSteps = 4;
        const int currentStep = 2;
        const double stepSize = 50;
        const visibilityOptions = StepProgressVisibilityOptions.both;

        await tester.pumpWidget(
          TestThemeWrapper(
            themeData: const StepProgressThemeData(
              highlightCompletedSteps: true,
            ),
            child: Scaffold(
              body: HorizontalStepProgress(
                totalStep: totalSteps,
                currentStep: currentStep,
                stepSize: stepSize,
                visibilityOptions: visibilityOptions,
                // No need to specify titles/subtitles for line testing.
                onStepLineTapped: (_) {},
                needsRebuildWidget: () {
                  tester.pumpAndSettle();
                },
              ),
            ),
          ),
        );

        // There should be totalSteps-1 StepLine widgets
        final stepLineFinder = find.byType(StepLine);
        expect(stepLineFinder, findsNWidgets(totalSteps - 1));

        // Verify the active state of each line.
        // When highlightCompletedSteps is true, active if index < currentStep.
        final stepLineWidgets =
            tester.widgetList<StepLine>(stepLineFinder).toList();
        for (var i = 0; i < stepLineWidgets.length; i++) {
          final widget = stepLineWidgets[i];
          if (i < currentStep) {
            expect(
              widget.isActive,
              isTrue,
              reason:
                  'StepLine at index $i should be active when'
                  ' i < currentStep.',
            );
          } else {
            expect(
              widget.isActive,
              isFalse,
              reason:
                  'StepLine at index $i should be inactive when'
                  ' i >= currentStep.',
            );
          }
        }
      },
    );

    testWidgets('Tapping a step line triggers the onStepLineTapped callback', (
      tester,
    ) async {
      // Set up parameters.
      const int totalSteps = 5;
      const int currentStep = 3;
      const double stepSize = 50;
      const visibilityOptions = StepProgressVisibilityOptions.both;
      int tappedLineIndex = -1;

      await tester.pumpWidget(
        TestThemeWrapper(
          child: Scaffold(
            body: HorizontalStepProgress(
              totalStep: totalSteps,
              currentStep: currentStep,
              stepSize: stepSize,
              visibilityOptions: visibilityOptions,
              onStepLineTapped: (index) {
                tappedLineIndex = index;
              },
              needsRebuildWidget: () {
                tester.pumpAndSettle();
              },
            ),
          ),
        ),
      );

      // Find the first StepLine widget and tap it.
      final stepLineFinder = find.byType(StepLine).first;
      await tester.tap(stepLineFinder);
      await tester.pumpAndSettle();

      expect(
        tappedLineIndex,
        equals(0),
        reason:
            'Tapping the first step line should trigger the callback with '
            'index 0.',
      );
    });

    testWidgets('Edge case: totalStep equals 1 produces no StepLine widgets', (
      tester,
    ) async {
      const int totalSteps = 1;
      const int currentStep = 0;
      const double stepSize = 40;
      const visibilityOptions = StepProgressVisibilityOptions.both;

      await tester.pumpWidget(
        TestThemeWrapper(
          child: Scaffold(
            body: HorizontalStepProgress(
              totalStep: totalSteps,
              currentStep: currentStep,
              stepSize: stepSize,
              visibilityOptions: visibilityOptions,
              needsRebuildWidget: () {
                tester.pumpAndSettle();
              },
            ),
          ),
        ),
      );

      // With only one step, there should be no StepLine widgets.
      final stepLineFinder = find.byType(StepLine);
      expect(
        stepLineFinder,
        findsNothing,
        reason: 'With only one step, there should be no step lines.',
      );
    });

    // Performance and scalability test can be done by building a large number
    // of steps.
    testWidgets('Scalability test: building many steps', (tester) async {
      // Using a large number to test performance.
      const int totalSteps = 100;
      const int currentStep = 50;
      const double stepSize = 20;
      const visibilityOptions = StepProgressVisibilityOptions.both;

      await tester.pumpWidget(
        TestThemeWrapper(
          child: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: HorizontalStepProgress(
                totalStep: totalSteps,
                currentStep: currentStep,
                stepSize: stepSize,
                visibilityOptions: visibilityOptions,
                needsRebuildWidget: () {
                  tester.pumpAndSettle();
                },
              ),
            ),
          ),
        ),
      );

      // Verify that the number of StepGenerator widgets equals the total steps.
      final stepGeneratorFinder = find.byType(StepGenerator);
      expect(stepGeneratorFinder, findsNWidgets(totalSteps));

      // Verify that the number of StepLine widgets equals totalSteps - 1.
      final stepLineFinder = find.byType(StepLine);
      expect(stepLineFinder, findsNWidgets(totalSteps - 1));
    });
  });
}
