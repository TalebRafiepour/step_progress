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

    testWidgets(
        'Should not update when an out-of-range step is provided via'
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

  group('StepProgress Widget - Line Labels and Reversed Tests', () {
    testWidgets('Should render line titles correctly', (tester) async {
      const lineTitles = ['Line 1', 'Line 2', 'Line 3'];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepProgress(
              totalSteps: 4,
              currentStep: 1,
              lineTitles: lineTitles,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify each line title is rendered
      for (final title in lineTitles) {
        expect(find.text(title), findsOneWidget);
      }
    });

    testWidgets('Should render line subtitles correctly', (tester) async {
      const lineSubTitles = ['Sub 1', 'Sub 2', 'Sub 3'];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepProgress(
              totalSteps: 4,
              currentStep: 1,
              lineSubTitles: lineSubTitles,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify each line subtitle is rendered
      for (final subtitle in lineSubTitles) {
        expect(find.text(subtitle), findsOneWidget);
      }
    });

    testWidgets('Should use custom lineLabelBuilder correctly', (tester) async {
      int builderCallCount = 0;
      Widget? customLineLabel(int index, int currentStep) {
        builderCallCount++;
        return Container(
          key: Key('custom_line_$index'),
          child: Text('Custom Line $index'),
        );
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepProgress(
              totalSteps: 4,
              currentStep: 1,
              lineLabelBuilder: customLineLabel,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify custom labels are rendered
      for (var i = 0; i < 3; i++) {
        expect(find.byKey(Key('custom_line_$i')), findsOneWidget);
        expect(find.text('Custom Line $i'), findsOneWidget);
      }

      // Verify builder was called correct number of times (totalSteps - 1)
      expect(builderCallCount, equals(3));
    });

    testWidgets(
      'Should render elements in reverse order when reversed is true',
      (tester) async {
        const lineTitles = ['Line 1', 'Line 2', 'Line 3'];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 4,
                currentStep: 1,
                lineTitles: lineTitles,
                reversed: true,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Get all text widgets
        final textWidgets = tester
            .widgetList<Text>(find.byType(Text))
            .where((widget) => lineTitles.contains(widget.data))
            .toList();

        // Verify texts are in reverse order
        expect(textWidgets[0].data, equals('Line 3'));
        expect(textWidgets[1].data, equals('Line 2'));
        expect(textWidgets[2].data, equals('Line 1'));
      },
    );

    testWidgets('Should work with vertical axis when reversed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepProgress(
              totalSteps: 3,
              currentStep: 1,
              axis: Axis.vertical,
              reversed: true,
              lineTitles: const ['First', 'Second'],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify content is rendered
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);

      expect(find.byType(VerticalStepProgress), findsOneWidget);
    });

    testWidgets('Should work with horizontal axis when reversed', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepProgress(
              totalSteps: 3,
              currentStep: 1,
              axis: Axis.horizontal,
              reversed: true,
              lineTitles: const ['First', 'Second'],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify content is rendered
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);

      expect(find.byType(HorizontalStepProgress), findsOneWidget);
    });

    testWidgets('Should handle line titles and subtitles together', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepProgress(
              totalSteps: 3,
              currentStep: 1,
              lineTitles: const ['Title 1', 'Title 2'],
              lineSubTitles: const ['Sub 1', 'Sub 2'],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify both titles and subtitles are rendered
      expect(find.text('Title 1'), findsOneWidget);
      expect(find.text('Title 2'), findsOneWidget);
      expect(find.text('Sub 1'), findsOneWidget);
      expect(find.text('Sub 2'), findsOneWidget);
    });
  });

  group('StepProgress nodeLabelBuilder tests', () {
    testWidgets('nodeLabelBuilder should render custom widgets for each node', (
      tester,
    ) async {
      const key1 = Key('node_label_0');
      const key2 = Key('node_label_1');
      const key3 = Key('node_label_2');

      await tester.pumpWidget(
        MaterialApp(
          home: StepProgress(
            totalSteps: 3,
            currentStep: 1,
            nodeLabelBuilder: (index, completedStepIndex) {
              return Container(
                key: Key('node_label_$index'),
                child: Text(
                  'Custom Label $index',
                  style: const TextStyle(fontSize: 14),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byKey(key1), findsOneWidget);
      expect(find.byKey(key2), findsOneWidget);
      expect(find.byKey(key3), findsOneWidget);
      expect(find.text('Custom Label 0'), findsOneWidget);
      expect(find.text('Custom Label 1'), findsOneWidget);
      expect(find.text('Custom Label 2'), findsOneWidget);
    });

    testWidgets('nodeLabelBuilder receives correct parameters', (tester) async {
      final List<int> receivedIndices = [];
      final List<int> receivedCompletedSteps = [];

      await tester.pumpWidget(
        MaterialApp(
          home: StepProgress(
            totalSteps: 3,
            currentStep: 1,
            nodeLabelBuilder: (index, completedStepIndex) {
              receivedIndices.add(index);
              receivedCompletedSteps.add(completedStepIndex);
              return Text('Label $index');
            },
          ),
        ),
      );

      expect(receivedIndices, [0, 1, 2]);
      expect(receivedCompletedSteps, [1, 1, 1]);
    });

    testWidgets('nodeLabelBuilder works with reversed order', (tester) async {
      final List<String> labels = [];

      await tester.pumpWidget(
        MaterialApp(
          home: StepProgress(
            totalSteps: 3,
            currentStep: 1,
            reversed: true,
            nodeLabelBuilder: (index, completedStepIndex) {
              final widget = Text('Label $index');
              labels.add('Label $index');
              return widget;
            },
          ),
        ),
      );

      // Even though builder is called in normal order
      expect(labels, ['Label 0', 'Label 1', 'Label 2']);

      // Labels should appear in reversed order in the widget tree
      final labelFinders = find.byType(Text);
      final labelWidgets = tester.widgetList<Text>(labelFinders);
      expect(labelWidgets.map((text) => text.data).toList(), [
        'Label 2',
        'Label 1',
        'Label 0',
      ]);
    });

    testWidgets('nodeLabelBuilder can return null for specific nodes', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StepProgress(
            totalSteps: 3,
            currentStep: 1,
            nodeLabelBuilder: (index, completedStepIndex) {
              // Only build label for middle node
              return index == 1 ? const Text('Middle Node') : null;
            },
          ),
        ),
      );

      expect(find.text('Middle Node'), findsOneWidget);
      expect(
        find.byType(Text),
        findsOneWidget,
      ); // Only one text widget should exist
    });
  });
}
