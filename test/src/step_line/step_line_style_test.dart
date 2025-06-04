// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_line/step_line_style.dart';

void main() {
  group('StepLineStyle', () {
    test('Default constructor sets default values', () {
      const style = StepLineStyle();
      expect(
        style.lineThickness,
        equals(4),
        reason: 'The default line thickness should be 4',
      );
      expect(
        style.borderRadius,
        equals(Radius.zero),
        reason: 'Default borderRadius should be Radius.zero',
      );
      expect(
        style.foregroundColor,
        isNull,
        reason: 'Default foregroundColor should be null',
      );
      expect(
        style.activeColor,
        isNull,
        reason: 'Default activeColor should be null',
      );
      expect(
        style.animationDuration,
        isNull,
        reason: 'Default animationDuration should be null',
      );
    });

    test('Constructor sets provided non-default values', () {
      const foreground = Colors.red;
      const active = Colors.green;
      const duration = Duration(milliseconds: 300);
      const thickness = 6.0;
      const border = Radius.circular(8);

      const style = StepLineStyle(
        foregroundColor: foreground,
        activeColor: active,
        animationDuration: duration,
        lineThickness: thickness,
        borderRadius: border,
      );

      expect(style.foregroundColor, equals(foreground));
      expect(style.activeColor, equals(active));
      expect(style.animationDuration, equals(duration));
      expect(style.lineThickness, equals(thickness));
      expect(style.borderRadius, equals(border));
    });

    test(
        'copyWith returns a new instance with same values if no arguments'
        ' provided', () {
      const style = StepLineStyle(
        foregroundColor: Colors.blue,
        activeColor: Colors.yellow,
        animationDuration: Duration(seconds: 1),
        lineThickness: 10,
        borderRadius: Radius.circular(5),
      );

      final copiedStyle = style.copyWith();

      expect(
        copiedStyle.foregroundColor,
        equals(style.foregroundColor),
        reason: 'foregroundColor should remain unchanged',
      );
      expect(
        copiedStyle.activeColor,
        equals(style.activeColor),
        reason: 'activeColor should remain unchanged',
      );
      expect(
        copiedStyle.animationDuration,
        equals(style.animationDuration),
        reason: 'animationDuration should remain unchanged',
      );
      expect(
        copiedStyle.lineThickness,
        equals(style.lineThickness),
        reason: 'lineThickness should remain unchanged',
      );
      expect(
        copiedStyle.borderRadius,
        equals(style.borderRadius),
        reason: 'borderRadius should remain unchanged',
      );
    });

    test('copyWith correctly overrides provided values', () {
      const style = StepLineStyle(
        foregroundColor: Colors.blue,
        activeColor: Colors.yellow,
        animationDuration: Duration(seconds: 1),
        lineThickness: 10,
        borderRadius: Radius.circular(5),
      );

      const newForeground = Colors.purple;
      const newDuration = Duration(milliseconds: 500);
      const newThickness = 12.0;
      const newBorderRadius = Radius.circular(15);

      final copiedStyle = style.copyWith(
        foregroundColor: newForeground,
        animationDuration: newDuration,
        lineThickness: newThickness,
        borderRadius: newBorderRadius,
      );

      expect(
        copiedStyle.foregroundColor,
        equals(newForeground),
        reason: 'foregroundColor should be updated',
      );
      // activeColor was not provided in copyWith, so it should remain
      // unchanged.
      expect(
        copiedStyle.activeColor,
        equals(style.activeColor),
        reason: 'activeColor should remain unchanged',
      );
      expect(
        copiedStyle.animationDuration,
        equals(newDuration),
        reason: 'animationDuration should be updated',
      );
      expect(
        copiedStyle.lineThickness,
        equals(newThickness),
        reason: 'lineThickness should be updated',
      );
      expect(
        copiedStyle.borderRadius,
        equals(newBorderRadius),
        reason: 'borderRadius should be updated',
      );
    });

    test('copyWith throws assertion error with negative lineThickness', () {
      const style = StepLineStyle();
      expect(
        () => style.copyWith(lineThickness: -5),
        throwsAssertionError,
        reason: 'Negative line thickness is not allowed',
      );
    });

    test('copyWith with null parameters retains original non-null values', () {
      // This test checks that if a field is set in the original instance,
      // providing a null value explicitly in copyWith does not override it.
      const style = StepLineStyle(
        foregroundColor: Colors.orange,
        activeColor: Colors.green,
        animationDuration: Duration(seconds: 2),
        lineThickness: 8,
        borderRadius: Radius.circular(10),
      );

      // Passing null will trigger the fallback (null ?? original) which will
      // leave the original value intact.
      final copiedStyle = style.copyWith(
        foregroundColor: null,
        activeColor: null,
        animationDuration: null,
        lineThickness: null,
        borderRadius: null,
      );

      expect(
        copiedStyle.foregroundColor,
        equals(style.foregroundColor),
        reason: 'foregroundColor should remain unchanged',
      );
      expect(
        copiedStyle.activeColor,
        equals(style.activeColor),
        reason: 'activeColor should remain unchanged',
      );
      expect(
        copiedStyle.animationDuration,
        equals(style.animationDuration),
        reason: 'animationDuration should remain unchanged',
      );
      expect(
        copiedStyle.lineThickness,
        equals(style.lineThickness),
        reason: 'lineThickness should remain unchanged',
      );
      expect(
        copiedStyle.borderRadius,
        equals(style.borderRadius),
        reason: 'borderRadius should remain unchanged',
      );
    });

    test(
        'Default constructor sets correct default values for breadcrumb '
        'properties', () {
      const style = StepLineStyle();
      expect(
        style.isBreadcrumb,
        equals(false),
        reason: 'Default isBreadcrumb should be false',
      );
      expect(
        style.chevronAngle,
        equals(30),
        reason: 'Default chevronAngle should be 30',
      );
    });

    test('Constructor sets provided breadcrumb-related values', () {
      const isBreadcrumb = true;
      const chevronAngle = 45.0;

      const style = StepLineStyle(
        isBreadcrumb: isBreadcrumb,
        chevronAngle: chevronAngle,
      );

      expect(
        style.isBreadcrumb,
        equals(isBreadcrumb),
        reason: 'isBreadcrumb should match provided value',
      );
      expect(
        style.chevronAngle,
        equals(chevronAngle),
        reason: 'chevronAngle should match provided value',
      );
    });

    test('copyWith correctly handles breadcrumb-related properties', () {
      const style = StepLineStyle(isBreadcrumb: false, chevronAngle: 30);

      final copiedStyle = style.copyWith(isBreadcrumb: true, chevronAngle: 60);

      expect(
        copiedStyle.isBreadcrumb,
        equals(true),
        reason: 'isBreadcrumb should be updated',
      );
      expect(
        copiedStyle.chevronAngle,
        equals(60),
        reason: 'chevronAngle should be updated',
      );

      // Test that original values are preserved when not specified
      final partialCopy = style.copyWith(isBreadcrumb: true);
      expect(
        partialCopy.chevronAngle,
        equals(style.chevronAngle),
        reason: 'chevronAngle should remain unchanged when not specified',
      );
    });
  });
}
