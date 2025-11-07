// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_line/step_line.dart';
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

  group('StepProgress Widget - hasEqualNodeAndLineCount Tests', () {
    testWidgets(
      'Should render equal number of nodes and lines when '
      'hasEqualNodeAndLineCount is true with nodeThenLine',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 4,
                currentStep: 1,
                hasEqualNodeAndLineCount: true,
                visibilityOptions: StepProgressVisibilityOptions.nodeThenLine,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // When hasEqualNodeAndLineCount is true, both nodes and lines should
        // equal totalSteps
        expect(find.byType(StepNode), findsNWidgets(4));
        expect(find.byType(StepLine), findsNWidgets(4));
      },
    );

    testWidgets(
      'Should render equal number of nodes and lines when '
      'hasEqualNodeAndLineCount is true with lineThenNode',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                currentStep: 0,
                hasEqualNodeAndLineCount: true,
                visibilityOptions: StepProgressVisibilityOptions.lineThenNode,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // When hasEqualNodeAndLineCount is true, both nodes and lines should
        // equal totalSteps
        expect(find.byType(StepNode), findsNWidgets(3));
        expect(find.byType(StepLine), findsNWidgets(3));
      },
    );

    testWidgets(
      'Should work with horizontal axis when hasEqualNodeAndLineCount is true',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 5,
                currentStep: 2,
                hasEqualNodeAndLineCount: true,
                axis: Axis.horizontal,
                visibilityOptions: StepProgressVisibilityOptions.nodeThenLine,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(HorizontalStepProgress), findsOneWidget);
        expect(find.byType(StepNode), findsNWidgets(5));
        expect(find.byType(StepLine), findsNWidgets(5));
      },
    );

    testWidgets(
      'Should work with vertical axis when hasEqualNodeAndLineCount is true',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 4,
                currentStep: 1,
                hasEqualNodeAndLineCount: true,
                axis: Axis.vertical,
                visibilityOptions: StepProgressVisibilityOptions.lineThenNode,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(VerticalStepProgress), findsOneWidget);
        expect(find.byType(StepNode), findsNWidgets(4));
        expect(find.byType(StepLine), findsNWidgets(4));
      },
    );

    testWidgets(
      'Should render node titles correctly when hasEqualNodeAndLineCount true',
      (tester) async {
        const nodeTitles = ['Node 1', 'Node 2', 'Node 3'];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                currentStep: 1,
                hasEqualNodeAndLineCount: true,
                nodeTitles: nodeTitles,
                visibilityOptions: StepProgressVisibilityOptions.nodeThenLine,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify each node title is rendered
        for (final title in nodeTitles) {
          expect(find.text(title), findsOneWidget);
        }

        expect(find.byType(StepNode), findsNWidgets(3));
        expect(find.byType(StepLine), findsNWidgets(3));
      },
    );

    testWidgets(
      'Should render line titles correctly when hasEqualNodeAndLineCount true',
      (tester) async {
        const lineTitles = ['Line 1', 'Line 2', 'Line 3'];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                currentStep: 1,
                hasEqualNodeAndLineCount: true,
                lineTitles: lineTitles,
                visibilityOptions: StepProgressVisibilityOptions.lineThenNode,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify each line title is rendered
        for (final title in lineTitles) {
          expect(find.text(title), findsOneWidget);
        }

        expect(find.byType(StepNode), findsNWidgets(3));
        expect(find.byType(StepLine), findsNWidgets(3));
      },
    );

    testWidgets(
      'Should work with both node and line titles when '
      'hasEqualNodeAndLineCount is true',
      (tester) async {
        const nodeTitles = ['Node A', 'Node B', 'Node C', 'Node D'];
        const lineTitles = ['Line X', 'Line Y', 'Line Z', 'Line W'];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 4,
                currentStep: 2,
                hasEqualNodeAndLineCount: true,
                nodeTitles: nodeTitles,
                lineTitles: lineTitles,
                visibilityOptions: StepProgressVisibilityOptions.nodeThenLine,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify both node and line titles are rendered
        for (final nodeTitle in nodeTitles) {
          expect(find.text(nodeTitle), findsOneWidget);
        }
        for (final lineTitle in lineTitles) {
          expect(find.text(lineTitle), findsOneWidget);
        }

        expect(find.byType(StepNode), findsNWidgets(4));
        expect(find.byType(StepLine), findsNWidgets(4));
      },
    );

    testWidgets(
      'Should work with nodeSubTitles and lineSubTitles when '
      'hasEqualNodeAndLineCount is true',
      (tester) async {
        const nodeSubTitles = ['Sub A', 'Sub B', 'Sub C'];
        const lineSubTitles = ['Line Sub 1', 'Line Sub 2', 'Line Sub 3'];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                currentStep: 1,
                hasEqualNodeAndLineCount: true,
                nodeSubTitles: nodeSubTitles,
                lineSubTitles: lineSubTitles,
                visibilityOptions: StepProgressVisibilityOptions.lineThenNode,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify both node and line subtitles are rendered
        for (final nodeSubTitle in nodeSubTitles) {
          expect(find.text(nodeSubTitle), findsOneWidget);
        }
        for (final lineSubTitle in lineSubTitles) {
          expect(find.text(lineSubTitle), findsOneWidget);
        }

        expect(find.byType(StepNode), findsNWidgets(3));
        expect(find.byType(StepLine), findsNWidgets(3));
      },
    );

    testWidgets(
      'Should work with custom nodeLabelBuilder when '
      'hasEqualNodeAndLineCount is true',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                currentStep: 1,
                hasEqualNodeAndLineCount: true,
                nodeLabelBuilder: (index, completedStepIndex) {
                  return Container(
                    key: Key('custom_node_$index'),
                    child: Text('Custom Node $index'),
                  );
                },
                visibilityOptions: StepProgressVisibilityOptions.nodeThenLine,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify custom node labels are rendered
        for (var i = 0; i < 3; i++) {
          expect(find.byKey(Key('custom_node_$i')), findsOneWidget);
          expect(find.text('Custom Node $i'), findsOneWidget);
        }

        expect(find.byType(StepNode), findsNWidgets(3));
        expect(find.byType(StepLine), findsNWidgets(3));
      },
    );

    testWidgets(
      'Should work with custom lineLabelBuilder when '
      'hasEqualNodeAndLineCount is true',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 4,
                currentStep: 2,
                hasEqualNodeAndLineCount: true,
                lineLabelBuilder: (index, completedStepIndex) {
                  return Container(
                    key: Key('custom_line_$index'),
                    child: Text('Custom Line $index'),
                  );
                },
                visibilityOptions: StepProgressVisibilityOptions.lineThenNode,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify custom line labels are rendered
        for (var i = 0; i < 4; i++) {
          expect(find.byKey(Key('custom_line_$i')), findsOneWidget);
          expect(find.text('Custom Line $i'), findsOneWidget);
        }

        expect(find.byType(StepNode), findsNWidgets(4));
        expect(find.byType(StepLine), findsNWidgets(4));
      },
    );

    testWidgets(
      'Should work with reversed order when hasEqualNodeAndLineCount is true',
      (tester) async {
        const nodeTitles = ['First', 'Second', 'Third'];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                currentStep: 1,
                hasEqualNodeAndLineCount: true,
                reversed: true,
                nodeTitles: nodeTitles,
                visibilityOptions: StepProgressVisibilityOptions.nodeThenLine,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify content is rendered
        for (final title in nodeTitles) {
          expect(find.text(title), findsOneWidget);
        }

        expect(find.byType(StepNode), findsNWidgets(3));
        expect(find.byType(StepLine), findsNWidgets(3));
      },
    );

    testWidgets(
      'Should handle nodeOnly visibility option when '
      'hasEqualNodeAndLineCount is true',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 4,
                currentStep: 2,
                hasEqualNodeAndLineCount: true,
                visibilityOptions: StepProgressVisibilityOptions.nodeOnly,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // When visibility is nodeOnly, should render nodes but not lines
        expect(find.byType(StepNode), findsNWidgets(4));
        expect(find.byType(StepLine), findsNothing);
      },
    );

    testWidgets(
      'Should handle lineOnly visibility option when '
      'hasEqualNodeAndLineCount is true',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 5,
                currentStep: 3,
                hasEqualNodeAndLineCount: true,
                visibilityOptions: StepProgressVisibilityOptions.lineOnly,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // When visibility is lineOnly, should render lines but not nodes
        expect(find.byType(StepLine), findsNWidgets(5));
        expect(find.byType(StepNode), findsNothing);
      },
    );

    testWidgets(
      'Should work with controller when hasEqualNodeAndLineCount is true',
      (tester) async {
        final controller =
            StepProgressController(initialStep: 0, totalSteps: 3);
        int? changedStep;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                controller: controller,
                hasEqualNodeAndLineCount: true,
                onStepChanged: (newStep) {
                  changedStep = newStep;
                },
                visibilityOptions: StepProgressVisibilityOptions.nodeThenLine,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Update the controller currentStep
        controller.setCurrentStep(2);
        await tester.pumpAndSettle();

        // The onStepChanged callback should have been called with the new value
        expect(changedStep, equals(2));
        expect(find.byType(StepNode), findsNWidgets(3));
        expect(find.byType(StepLine), findsNWidgets(3));
      },
    );

    testWidgets(
      'Should work with step tapping when hasEqualNodeAndLineCount is true',
      (tester) async {
        int tappedNodeIndex = -1;
        int tappedLineIndex = -1;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 4,
                currentStep: 1,
                hasEqualNodeAndLineCount: true,
                onStepNodeTapped: (index) {
                  tappedNodeIndex = index;
                },
                onStepLineTapped: (index) {
                  tappedLineIndex = index;
                },
                visibilityOptions: StepProgressVisibilityOptions.nodeThenLine,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Try to tap on a step node
        await tester.tap(find.byType(StepNode).first);
        await tester.pumpAndSettle();
        expect(tappedNodeIndex, isNot(-1));

        // Try to tap on a step line
        await tester.tap(find.byType(StepLine).first);
        await tester.pumpAndSettle();
        expect(tappedLineIndex, isNot(-1));

        expect(find.byType(StepNode), findsNWidgets(4));
        expect(find.byType(StepLine), findsNWidgets(4));
      },
    );

    testWidgets(
      'Should work with autoStartProgress when hasEqualNodeAndLineCount true',
      (tester) async {
        int? changedStep;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 4,
                currentStep: 0,
                hasEqualNodeAndLineCount: true,
                autoStartProgress: true,
                onStepChanged: (step) {
                  changedStep = step;
                },
                visibilityOptions: StepProgressVisibilityOptions.lineThenNode,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should auto-advance to end of steps (3)
        expect(changedStep, equals(3));
        expect(find.byType(StepNode), findsNWidgets(4));
        expect(find.byType(StepLine), findsNWidgets(4));
      },
    );

    testWidgets(
      'Should handle large number of steps when hasEqualNodeAndLineCount true',
      (tester) async {
        const int largeStepCount = 10;
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StepProgress(
                  totalSteps: largeStepCount,
                  currentStep: 5,
                  width: largeStepCount * 60,
                  hasEqualNodeAndLineCount: true,
                  visibilityOptions: StepProgressVisibilityOptions.nodeThenLine,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should render equal numbers of nodes and lines
        expect(find.byType(StepNode), findsNWidgets(largeStepCount));
        expect(find.byType(StepLine), findsNWidgets(largeStepCount));
      },
    );

    testWidgets(
      'Should maintain state consistency when switching visibility options '
      'with hasEqualNodeAndLineCount true',
      (tester) async {
        Widget buildStepProgress(StepProgressVisibilityOptions visibility) {
          return MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                currentStep: 1,
                hasEqualNodeAndLineCount: true,
                visibilityOptions: visibility,
              ),
            ),
          );
        }

        // Test nodeThenLine
        await tester.pumpWidget(
          buildStepProgress(StepProgressVisibilityOptions.nodeThenLine),
        );
        await tester.pumpAndSettle();
        expect(find.byType(StepNode), findsNWidgets(3));
        expect(find.byType(StepLine), findsNWidgets(3));

        // Switch to lineThenNode
        await tester.pumpWidget(
          buildStepProgress(StepProgressVisibilityOptions.lineThenNode),
        );
        await tester.pumpAndSettle();
        expect(find.byType(StepNode), findsNWidgets(3));
        expect(find.byType(StepLine), findsNWidgets(3));

        // Switch to nodeOnly
        await tester.pumpWidget(
          buildStepProgress(StepProgressVisibilityOptions.nodeOnly),
        );
        await tester.pumpAndSettle();
        expect(find.byType(StepNode), findsNWidgets(3));
        expect(find.byType(StepLine), findsNothing);

        // Switch to lineOnly
        await tester.pumpWidget(
          buildStepProgress(StepProgressVisibilityOptions.lineOnly),
        );
        await tester.pumpAndSettle();
        expect(find.byType(StepLine), findsNWidgets(3));
        expect(find.byType(StepNode), findsNothing);
      },
    );
  });

  group(
    'StepProgress autoStartProgress',
    () {
      testWidgets('Should rebuild when autoStartProgress is true',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                currentStep: 0,
                autoStartProgress: true,
              ),
            ),
          ),
        );

        // After pump, the widget should auto-advance to step 1
        await tester.pumpAndSettle();
        expect(find.byType(StepNode), findsNWidgets(3));
      });

      testWidgets('Should not auto-advance if autoStartProgress is false',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                currentStep: 0,
                autoStartProgress: false,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        // The currentStep should remain at 0
        expect(find.byType(StepNode), findsNWidgets(3));
        // Optionally, check that the first node is still the active one
        // (implementation detail may vary)
      });

      testWidgets(
          'Should auto-advance only once when autoStartProgress is true',
          (tester) async {
        int stepChangedCount = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                currentStep: 0,
                autoStartProgress: true,
                onStepChanged: (_) {
                  stepChangedCount++;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(stepChangedCount, equals(1));
      });

      testWidgets('Should not auto-advance if currentStep is last step',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                currentStep: 2,
                autoStartProgress: true,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        // Should not advance beyond last step
        expect(find.byType(StepNode), findsNWidgets(3));
      });

      testWidgets('Should auto-advance to next step if not last step',
          (tester) async {
        int? changedStep;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                currentStep: 1,
                autoStartProgress: true,
                onStepChanged: (step) {
                  changedStep = step;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(changedStep, equals(2));
      });

      testWidgets('Should auto-advance with reversed order', (tester) async {
        int? changedStep;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepProgress(
                totalSteps: 3,
                currentStep: -1,
                autoStartProgress: true,
                reversed: true,
                onStepChanged: (step) {
                  // in auto start progress, the first step is 1
                  changedStep =
                      step; // the second step triggrered and must be 2
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(changedStep, equals(2));
      });

      testWidgets(
        'Should increament step whether autoStartProgress is true and '
        'previouse step is bigger than current step',
        (tester) async {
          int? changedStep;
          // Start at step 2, previous step is 3, so isForward will be false''
          // (2 < 3)
          final controller =
              StepProgressController(initialStep: 2, totalSteps: 4)
                ..prevStep = 3; // Simulate previous step higher than current

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: StepProgress(
                  totalSteps: 4,
                  controller: controller,
                  autoStartProgress: true,
                  onStepChanged: (step) {
                    changedStep = step;
                  },
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Should increament current step atuomaticly (0,1,^2, -> 3)
          expect(changedStep, equals(3));
        },
      );
    },
  );
}
