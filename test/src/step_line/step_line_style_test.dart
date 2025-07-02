// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/outer_border_style.dart';
import 'package:step_progress/src/step_line/step_line_style.dart';

void main() {
  group('StepLineStyle', () {
    test('Default constructor sets default values', () {
      const style = StepLineStyle();
      expect(style.lineThickness, equals(4));
      expect(style.borderRadius, equals(Radius.zero));
      expect(style.foregroundColor, isNull);
      expect(style.activeColor, isNull);
      expect(style.animationDuration, isNull);
      expect(style.isBreadcrumb, isFalse);
      expect(style.chevronAngle, equals(30));
      expect(style.borderStyle, isNull);
    });

    test('Constructor sets provided non-default values', () {
      const style = StepLineStyle(
        foregroundColor: Colors.red,
        activeColor: Colors.green,
        animationDuration: Duration(milliseconds: 300),
        lineThickness: 6,
        borderRadius: Radius.circular(8),
        isBreadcrumb: true,
        chevronAngle: 45,
        borderStyle: OuterBorderStyle(isDotted: true),
      );
      expect(style.foregroundColor, equals(Colors.red));
      expect(style.activeColor, equals(Colors.green));
      expect(
          style.animationDuration, equals(const Duration(milliseconds: 300)));
      expect(style.lineThickness, equals(6.0));
      expect(style.borderRadius, equals(const Radius.circular(8)));
      expect(style.isBreadcrumb, isTrue);
      expect(style.chevronAngle, equals(45));
      expect(style.borderStyle, equals(const OuterBorderStyle(isDotted: true)));
    });

    test(
        'copyWith returns a new instance with same values'
        ' if no arguments provided', () {
      const style = StepLineStyle(
        foregroundColor: Colors.blue,
        activeColor: Colors.yellow,
        animationDuration: Duration(seconds: 1),
        lineThickness: 10,
        borderRadius: Radius.circular(5),
        isBreadcrumb: true,
        chevronAngle: 50,
        borderStyle: OuterBorderStyle(isDotted: true),
      );
      final copiedStyle = style.copyWith();
      expect(copiedStyle.foregroundColor, equals(style.foregroundColor));
      expect(copiedStyle.activeColor, equals(style.activeColor));
      expect(copiedStyle.animationDuration, equals(style.animationDuration));
      expect(copiedStyle.lineThickness, equals(style.lineThickness));
      expect(copiedStyle.borderRadius, equals(style.borderRadius));
      expect(copiedStyle.isBreadcrumb, equals(style.isBreadcrumb));
      expect(copiedStyle.chevronAngle, equals(style.chevronAngle));
      expect(copiedStyle.borderStyle, equals(style.borderStyle));
    });

    test('copyWith correctly overrides provided values', () {
      const style = StepLineStyle(
        foregroundColor: Colors.blue,
        activeColor: Colors.yellow,
        animationDuration: Duration(seconds: 1),
        lineThickness: 10,
        borderRadius: Radius.circular(5),
        isBreadcrumb: false,
        chevronAngle: 30,
        borderStyle: OuterBorderStyle(isDotted: false),
      );
      final copiedStyle = style.copyWith(
        foregroundColor: Colors.purple,
        animationDuration: const Duration(milliseconds: 500),
        lineThickness: 12,
        borderRadius: const Radius.circular(15),
        isBreadcrumb: true,
        chevronAngle: 60,
        borderStyle: const OuterBorderStyle(isDotted: true),
      );
      expect(copiedStyle.foregroundColor, equals(Colors.purple));
      expect(copiedStyle.activeColor, equals(style.activeColor));
      expect(copiedStyle.animationDuration,
          equals(const Duration(milliseconds: 500)));
      expect(copiedStyle.lineThickness, equals(12.0));
      expect(copiedStyle.borderRadius, equals(const Radius.circular(15)));
      expect(copiedStyle.isBreadcrumb, isTrue);
      expect(copiedStyle.chevronAngle, equals(60));
      expect(copiedStyle.borderStyle,
          equals(const OuterBorderStyle(isDotted: true)));
    });

    test('copyWith throws assertion error with negative lineThickness', () {
      const style = StepLineStyle();
      expect(() => style.copyWith(lineThickness: -5), throwsAssertionError);
    });

    test('copyWith with null parameters retains original non-null values', () {
      const style = StepLineStyle(
        foregroundColor: Colors.orange,
        activeColor: Colors.green,
        animationDuration: Duration(seconds: 2),
        lineThickness: 8,
        borderRadius: Radius.circular(10),
        isBreadcrumb: true,
        chevronAngle: 22,
        borderStyle: OuterBorderStyle(isDotted: true),
      );
      final copiedStyle = style.copyWith(
        foregroundColor: null,
        activeColor: null,
        animationDuration: null,
        lineThickness: null,
        borderRadius: null,
        isBreadcrumb: null,
        chevronAngle: null,
        borderStyle: null,
      );
      expect(copiedStyle.foregroundColor, equals(style.foregroundColor));
      expect(copiedStyle.activeColor, equals(style.activeColor));
      expect(copiedStyle.animationDuration, equals(style.animationDuration));
      expect(copiedStyle.lineThickness, equals(style.lineThickness));
      expect(copiedStyle.borderRadius, equals(style.borderRadius));
      expect(copiedStyle.isBreadcrumb, equals(style.isBreadcrumb));
      expect(copiedStyle.chevronAngle, equals(style.chevronAngle));
      expect(copiedStyle.borderStyle, equals(style.borderStyle));
    });

    test('Default values for isBreadcrumb, chevronAngle, and borderStyle', () {
      const style = StepLineStyle();
      expect(style.isBreadcrumb, isFalse);
      expect(style.chevronAngle, equals(30));
      expect(style.borderStyle, isNull);
    });

    test('Can set isBreadcrumb, chevronAngle, and borderStyle', () {
      const outterBorderStyle = OuterBorderStyle();
      const style = StepLineStyle(
        isBreadcrumb: true,
        chevronAngle: 45,
        borderStyle: outterBorderStyle,
      );
      expect(style.isBreadcrumb, isTrue);
      expect(style.chevronAngle, equals(45));
      expect(style.borderStyle, equals(outterBorderStyle));
    });

    test('copyWith updates isBreadcrumb, chevronAngle, and borderStyle', () {
      const outterBorderStyle = OuterBorderStyle();
      const style = StepLineStyle(
        isBreadcrumb: false,
        chevronAngle: 30,
        borderStyle: outterBorderStyle,
      );
      final updated = style.copyWith(
        isBreadcrumb: true,
        chevronAngle: 60,
        borderStyle: outterBorderStyle.copyWith(isDotted: true),
      );
      expect(updated.isBreadcrumb, isTrue);
      expect(updated.chevronAngle, equals(60));
      expect(updated.borderStyle?.isDotted, isTrue);
    });

    test('copyWith keeps original values if not specified', () {
      const style = StepLineStyle(
        isBreadcrumb: true,
        chevronAngle: 15,
        borderStyle: OuterBorderStyle(isDotted: true),
      );
      final updated = style.copyWith();
      expect(updated.isBreadcrumb, equals(style.isBreadcrumb));
      expect(updated.chevronAngle, equals(style.chevronAngle));
      expect(updated.borderStyle?.isDotted, isTrue);
    });

    test('equality and hashCode', () {
      const style1 = StepLineStyle(
        foregroundColor: Colors.red,
        activeColor: Colors.green,
        animationDuration: Duration(milliseconds: 300),
        lineThickness: 6,
        borderRadius: Radius.circular(8),
        isBreadcrumb: true,
        chevronAngle: 45,
        borderStyle: OuterBorderStyle(isDotted: true),
      );
      const style2 = StepLineStyle(
        foregroundColor: Colors.red,
        activeColor: Colors.green,
        animationDuration: Duration(milliseconds: 300),
        lineThickness: 6,
        borderRadius: Radius.circular(8),
        isBreadcrumb: true,
        chevronAngle: 45,
        borderStyle: OuterBorderStyle(isDotted: true),
      );
      expect(style1, equals(style2));
      expect(style1.hashCode, equals(style2.hashCode));
    });
  });
}
