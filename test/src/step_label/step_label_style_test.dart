// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_label/step_label_style.dart';

void main() {
  group('StepLabelStyle Tests', () {
    // Positive test case: Validate that default values are assigned correctly.
    test('Default values', () {
      const style = StepLabelStyle();

      expect(style.labelAxisAlignment, CrossAxisAlignment.center);
      expect(style.activeColor, isNull);
      expect(style.defualtColor, isNull);
      expect(style.titleStyle, isNull);
      expect(style.subTitleStyle, isNull);
      expect(style.textAlign, TextAlign.center);
      expect(style.titleMaxLines, 3);
      expect(style.subTitleMaxLines, 3);
      expect(style.overflow, TextOverflow.ellipsis);
      expect(style.padding, EdgeInsets.zero);
      expect(style.margin, const EdgeInsets.all(2));
      expect(style.maxWidth, 48);
      expect(style.animationDuration, isNull);
    });

    // Positive test case: Validate that copyWith returns new instance
    // with updated values.
    test('copyWith returns updated instance with new values', () {
      const original = StepLabelStyle();
      final copy = original.copyWith(
        labelAxisAlignment: CrossAxisAlignment.start,
        activeColor: Colors.red,
        defualtColor: Colors.grey,
        titleStyle: const TextStyle(fontSize: 14),
        subTitleStyle: const TextStyle(fontSize: 12),
        textAlign: TextAlign.left,
        titleMaxLines: 5,
        subTitleMaxLines: 2,
        overflow: TextOverflow.visible,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(4),
        maxWidth: 100,
        animationDuration: const Duration(milliseconds: 300),
      );

      expect(copy.labelAxisAlignment, CrossAxisAlignment.start);
      expect(copy.activeColor, Colors.red);
      expect(copy.defualtColor, Colors.grey);
      expect(copy.titleStyle, const TextStyle(fontSize: 14));
      expect(copy.subTitleStyle, const TextStyle(fontSize: 12));
      expect(copy.textAlign, TextAlign.left);
      expect(copy.titleMaxLines, 5);
      expect(copy.subTitleMaxLines, 2);
      expect(copy.overflow, TextOverflow.visible);
      expect(copy.padding, const EdgeInsets.all(8));
      expect(copy.margin, const EdgeInsets.all(4));
      expect(copy.maxWidth, 100);
      expect(copy.animationDuration, const Duration(milliseconds: 300));
    });

    test('copyWith without changes returns instance with same values', () {
      const original = StepLabelStyle();
      final copy = original.copyWith();

      expect(copy.labelAxisAlignment, original.labelAxisAlignment);
      expect(copy.activeColor, original.activeColor);
      expect(copy.defualtColor, original.defualtColor);
      expect(copy.titleStyle, original.titleStyle);
      expect(copy.subTitleStyle, original.subTitleStyle);
      expect(copy.textAlign, original.textAlign);
      expect(copy.titleMaxLines, original.titleMaxLines);
      expect(copy.subTitleMaxLines, original.subTitleMaxLines);
      expect(copy.overflow, original.overflow);
      expect(copy.padding, original.padding);
      expect(copy.margin, original.margin);
      expect(copy.maxWidth, original.maxWidth);
      expect(copy.animationDuration, original.animationDuration);

      // Although all values are equivalent, the instance is a new one.
      expect(copy, isNot(same(original)));
    });

    // Positive test case: Chaining copyWith calls to update values.
    test('Chaining copyWith calls preserves updated values correctly', () {
      const initial = StepLabelStyle();
      final updated1 = initial.copyWith(textAlign: TextAlign.right);
      final updated2 = updated1.copyWith(titleMaxLines: 10);

      expect(updated2.textAlign, TextAlign.right);
      expect(updated2.titleMaxLines, 10);
      // The rest of the properties should remain at their default values.
      expect(updated2.subTitleMaxLines, 3);
    });

    // Negative test (conceptual): Ensure that providing null for parameters
    // that default to null does not override default behaviors.
    test(
        'Negative test: copyWith with explicit null values returns expected'
        ' null fields', () {
      const original = StepLabelStyle();
      final updated = original.copyWith(
        activeColor: null,
        defualtColor: null,
        titleStyle: null,
        subTitleStyle: null,
      );

      expect(updated.activeColor, isNull);
      expect(updated.defualtColor, isNull);
      expect(updated.titleStyle, isNull);
      expect(updated.subTitleStyle, isNull);

      expect(updated, isNot(same(original)));
    });
  });
}
