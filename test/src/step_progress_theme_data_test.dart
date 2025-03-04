// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/step_progress.dart';

void main() {
  group('StepProgressThemeData', () {
    test('should have default values', () {
      const themeData = StepProgressThemeData();
      expect(
        themeData.defaultForegroundColor,
        equals(const Color.fromARGB(255, 191, 196, 195)),
      );
      expect(
        themeData.activeForegroundColor,
        equals(const Color.fromARGB(255, 0, 167, 160)),
      );
      expect(themeData.highlightCompletedSteps, isTrue);
      expect(themeData.borderColor, equals(Colors.white));
      expect(themeData.borderWidth, equals(0));
      expect(themeData.enableRippleEffect, isFalse);
      expect(themeData.shape, equals(StepNodeShape.circle));
      expect(
        themeData.stepAnimationDuration,
        equals(const Duration(milliseconds: 150)),
      );
      expect(themeData.stepLineSpacing, equals(0));
      expect(themeData.nodeLabelStyle, equals(const StepLabelStyle()));
      expect(themeData.stepNodeStyle, equals(const StepNodeStyle()));
      expect(themeData.stepLineStyle, equals(const StepLineStyle()));
      expect(themeData.rippleEffectStyle, equals(const RippleEffectStyle()));
      expect(themeData.nodeLabelAlignment, isNull);
    });

    test('copyWith returns a new instance with updated values', () {
      const original = StepProgressThemeData();
      final newTheme = original.copyWith(
        defaultForegroundColor: Colors.red,
        activeForegroundColor: Colors.blue,
        borderColor: Colors.green,
        activeBorderColor: Colors.yellow,
        borderWidth: 2,
        stepAnimationDuration: const Duration(seconds: 1),
        enableRippleEffect: true,
        shape: StepNodeShape.square,
        stepLineSpacing: 3,
        // Although we use the same styles, they are explicitly provided.
        nodeLabelStyle: const StepLabelStyle(),
        lineLabelStyle: const StepLabelStyle(),
        stepNodeStyle: const StepNodeStyle(),
        stepLineStyle: const StepLineStyle(),
        rippleEffectStyle: const RippleEffectStyle(),
        highlightCompletedSteps: false,
        nodeLabelAlignment: StepLabelAlignment.top,
      );

      expect(newTheme.defaultForegroundColor, equals(Colors.red));
      expect(newTheme.activeForegroundColor, equals(Colors.blue));
      expect(newTheme.borderColor, equals(Colors.green));
      expect(newTheme.activeBorderColor, equals(Colors.yellow));
      expect(newTheme.borderWidth, equals(2.0));
      expect(
        newTheme.stepAnimationDuration,
        equals(const Duration(seconds: 1)),
      );
      expect(newTheme.enableRippleEffect, isTrue);
      expect(newTheme.shape, equals(StepNodeShape.square));
      expect(newTheme.stepLineSpacing, equals(3.0));
      expect(newTheme.nodeLabelStyle, equals(const StepLabelStyle()));
      expect(newTheme.lineLabelStyle, equals(const StepLabelStyle()));
      expect(newTheme.stepNodeStyle, equals(const StepNodeStyle()));
      expect(newTheme.stepLineStyle, equals(const StepLineStyle()));
      expect(newTheme.rippleEffectStyle, equals(const RippleEffectStyle()));
      expect(newTheme.highlightCompletedSteps, isFalse);
      expect(newTheme.nodeLabelAlignment, equals(StepLabelAlignment.top));
    });

    test('copyWith with no parameters returns an identical instance', () {
      const original = StepProgressThemeData(
        defaultForegroundColor: Colors.red,
        activeForegroundColor: Colors.blue,
        borderColor: Colors.green,
        activeBorderColor: Colors.yellow,
        borderWidth: 2,
        stepAnimationDuration: Duration(seconds: 1),
        enableRippleEffect: true,
        shape: StepNodeShape.square,
        stepLineSpacing: 3,
        nodeLabelStyle: StepLabelStyle(),
        stepNodeStyle: StepNodeStyle(),
        stepLineStyle: StepLineStyle(),
        rippleEffectStyle: RippleEffectStyle(),
        highlightCompletedSteps: false,
        nodeLabelAlignment: StepLabelAlignment.top,
      );
      final newTheme = original.copyWith();

      // Compare field by field for equality since no operator== is defined.
      expect(
        newTheme.defaultForegroundColor,
        equals(original.defaultForegroundColor),
      );
      expect(
        newTheme.activeForegroundColor,
        equals(original.activeForegroundColor),
      );
      expect(newTheme.borderColor, equals(original.borderColor));
      expect(newTheme.activeBorderColor, equals(original.activeBorderColor));
      expect(newTheme.borderWidth, equals(original.borderWidth));
      expect(
        newTheme.stepAnimationDuration,
        equals(original.stepAnimationDuration),
      );
      expect(newTheme.enableRippleEffect, equals(original.enableRippleEffect));
      expect(newTheme.shape, equals(original.shape));
      expect(newTheme.stepLineSpacing, equals(original.stepLineSpacing));
      expect(newTheme.nodeLabelStyle, equals(original.nodeLabelStyle));
      expect(newTheme.stepNodeStyle, equals(original.stepNodeStyle));
      expect(newTheme.stepLineStyle, equals(original.stepLineStyle));
      expect(newTheme.rippleEffectStyle, equals(original.rippleEffectStyle));
      expect(
        newTheme.highlightCompletedSteps,
        equals(original.highlightCompletedSteps),
      );
      expect(newTheme.nodeLabelAlignment, equals(original.nodeLabelAlignment));
    });

    test('copyWith negative test: invalid values throws assertion error', () {
      const original = StepProgressThemeData();
      expect(() => original.copyWith(borderWidth: -5), throwsAssertionError);
    });

    test('Boundary test: setting duration to zero', () {
      const original = StepProgressThemeData();
      final newTheme = original.copyWith(stepAnimationDuration: Duration.zero);
      expect(newTheme.stepAnimationDuration, equals(Duration.zero));
    });

    test('Toggle ripple effect functionality', () {
      const themeWithoutRipple = StepProgressThemeData(
        enableRippleEffect: false,
      );
      expect(themeWithoutRipple.enableRippleEffect, isFalse);

      final themeWithRipple = themeWithoutRipple.copyWith(
        enableRippleEffect: true,
      );
      expect(themeWithRipple.enableRippleEffect, isTrue);
    });
  });
}
