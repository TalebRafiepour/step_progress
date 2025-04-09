import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_node/step_node.dart';
import 'package:step_progress/src/step_node/step_node_core.dart';
import 'package:step_progress/src/step_node/step_node_shaped_container.dart';
import 'package:step_progress/step_progress.dart';

import '../helper/test_theme_wrapper.dart';

void main() {
  group('StepNode Widget Tests', () {
    // Create a dummy style object for testing.
    const dummyStyle = StepNodeStyle(
      decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
      icon: Icon(Icons.circle, color: Colors.red),
      activeIcon: Icon(Icons.check, color: Colors.green),
      defaultForegroundColor: Colors.grey,
      activeForegroundColor: Colors.white,
      animationDuration: Duration(milliseconds: 150),
    );

    const dummyThemeData = StepProgressThemeData(
      stepNodeStyle: dummyStyle,
      borderStyle: OutterBorderStyle(
        defaultBorderColor: Colors.black,
        activeBorderColor: Colors.red,
      ),
      stepAnimationDuration: Duration(milliseconds: 200),
      defaultForegroundColor: Colors.grey,
      activeForegroundColor: Colors.white,
    );

    testWidgets('renders non-active StepNode correctly', (tester) async {
      // Build the widget.
      await tester.pumpWidget(
        const TestThemeWrapper(
          themeData: dummyThemeData,
          child: Scaffold(
            body: StepNode(width: 50, height: 50, label: 'Step 1'),
          ),
        ),
      );

      // Expect two StepNodeCore widgets are rendered.
      final stepNodes = find.byType(StepNodeCore);
      expect(stepNodes, findsNWidgets(2));

      // Check that the first StepNodeCore (non-active one) is visible.
      final coreWidgets = tester.widgetList<StepNodeCore>(stepNodes).toList();
      expect(coreWidgets.first.isVisible, equals(true));

      // The active one (second) should not be visible since isActive is false.
      expect(coreWidgets.last.isVisible, equals(false));
    });

    testWidgets('renders active StepNode correctly', (tester) async {
      await tester.pumpWidget(
        const TestThemeWrapper(
          themeData: dummyThemeData,
          child: Scaffold(
            body: StepNode(
              width: 60,
              height: 60,
              isActive: true,
              label: 'Step Active',
            ),
          ),
        ),
      );

      // Expect two StepNodeCore widgets in the widget tree.
      final stepNodes = find.byType(StepNodeCore);
      expect(stepNodes, findsNWidgets(2));

      final coreWidgets = tester.widgetList<StepNodeCore>(stepNodes).toList();
      // When active, the non-active (first) should be invisible.
      expect(coreWidgets.first.isVisible, equals(false));
      // The active (second) should be visible.
      expect(coreWidgets.last.isVisible, equals(true));
    });

    testWidgets('applies border decoration from theme when provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestThemeWrapper(
          themeData: dummyThemeData,
          child: Scaffold(
            body: StepNode(width: 70, height: 70, label: 'Test Border'),
          ),
        ),
      );

      // Find the shaped container widget where the border should be applied.
      final shapedContainerFinder = find.byType(StepNodeShapedContainer).first;
      expect(shapedContainerFinder, findsOneWidget);

      final shapedContainer = tester.widget<StepNodeShapedContainer>(
        shapedContainerFinder,
      );
      final decoration = shapedContainer.decoration!;

      // Verify that a border was added and its properties match.
      expect(decoration.border, isNotNull);
      expect(decoration.border!.top.width, equals(2.0));
      // Since isActive is false, it should use borderColor (black).
      expect(decoration.border!.top.color, equals(Colors.black));
    });

    testWidgets(
      'handles missing optional parameters gracefully (negative test)',
      (tester) async {
        // Test with minimal parameters, leaving out optional label and icons.
        await tester.pumpWidget(
          const TestThemeWrapper(
            themeData: dummyThemeData,
            child: Scaffold(body: StepNode(width: 80, height: 80)),
          ),
        );

        // Even though optional parameters are missing, the widget should render
        // two StepNodeCore widgets.
        expect(find.byType(StepNodeCore), findsNWidgets(2));
      },
    );

    testWidgets('renders with extreme width and height values (edge cases)', (
      tester,
    ) async {
      // Testing boundary conditions for dimensions.
      await tester.pumpWidget(
        const TestThemeWrapper(
          themeData: dummyThemeData,
          child: Scaffold(
            body: Column(
              children: [
                // Edge case: 0.0 width and height.
                StepNode(width: 0, height: 0),
                // Edge case: using very large values.
                Expanded(
                  child: StepNode(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    isActive: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Even though extreme values may cause layout issues in an actual app,
      // our test should at least verify that the StepNode widget
      // instances exist.
      expect(find.byType(StepNode), findsNWidgets(2));
    });
  });
}
