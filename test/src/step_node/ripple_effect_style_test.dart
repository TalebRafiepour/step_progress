// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_node/ripple_effect_style.dart';

void main() {
  group('RippleEffectStyle', () {
    test('Default constructor sets properties correctly', () {
      const style = RippleEffectStyle();
      // Ensure default values are set correctly.
      expect(style.foregroundColor, isNull);
      expect(style.borderColor, isNull);
      expect(style.borderWidth, 1);
      expect(style.animationDuration, isNull);
    });

    test('copyWith with no arguments returns identical properties', () {
      const original = RippleEffectStyle(
        foregroundColor: Colors.red,
        borderColor: Colors.blue,
        borderWidth: 4,
        animationDuration: Duration(milliseconds: 300),
      );
      final copy = original.copyWith();

      // Verify that all properties remain the same.
      expect(copy.foregroundColor, original.foregroundColor);
      expect(copy.borderColor, original.borderColor);
      expect(copy.borderWidth, original.borderWidth);
      expect(copy.animationDuration, original.animationDuration);
    });

    test(
      'copyWith updates selected properties while leaving others unchanged',
      () {
        const original = RippleEffectStyle(
          foregroundColor: Colors.red,
          borderColor: Colors.blue,
          borderWidth: 4,
          animationDuration: Duration(milliseconds: 300),
        );

        // Update borderColor and borderWidth.
        final updated = original.copyWith(
          borderColor: Colors.green,
          borderWidth: 5,
        );

        // Verify updated properties.
        expect(updated.borderColor, Colors.green);
        expect(updated.borderWidth, 5);
        // Verify unchanged properties.
        expect(updated.foregroundColor, original.foregroundColor);
        expect(updated.animationDuration, original.animationDuration);
      },
    );

    test(
        'copyWith does not override existing non-null values when passing '
        'null explicitly', () {
      const original = RippleEffectStyle(
        foregroundColor: Colors.red,
        borderColor: Colors.blue,
        borderWidth: 4,
        animationDuration: Duration(milliseconds: 300),
      );

      // Passing null explicitly for the optional parameters.
      final updated = original.copyWith(
        foregroundColor: null,
        borderColor: null,
        animationDuration: null,
      );

      // The implementation uses null-aware operators, so null parameters do
      // not override existing values.
      expect(updated.foregroundColor, original.foregroundColor);
      expect(updated.borderColor, original.borderColor);
      expect(updated.animationDuration, original.animationDuration);
      // Border width was not passed, so it remains as well.
      expect(updated.borderWidth, original.borderWidth);
    });

    test('copyWith not accepts a negative borderWidth', () {
      const original = RippleEffectStyle(borderWidth: 4);
      expect(() => original.copyWith(borderWidth: -1), throwsAssertionError);
    });
  });
}
