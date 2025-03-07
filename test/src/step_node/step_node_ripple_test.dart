// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_node/ripple_effect_style.dart';
import 'package:step_progress/src/step_node/step_node_ripple.dart';
import 'package:step_progress/src/step_node/step_node_shape.dart';
import 'package:step_progress/src/step_node/step_node_shaped_container.dart';

import '../helper/test_theme_wrapper.dart';

void main() {
  group('StepNodeRipple widget tests', () {
    testWidgets('renders with isVisible true (opacity and scale are 1)', (
      tester,
    ) async {
      // Build widget with isVisible: true and a count of 1 so no recursion.
      await tester.pumpWidget(
        const TestThemeWrapper(
          child: StepNodeRipple(
            stepNodeShape: StepNodeShape.circle,
            width: 50,
            height: 50,
            isVisible: true,
            count: 1,
            style: RippleEffectStyle(), // using default style
          ),
        ),
      );

      // Find AnimatedOpacity widget and check its opacity property.
      final animatedOpacityFinder = find.byType(AnimatedOpacity);
      expect(animatedOpacityFinder, findsOneWidget);
      final AnimatedOpacity animatedOpacityWidget = tester.widget(
        animatedOpacityFinder,
      );
      expect(animatedOpacityWidget.opacity, equals(1));

      // Find AnimatedScale and verify its scale is 1.
      final animatedScaleFinder = find.byType(AnimatedScale);
      expect(animatedScaleFinder, findsOneWidget);
      final AnimatedScale animatedScaleWidget = tester.widget(
        animatedScaleFinder,
      );
      expect(animatedScaleWidget.scale, equals(1));

      // Because count == 1, ensure that the StepNodeShapedContainer
      // has no child.
      final shapedContainerFinder = find.byType(StepNodeShapedContainer);
      expect(shapedContainerFinder, findsOneWidget);
      final StepNodeShapedContainer containerWidget = tester.widget(
        shapedContainerFinder,
      );
      expect(containerWidget.child, isNull);
    });

    testWidgets('renders with isVisible false (opacity and scale are 0)', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestThemeWrapper(
          child: StepNodeRipple(
            stepNodeShape: StepNodeShape.circle,
            width: 50,
            height: 50,
            isVisible: false,
            count: 1,
            style: RippleEffectStyle(),
          ),
        ),
      );

      // Check AnimatedOpacity has 0 opacity.
      final animatedOpacityFinder = find.byType(AnimatedOpacity);
      final AnimatedOpacity animatedOpacityWidget = tester.widget(
        animatedOpacityFinder,
      );
      expect(animatedOpacityWidget.opacity, equals(0));

      // Check AnimatedScale has scale 0.
      final animatedScaleFinder = find.byType(AnimatedScale);
      final AnimatedScale animatedScaleWidget = tester.widget(
        animatedScaleFinder,
      );
      expect(animatedScaleWidget.scale, equals(0));
    });

    testWidgets('when count > 1, widget should include (count) nested '
        'StepNodeShapedContainer', (tester) async {
      // When count is greater than 1 the widget builds a nested StepNodeRipple.
      await tester.pumpWidget(
        const TestThemeWrapper(
          child: StepNodeRipple(
            stepNodeShape: StepNodeShape.circle,
            width: 60,
            height: 60,
            isVisible: true,
            count: 3,
            style: RippleEffectStyle(borderWidth: 2),
          ),
        ),
      );

      // There must be single instances of StepNodeRipple.
      expect(find.byType(StepNodeRipple), findsOneWidget);

      // There must be 3 (count) widget of type StepNodeShapedContainer
      expect(find.byType(StepNodeShapedContainer), findsNWidgets(3));

      // Verify that the sizes are reduced correctly in the nested widget.
      // Fetch the outer StepNodeShapedContainer decoration and compare
      // border values.
      final shapedContainerFinder = find.byType(StepNodeShapedContainer).first;
      final StepNodeShapedContainer outerContainer = tester.widget(
        shapedContainerFinder,
      );
      final BoxDecoration? outerDecoration = outerContainer.decoration;
      expect(outerDecoration, isNotNull);
      expect(outerDecoration!.border, isA<Border>());
    });

    testWidgets('custom animationDuration is used when provided in style', (
      tester,
    ) async {
      const customDuration = Duration(milliseconds: 500);
      await tester.pumpWidget(
        const TestThemeWrapper(
          child: StepNodeRipple(
            stepNodeShape: StepNodeShape.circle,
            width: 70,
            height: 70,
            isVisible: true,
            count: 1,
            style: RippleEffectStyle(
              animationDuration: customDuration,
              borderWidth: 1,
            ),
          ),
        ),
      );

      // Check the AnimatedOpacity widget's duration matches the customDuration.
      final animatedOpacityFinder = find.byType(AnimatedOpacity);
      final AnimatedOpacity animatedOpacityWidget = tester.widget(
        animatedOpacityFinder,
      );
      expect(animatedOpacityWidget.duration, equals(customDuration));

      // Similarly verify the AnimatedScale widget.
      final animatedScaleFinder = find.byType(AnimatedScale);
      final AnimatedScale animatedScaleWidget = tester.widget(
        animatedScaleFinder,
      );
      expect(animatedScaleWidget.duration, equals(customDuration));
    });

    testWidgets('Negative width and height must result crashing', (
      tester,
    ) async {
      await expectLater(() async {
        await tester.pumpWidget(
          TestThemeWrapper(
            child: StepNodeRipple(
              stepNodeShape: StepNodeShape.circle,
              width: -50,
              height: -50,
              isVisible: true,
              count: 1,
              style: const RippleEffectStyle(),
            ),
          ),
        );
      }, throwsA(isA<AssertionError>()));
    });

    testWidgets(
      'uses theme default animationDuration when style.animationDuration'
      ' is null',
      (tester) async {
        // Do not provide a custom animationDuration in style.
        await tester.pumpWidget(
          const TestThemeWrapper(
            child: StepNodeRipple(
              stepNodeShape: StepNodeShape.circle,
              width: 80,
              height: 80,
              isVisible: true,
              count: 1,
              style: RippleEffectStyle(), // animationDuration is null
            ),
          ),
        );

        // According to our TestThemeWrapper, the default is 200 milliseconds.
        const expectedDuration = Duration(milliseconds: 200);

        final animatedOpacityFinder = find.byType(AnimatedOpacity);
        final AnimatedOpacity animatedOpacityWidget = tester.widget(
          animatedOpacityFinder,
        );
        expect(animatedOpacityWidget.duration, equals(expectedDuration));

        final animatedScaleFinder = find.byType(AnimatedScale);
        final AnimatedScale animatedScaleWidget = tester.widget(
          animatedScaleFinder,
        );
        expect(animatedScaleWidget.duration, equals(expectedDuration));
      },
    );
  });
}
