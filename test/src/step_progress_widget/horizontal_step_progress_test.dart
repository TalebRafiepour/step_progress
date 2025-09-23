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
    testWidgets(
        'buildStepNodes produces the correct number of StepGenerator'
        ' widgets with highlightCompletedSteps true', (tester) async {
      // Set up parameters.
      const int totalSteps = 5;
      const int currentStep = 2;
      const double stepSize = 50;
      const visibilityOptions = StepProgressVisibilityOptions.nodeThenLine;
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
              totalSteps: totalSteps,
              currentStep: currentStep,
              stepSize: stepSize,
              visibilityOptions: visibilityOptions,
              nodeTitles: nodeTitles,
              nodeSubTitles: nodeSubTitles,
              needsRebuildWidget: () {},
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
        final StepGenerator widget =
            tester.widgetList<StepGenerator>(stepGeneratorFinder).elementAt(i);
        if (i <= currentStep) {
          expect(
            widget.highlighted,
            isTrue,
            reason: 'Step $i should be active when highlightCompletedSteps is '
                'enabled.',
          );
        } else {
          expect(
            widget.highlighted,
            isFalse,
            reason:
                'Step $i should be inactive when highlightCompletedSteps is '
                'enabled.',
          );
        }
      }
    });

    testWidgets(
        'buildStepNodes produces the correct active state when '
        'highlightCompletedSteps is false', (tester) async {
      // Set up parameters.
      const int totalSteps = 4;
      const int currentStep = 1;
      const double stepSize = 40;
      const visibilityOptions = StepProgressVisibilityOptions.nodeThenLine;

      await tester.pumpWidget(
        TestThemeWrapper(
          themeData: const StepProgressThemeData(),
          child: Scaffold(
            // Here we pass null for titles and subtitles to simulate
            // missing data.
            body: HorizontalStepProgress(
              totalSteps: totalSteps,
              currentStep: currentStep,
              stepSize: stepSize,
              visibilityOptions: visibilityOptions,
              highlightOptions:
                  StepProgressHighlightOptions.highlightCurrentNodeAndLine,
              needsRebuildWidget: () {},
            ),
          ),
        ),
      );

      final stepGeneratorFinder = find.byType(StepGenerator);
      expect(stepGeneratorFinder, findsNWidgets(totalSteps));

      // With StepProgressHighlightOptions.highlightCurrentLine,
      // only the current step line should be highlighted.
      for (var i = 0; i < totalSteps; i++) {
        final StepGenerator widget =
            tester.widgetList<StepGenerator>(stepGeneratorFinder).elementAt(i);
        if (i == currentStep) {
          expect(
            widget.highlighted,
            isTrue,
            reason: 'Only the current step should be highlighted when '
                'highlightOptions is '
                'StepProgressHighlightOptions.highlightCurrentLine.',
          );
        } else {
          expect(
            widget.highlighted,
            isFalse,
            reason: 'Step $i should be inactive when highlightOptions '
                'is StepProgressHighlightOptions.highlightCurrentLine.',
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
      const visibilityOptions = StepProgressVisibilityOptions.nodeThenLine;
      int tappedIndex = -1;

      await tester.pumpWidget(
        TestThemeWrapper(
          child: Scaffold(
            body: HorizontalStepProgress(
              totalSteps: totalSteps,
              currentStep: currentStep,
              stepSize: stepSize,
              visibilityOptions: visibilityOptions,
              onStepNodeTapped: (index) {
                tappedIndex = index;
              },
              needsRebuildWidget: () {},
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
        reason: 'Tapping step node at index 1 should trigger the callback with '
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
        const visibilityOptions = StepProgressVisibilityOptions.nodeThenLine;

        await tester.pumpWidget(
          TestThemeWrapper(
            child: Scaffold(
              body: HorizontalStepProgress(
                totalSteps: totalSteps,
                currentStep: currentStep,
                stepSize: stepSize,
                visibilityOptions: visibilityOptions,
                // No need to specify titles/subtitles for line testing.
                onStepLineTapped: (_) {},
                needsRebuildWidget: () {},
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
              widget.highlighted,
              isTrue,
              reason: 'StepLine at index $i should be active when'
                  ' i < currentStep.',
            );
          } else {
            expect(
              widget.highlighted,
              isFalse,
              reason: 'StepLine at index $i should be inactive when'
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
      const visibilityOptions = StepProgressVisibilityOptions.nodeThenLine;
      int tappedLineIndex = -1;

      await tester.pumpWidget(
        TestThemeWrapper(
          child: Scaffold(
            body: HorizontalStepProgress(
              totalSteps: totalSteps,
              currentStep: currentStep,
              stepSize: stepSize,
              visibilityOptions: visibilityOptions,
              onStepLineTapped: (index) {
                tappedLineIndex = index;
              },
              needsRebuildWidget: () {},
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
        reason: 'Tapping the first step line should trigger the callback with '
            'index 0.',
      );
    });

    testWidgets('Edge case: totalStep equals 1 produces no StepLine widgets', (
      tester,
    ) async {
      const int totalSteps = 1;
      const int currentStep = 0;
      const double stepSize = 40;
      const visibilityOptions = StepProgressVisibilityOptions.nodeThenLine;

      await tester.pumpWidget(
        TestThemeWrapper(
          child: Scaffold(
            body: HorizontalStepProgress(
              totalSteps: totalSteps,
              currentStep: currentStep,
              stepSize: stepSize,
              visibilityOptions: visibilityOptions,
              needsRebuildWidget: () {},
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
      const visibilityOptions = StepProgressVisibilityOptions.nodeThenLine;

      await tester.pumpWidget(
        TestThemeWrapper(
          child: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: HorizontalStepProgress(
                totalSteps: totalSteps,
                currentStep: currentStep,
                stepSize: stepSize,
                visibilityOptions: visibilityOptions,
                needsRebuildWidget: () {},
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

    testWidgets('HorizontalStepProgress renders line titles correctly', (
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
                body: HorizontalStepProgress(
                  totalSteps: totalSteps,
                  currentStep: currentStep,
                  stepSize: 50,
                  visibilityOptions: StepProgressVisibilityOptions.nodeThenLine,
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

    testWidgets('HorizontalStepProgress renders line subtitles correctly', (
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
                body: HorizontalStepProgress(
                  totalSteps: totalSteps,
                  currentStep: currentStep,
                  stepSize: 50,
                  visibilityOptions: StepProgressVisibilityOptions.nodeThenLine,
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

    testWidgets(
      'HorizontalStepProgress uses custom lineLabelBuilder correctly',
      (tester) async {
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
                  body: HorizontalStepProgress(
                    totalSteps: totalSteps,
                    currentStep: currentStep,
                    stepSize: 50,
                    visibilityOptions:
                        StepProgressVisibilityOptions.nodeThenLine,
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
      },
    );

    testWidgets(
      'HorizontalStepProgress renders line labels with different alignments',
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
                    body: HorizontalStepProgress(
                      totalSteps: totalSteps,
                      currentStep: currentStep,
                      stepSize: 50,
                      visibilityOptions:
                          StepProgressVisibilityOptions.nodeThenLine,
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

        // Test with top alignment
        await buildWithAlignment(Alignment.topCenter);
        expect(find.byType(Column), findsWidgets);

        // Test with bottom alignment
        await buildWithAlignment(Alignment.bottomCenter);
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
      'onStepLineAnimationCompleted callback is triggered for each StepLine',
      (tester) async {
        const int totalSteps = 4;
        const int currentStep = 2;
        const double stepSize = 50;
        const visibilityOptions = StepProgressVisibilityOptions.nodeThenLine;
        final List<int> completedIndices = [];

        await tester.pumpWidget(
          TestThemeWrapper(
            child: Scaffold(
              body: HorizontalStepProgress(
                totalSteps: totalSteps,
                currentStep: currentStep,
                stepSize: stepSize,
                visibilityOptions: visibilityOptions,
                onStepLineAnimationCompleted: ({index = 0}) {
                  completedIndices.add(index);
                },
                needsRebuildWidget: () {},
              ),
            ),
          ),
        );

        // Simulate triggering the animation completed callback for
        // each StepLine.
        final stepLineFinder = find.byType(StepLine);
        final stepLineWidgets =
            tester.widgetList<StepLine>(stepLineFinder).toList();

        for (var i = 0; i < stepLineWidgets.length; i++) {
          // Directly call the callback as StepLine does not animate in tests.
          stepLineWidgets[i].onStepLineAnimationCompleted?.call();
        }

        // The callback should be called for each line with correct index.
        expect(completedIndices.length, equals(totalSteps - 1));
        expect(completedIndices, containsAll([1, 2, 3]));
      },
    );

    testWidgets(
      'onStepLineAnimationCompleted is not called if not provided',
      (tester) async {
        const int totalSteps = 3;
        const int currentStep = 1;
        const double stepSize = 40;
        const visibilityOptions = StepProgressVisibilityOptions.nodeThenLine;

        await tester.pumpWidget(
          TestThemeWrapper(
            child: Scaffold(
              body: HorizontalStepProgress(
                totalSteps: totalSteps,
                currentStep: currentStep,
                stepSize: stepSize,
                visibilityOptions: visibilityOptions,
                needsRebuildWidget: () {},
              ),
            ),
          ),
        );

        final stepLineFinder = find.byType(StepLine);
        final stepLineWidgets =
            tester.widgetList<StepLine>(stepLineFinder).toList();

        for (var i = 0; i < stepLineWidgets.length; i++) {
          // Should not throw if callback is null.
          expect(() => stepLineWidgets[i].onStepLineAnimationCompleted?.call(),
              returnsNormally);
        }
      },
    );

    testWidgets(
      'onStepLineAnimationCompleted receives correct index for reversed'
      ' HorizontalStepProgress',
      (tester) async {
        const int totalSteps = 4;
        const int currentStep = 2;
        const double stepSize = 50;
        const visibilityOptions = StepProgressVisibilityOptions.nodeThenLine;
        final List<int> completedIndices = [];

        await tester.pumpWidget(
          TestThemeWrapper(
            child: Scaffold(
              body: HorizontalStepProgress(
                totalSteps: totalSteps,
                currentStep: currentStep,
                stepSize: stepSize,
                visibilityOptions: visibilityOptions,
                reversed: true,
                onStepLineAnimationCompleted: ({index = 0}) {
                  completedIndices.add(index);
                },
                needsRebuildWidget: () {},
              ),
            ),
          ),
        );

        final stepLineFinder = find.byType(StepLine);
        final stepLineWidgets =
            tester.widgetList<StepLine>(stepLineFinder).toList();

        for (var i = 0; i < stepLineWidgets.length; i++) {
          stepLineWidgets[i].onStepLineAnimationCompleted?.call();
        }

        // Indices should still be [1, 2, 3] even when reversed.
        expect(completedIndices.length, equals(totalSteps - 1));
        expect(completedIndices, containsAll([1, 2, 3]));
      },
    );

    testWidgets(
      'HorizontalStepProgress with showLineThenNode renders lines before nodes',
      (tester) async {
        const int totalSteps = 4;
        const int currentStep = 2;
        const double stepSize = 40;
        const visibilityOptions = StepProgressVisibilityOptions.lineThenNode;

        await tester.pumpWidget(
          TestThemeWrapper(
            child: Scaffold(
              body: HorizontalStepProgress(
                totalSteps: totalSteps,
                currentStep: currentStep,
                stepSize: stepSize,
                visibilityOptions: visibilityOptions,
                needsRebuildWidget: () {},
              ),
            ),
          ),
        );

        // There should be totalSteps StepLine widgets and totalSteps-1
        // StepGenerator widgets
        final stepLineFinder = find.byType(StepLine);
        final stepGeneratorFinder = find.byType(StepGenerator);

        expect(stepLineFinder, findsNWidgets(totalSteps));
        expect(stepGeneratorFinder, findsNWidgets(totalSteps - 1));

        // Check that the first widget is a StepLine (lines come before nodes)
        final allWidgets = tester
            .widgetList(find.descendant(
              of: find.byType(HorizontalStepProgress),
              matching: find.byWidgetPredicate(
                  (widget) => widget is StepLine || widget is StepGenerator),
            ))
            .toList();

        // The first widget should be a StepLine
        expect(allWidgets.first, isA<StepLine>());
        // The last widget should be a StepGenerator
        expect(allWidgets.last, isA<StepGenerator>());
      },
    );

    testWidgets(
      'HorizontalStepProgress with showLineThenNode triggers onStepLineTapped',
      (tester) async {
        const int totalSteps = 3;
        const int currentStep = 1;
        const double stepSize = 40;
        const visibilityOptions = StepProgressVisibilityOptions.lineThenNode;
        int tappedLineIndex = -1;

        await tester.pumpWidget(
          TestThemeWrapper(
            child: Scaffold(
              body: HorizontalStepProgress(
                totalSteps: totalSteps,
                currentStep: currentStep,
                stepSize: stepSize,
                visibilityOptions: visibilityOptions,
                onStepLineTapped: (index) {
                  tappedLineIndex = index;
                },
                needsRebuildWidget: () {},
              ),
            ),
          ),
        );

        // Tap the first StepLine
        final stepLineFinder = find.byType(StepLine).first;
        await tester.tap(stepLineFinder);
        await tester.pumpAndSettle();

        expect(tappedLineIndex, equals(0));
      },
    );

    testWidgets(
      'HorizontalStepProgress with showLineThenNode triggers onStepNodeTapped',
      (tester) async {
        const int totalSteps = 3;
        const int currentStep = 1;
        const double stepSize = 40;
        const visibilityOptions = StepProgressVisibilityOptions.lineThenNode;
        int tappedNodeIndex = -1;

        await tester.pumpWidget(
          TestThemeWrapper(
            child: Scaffold(
              body: HorizontalStepProgress(
                totalSteps: totalSteps,
                currentStep: currentStep,
                stepSize: stepSize,
                visibilityOptions: visibilityOptions,
                onStepNodeTapped: (index) {
                  tappedNodeIndex = index;
                },
                needsRebuildWidget: () {},
              ),
            ),
          ),
        );

        // Tap the first StepGenerator (node)
        final stepGeneratorFinder = find.byType(StepGenerator).first;
        await tester.tap(stepGeneratorFinder);
        await tester.pumpAndSettle();

        expect(tappedNodeIndex, equals(0));
      },
    );

    testWidgets(
      'HorizontalStepProgress renders node titles and subtitles correctly',
      (tester) async {
        const int totalSteps = 3;
        const int currentStep = 1;
        const double stepSize = 40;
        const visibilityOptions = StepProgressVisibilityOptions.nodeThenLine;

        final nodeTitles = ['Title 1', 'Title 2', 'Title 3'];
        final nodeSubTitles = ['Sub 1', 'Sub 2', 'Sub 3'];

        await tester.pumpWidget(
          TestThemeWrapper(
            child: Scaffold(
              body: HorizontalStepProgress(
                totalSteps: totalSteps,
                currentStep: currentStep,
                stepSize: stepSize,
                visibilityOptions: visibilityOptions,
                nodeTitles: nodeTitles,
                nodeSubTitles: nodeSubTitles,
                needsRebuildWidget: () {},
              ),
            ),
          ),
        );

        // Verify each node title is rendered
        for (final title in nodeTitles) {
          expect(find.text(title), findsOneWidget);
        }

        // Verify each node subtitle is rendered
        for (final subtitle in nodeSubTitles) {
          expect(find.text(subtitle), findsOneWidget);
        }
      },
    );

    testWidgets(
      'HorizontalStepProgress with StepProgressVisibilityOptions.lineOnly '
      'renders only step lines',
      (tester) async {
        const int totalSteps = 4;
        const int currentStep = 2;
        const double stepSize = 40;
        const visibilityOptions = StepProgressVisibilityOptions.lineOnly;

        await tester.pumpWidget(
          TestThemeWrapper(
            child: Scaffold(
              body: HorizontalStepProgress(
                totalSteps: totalSteps,
                currentStep: currentStep,
                stepSize: stepSize,
                visibilityOptions: visibilityOptions,
                nodeTitles: const ['A', 'B', 'C', 'D'],
                nodeSubTitles: const ['a', 'b', 'c', 'd'],
                needsRebuildWidget: () {},
              ),
            ),
          ),
        );

        // Should render only step lines, no step nodes.
        final stepLineFinder = find.byType(StepLine);
        final stepGeneratorFinder = find.byType(StepGenerator);

        expect(stepLineFinder, findsNWidgets(totalSteps));
        expect(stepGeneratorFinder, findsNothing);

        // Node titles and subtitles should not be rendered.
        for (final title in ['A', 'B', 'C', 'D']) {
          expect(find.text(title), findsNothing);
        }
        for (final subtitle in ['a', 'b', 'c', 'd']) {
          expect(find.text(subtitle), findsNothing);
        }
      },
    );
  });
}
