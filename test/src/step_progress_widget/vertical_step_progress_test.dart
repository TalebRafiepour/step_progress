import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_line/step_line.dart';
import 'package:step_progress/src/step_progress_theme_data.dart';
import 'package:step_progress/src/step_progress_visibility_options.dart';
import 'package:step_progress/src/step_progress_widgets/step_generator.dart';
import 'package:step_progress/src/step_progress_widgets/vertical_step_progress.dart';

import '../helper/test_theme_wrapper.dart';

void main() {
  group('VerticalStepProgress Widget Tests', () {
    testWidgets(
      'Positive test: renders correct number of step nodes and step lines',
      (tester) async {
        // A simple callback trackers.
        int tappedNodeIndex = -1;
        int tappedLineIndex = -1;

        // Instantiate the widget with totalStep = 5 and currentStep = 2.
        final widget = TestThemeWrapper(
          child: Scaffold(
            body: VerticalStepProgress(
              totalSteps: 5,
              currentStep: 1,
              stepSize: 30,
              visibilityOptions: StepProgressVisibilityOptions.both,
              nodeTitles: const [
                'Step 1',
                'Step 2',
                'Step 3',
                'Step 4',
                'Step 5',
              ],
              nodeSubTitles: const [
                'Description 1',
                'Description 2',
                'Description 3',
                'Description 4',
                'Description 5',
              ],
              onStepNodeTapped: (step) {
                tappedNodeIndex = step;
              },
              onStepLineTapped: (step) {
                tappedLineIndex = step;
              },
              nodeIconBuilder: (step, completedStepIndex) {
                return Icon(Icons.circle, key: Key('node_$step'));
              },
              needsRebuildWidget: () {},
            ),
          ),
        );

        await tester.pumpWidget(widget);

        // Verify that there are exactly 5 StepGenerators rendered as
        // step nodes.
        final stepNodes = find.byType(StepGenerator);
        expect(stepNodes, findsNWidgets(5));

        // Verify that there are exactly 4 step lines rendered.
        final stepLines = find.byType(StepLine);
        expect(stepLines, findsNWidgets(4));

        // Simulate tapping on the third step node.
        // Note: Since the node icons are built via the builder, we locate one
        // by its key.
        // make sure tapped node is not active, because key is provided from
        // inactive nodes
        await tester.tap(find.byKey(const Key('node_2')));
        await tester.pumpAndSettle();

        expect(tappedNodeIndex, 2);

        // Simulate tapping on the second step line.
        // Keys/identifiers are not added to the step lines, so we use find.byType with an index.
        // To simulate a tap on the second line, we use tester.widgetList.
        final stepLineWidgets = tester.widgetList<StepLine>(stepLines).toList();
        expect(stepLineWidgets.length, equals(4));
        // We assume the onTap callback is attached. Tap the second one.
        await tester.tap(find.byWidget(stepLineWidgets[1]));
        await tester.pumpAndSettle();

        expect(tappedLineIndex, 1);
      },
    );

    testWidgets('Negative test: Handles currentStep out of bounds gracefully', (
      tester,
    ) async {
      // When currentStep is out of the expected bound (negative), the widget
      // may still build but all nodes should be inactive.
      final widget = TestThemeWrapper(
        child: Scaffold(
          body: VerticalStepProgress(
            totalSteps: 5,
            currentStep: -1,
            stepSize: 30,
            visibilityOptions: StepProgressVisibilityOptions.both,
            nodeTitles: List.generate(5, (index) => 'Step ${index + 1}'),
            nodeSubTitles: List.generate(
              5,
              (index) => 'Description ${index + 1}',
            ),
            onStepNodeTapped: (_) {},
            onStepLineTapped: (_) {},
            nodeIconBuilder: (step, completedStepIndex) {
              if (step <= completedStepIndex) {
                return Icon(Icons.check_circle, key: Key('active_node_$step'));
              } else {
                return Icon(Icons.circle, key: Key('node_$step'));
              }
            },
            needsRebuildWidget: () {},
          ),
        ),
      );

      await tester.pumpWidget(widget);

      // Verify that there are exactly 5 StepGenerators rendered.
      final stepNodes = find.byType(StepGenerator);
      expect(stepNodes, findsNWidgets(5));

      // Since currentStep is negative, none should be active.
      // We check by accessing the StepGenerator’s isActive design if possible.
      // Alternatively, if active icons are only shown for active steps, verify
      // they are missing.
      for (int i = 0; i < 5; i++) {
        // Expect that no active icon is found for any step.
        expect(find.byKey(Key('active_node_$i')), findsNothing);
      }
    });

    testWidgets('Test highlightCompletedSteps behavior', (tester) async {
      // When highlightCompletedSteps equals true, active nodes are all at
      // indices <= currentStep.
      const int totalSteps = 4;
      const int currentStep = 2;
      final widget = TestThemeWrapper(
        child: Scaffold(
          body: VerticalStepProgress(
            totalSteps: totalSteps,
            currentStep: currentStep,
            stepSize: 30,
            visibilityOptions: StepProgressVisibilityOptions.both,
            nodeTitles: List.generate(
              totalSteps,
              (index) => 'Step ${index + 1}',
            ),
            nodeSubTitles: List.generate(
              totalSteps,
              (index) => 'Desc ${index + 1}',
            ),
            onStepNodeTapped: (_) {},
            onStepLineTapped: (_) {},
            nodeIconBuilder: (step, completedStepIndex) {
              if (step <= completedStepIndex) {
                return Icon(Icons.check_circle, key: Key('active_node_$step'));
              } else {
                return Icon(Icons.circle, key: Key('node_$step'));
              }
            },
            needsRebuildWidget: () {},
          ),
        ),
      );

      await tester.pumpWidget(widget);

      // We expect that for a highlightCompletedSteps scenario, active icon is
      // shown for step indices
      // 0, 1 and 2 (if highlightCompletedSteps is true internally). Because our
      // implementation uses:
      // isActive = index <= currentStep.
      // We check for the existence of the active icon for appropriate indices.
      for (int i = 0; i < totalSteps; i++) {
        final activeIconFinder = find.byKey(Key('active_node_$i'));
        if (i <= currentStep) {
          expect(activeIconFinder, findsOneWidget);
        } else {
          expect(activeIconFinder, findsNothing);
        }
      }
    });

    testWidgets('Test buildStepLines with highlightCompletedSteps false', (
      tester,
    ) async {
      // In this scenario, only the step line immediately preceding the current
      // step should be active.
      // currentStep = 3 => only the step line for index 2 should be active.
      int tappedLineIndex = -1;
      final widget = TestThemeWrapper(
        child: Scaffold(
          body: VerticalStepProgress(
            totalSteps: 5,
            currentStep: 3,
            stepSize: 40,
            visibilityOptions: StepProgressVisibilityOptions.both,
            nodeTitles: List.generate(5, (index) => 'Step ${index + 1}'),
            nodeSubTitles: List.generate(5, (index) => 'Detail ${index + 1}'),
            onStepNodeTapped: (_) {},
            onStepLineTapped: (step) {
              tappedLineIndex = step;
            },
            nodeIconBuilder: (step, completedStepIndex) {
              if (step <= completedStepIndex) {
                return Icon(Icons.check_circle, key: Key('active_node_$step'));
              } else {
                return Icon(Icons.circle, key: Key('node_$step'));
              }
            },
            needsRebuildWidget: () {},
          ),
        ),
      );

      await tester.pumpWidget(widget);

      // Verify that there are 4 step lines.
      final stepLines = find.byType(StepLine);
      expect(stepLines, findsNWidgets(4));

      // Tap on the step line with index 2 (the active one, by specification
      // when highlightCompletedSteps is false).
      final stepLineWidgets = tester.widgetList<StepLine>(stepLines).toList();
      expect(stepLineWidgets.length, 4);
      await tester.tap(find.byWidget(stepLineWidgets[2]));
      await tester.pumpAndSettle();

      expect(tappedLineIndex, 2);
    });

    testWidgets('Negative test: titles and subTitles length mismatch', (
      tester,
    ) async {
      // In this case, we supply fewer titles than total steps.
      // The widget should not crash and should treat unavailable title/subtitle as null.
      final widget = TestThemeWrapper(
        child: Scaffold(
          body: VerticalStepProgress(
            totalSteps: 4,
            currentStep: 1,
            stepSize: 30,
            visibilityOptions: StepProgressVisibilityOptions.both,
            nodeTitles: const [
              'Only Title 1',
              'Only Title 2',
            ], // fewer titles than steps
            nodeSubTitles: const ['SubTitle 1'], // fewer subtitles than steps
            onStepNodeTapped: (_) {},
            onStepLineTapped: (_) {},
            nodeIconBuilder: (step, completedStepIndex) {
              if (step <= completedStepIndex) {
                return Icon(Icons.check_circle, key: Key('active_node_$step'));
              } else {
                return Icon(Icons.circle, key: Key('node_$step'));
              }
            },
            needsRebuildWidget: () {},
          ),
        ),
      );

      await tester.pumpWidget(widget);

      // Check that 4 StepGenerator widgets are rendered.
      final stepNodes = find.byType(StepGenerator);
      expect(stepNodes, findsNWidgets(4));

      // Attempt to find text that should have been provided in titles.
      // Steps with no title should simply not display any text.
      expect(find.text('Only Title 1'), findsOneWidget);
      expect(find.text('Only Title 2'), findsOneWidget);

      // Titles at indices 2 and 3 should be null; since the underlying
      // implementation
      // is not displaying any default text for null titles, we simply verify
      // that there is no extra text.
      expect(find.text('null'), findsNothing);
    });

    testWidgets('VerticalStepProgress renders line titles correctly', (
      tester,
    ) async {
      const totalSteps = 3;
      const currentStep = 1;
      final lineTitles = List.generate(
        totalSteps - 1,
        (index) => 'Line Title $index',
      );

      await tester.pumpWidget(
        TestThemeWrapper(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: VerticalStepProgress(
                  totalSteps: totalSteps,
                  currentStep: currentStep,
                  stepSize: 50,
                  visibilityOptions: StepProgressVisibilityOptions.both,
                  lineTitles: lineTitles,
                  needsRebuildWidget: () {
                    setState(() {});
                  },
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify each line title is rendered
      for (final title in lineTitles) {
        expect(find.text(title), findsOneWidget);
      }
    });

    testWidgets('VerticalStepProgress renders line subtitles correctly', (
      tester,
    ) async {
      const totalSteps = 3;
      const currentStep = 1;
      final lineSubTitles = List.generate(
        totalSteps - 1,
        (index) => 'Line SubTitle $index',
      );

      await tester.pumpWidget(
        TestThemeWrapper(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: VerticalStepProgress(
                  totalSteps: totalSteps,
                  currentStep: currentStep,
                  stepSize: 50,
                  visibilityOptions: StepProgressVisibilityOptions.both,
                  lineSubTitles: lineSubTitles,
                  needsRebuildWidget: () {
                    setState(() {});
                  },
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify each line subtitle is rendered
      for (final subtitle in lineSubTitles) {
        expect(find.text(subtitle), findsOneWidget);
      }
    });

    testWidgets('VerticalStepProgress uses custom lineLabelBuilder correctly', (
      tester,
    ) async {
      const totalSteps = 3;
      const currentStep = 1;

      Widget customLineLabel(int index, int currentStep) {
        return Container(
          key: Key('custom_line_label_$index'),
          child: Text('Custom Label $index'),
        );
      }

      await tester.pumpWidget(
        TestThemeWrapper(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: VerticalStepProgress(
                  totalSteps: totalSteps,
                  currentStep: currentStep,
                  stepSize: 50,
                  visibilityOptions: StepProgressVisibilityOptions.both,
                  lineLabelBuilder: customLineLabel,
                  needsRebuildWidget: () {
                    setState(() {});
                  },
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify custom labels are rendered
      for (var i = 0; i < totalSteps - 1; i++) {
        expect(find.byKey(Key('custom_line_label_$i')), findsOneWidget);
        expect(find.text('Custom Label $i'), findsOneWidget);
      }
    });

    testWidgets(
      'VerticalStepProgress renders line labels with different alignments',
      (tester) async {
        const totalSteps = 3;
        const currentStep = 1;
        final lineTitles = List.generate(
          totalSteps - 1,
          (index) => 'Line $index',
        );

        Future<void> buildWithAlignment(Alignment alignment) async {
          await tester.pumpWidget(
            TestThemeWrapper(
              themeData: StepProgressThemeData(lineLabelAlignment: alignment),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Scaffold(
                    body: VerticalStepProgress(
                      totalSteps: totalSteps,
                      currentStep: currentStep,
                      stepSize: 50,
                      visibilityOptions: StepProgressVisibilityOptions.both,
                      lineTitles: lineTitles,
                      needsRebuildWidget: () {
                        setState(() {});
                      },
                    ),
                  );
                },
              ),
            ),
          );
          await tester.pumpAndSettle();
        }

        // Test with left alignment
        await buildWithAlignment(Alignment.centerLeft);
        expect(find.byType(Column), findsWidgets);

        // Test with right alignment
        await buildWithAlignment(Alignment.centerRight);
        expect(find.byType(Column), findsWidgets);

        // Test with center alignment
        await buildWithAlignment(Alignment.center);
        expect(find.byType(Column), findsWidgets);

        // Verify labels are still visible with each alignment
        for (final title in lineTitles) {
          expect(find.text(title), findsOneWidget);
        }
      },
    );
    testWidgets(
        'VerticalStepProgress calls onStepLineAnimationCompleted for '
        'correct index', (tester) async {
      int? completedLineIndex;
      final widget = TestThemeWrapper(
        child: Scaffold(
          body: VerticalStepProgress(
            totalSteps: 4,
            currentStep: 2,
            stepSize: 30,
            visibilityOptions: StepProgressVisibilityOptions.both,
            nodeTitles: List.generate(4, (i) => 'Step ${i + 1}'),
            nodeSubTitles: List.generate(4, (i) => 'Desc ${i + 1}'),
            onStepNodeTapped: (_) {},
            onStepLineTapped: (_) {},
            nodeIconBuilder: (step, completedStepIndex) {
              return Icon(Icons.circle, key: Key('node_$step'));
            },
            onStepLineAnimationCompleted: ({index = 0}) {
              completedLineIndex = index;
            },
            needsRebuildWidget: () {},
          ),
        ),
      );

      await tester.pumpWidget(widget);

      // Find all StepLine widgets
      final stepLines = find.byType(StepLine);
      final stepLineWidgets = tester.widgetList<StepLine>(stepLines).toList();

      // Simulate animation completion by calling the callback manually
      // (since StepLine is a custom widget, we assume it calls the callback
      // when built) We'll trigger the callback for index 1 and verify
      (stepLineWidgets[1].onStepLineAnimationCompleted ?? () {})();

      expect(completedLineIndex, 2); // index passed to callback is index+1

      // Also test for another index
      (stepLineWidgets[0].onStepLineAnimationCompleted ?? () {})();
      expect(completedLineIndex, 1);
    });

    testWidgets(
        'VerticalStepProgress does not call onStepLineAnimationCompleted if not'
        ' provided', (tester) async {
      final widget = TestThemeWrapper(
        child: Scaffold(
          body: VerticalStepProgress(
            totalSteps: 3,
            currentStep: 1,
            stepSize: 30,
            visibilityOptions: StepProgressVisibilityOptions.both,
            nodeTitles: List.generate(3, (i) => 'Step ${i + 1}'),
            nodeSubTitles: List.generate(3, (i) => 'Desc ${i + 1}'),
            onStepNodeTapped: (_) {},
            onStepLineTapped: (_) {},
            nodeIconBuilder: (step, completedStepIndex) {
              return Icon(Icons.circle, key: Key('node_$step'));
            },
            needsRebuildWidget: () {},
          ),
        ),
      );

      await tester.pumpWidget(widget);

      // Find all StepLine widgets
      final stepLines = find.byType(StepLine);
      final stepLineWidgets = tester.widgetList<StepLine>(stepLines).toList();

      // Should not throw if callback is not provided
      expect(() {
        (stepLineWidgets[0].onStepLineAnimationCompleted ?? () {})();
      }, returnsNormally);
    });

    testWidgets(
        'VerticalStepProgress onStepLineAnimationCompleted is called for'
        ' each line', (tester) async {
      final calledIndices = <int>[];
      final widget = TestThemeWrapper(
        child: Scaffold(
          body: VerticalStepProgress(
            totalSteps: 5,
            currentStep: 4,
            stepSize: 30,
            visibilityOptions: StepProgressVisibilityOptions.both,
            nodeTitles: List.generate(5, (i) => 'Step ${i + 1}'),
            nodeSubTitles: List.generate(5, (i) => 'Desc ${i + 1}'),
            onStepNodeTapped: (_) {},
            onStepLineTapped: (_) {},
            nodeIconBuilder: (step, completedStepIndex) {
              return Icon(Icons.circle, key: Key('node_$step'));
            },
            onStepLineAnimationCompleted: ({index = 0}) {
              calledIndices.add(index);
            },
            needsRebuildWidget: () {},
          ),
        ),
      );

      await tester.pumpWidget(widget);

      final stepLines = find.byType(StepLine);
      final stepLineWidgets = tester.widgetList<StepLine>(stepLines).toList();

      // Simulate animation completion for all lines
      for (var i = 0; i < stepLineWidgets.length; i++) {
        (stepLineWidgets[i].onStepLineAnimationCompleted ?? () {})();
      }

      expect(calledIndices, equals([1, 2, 3, 4]));
    });
  });
}
