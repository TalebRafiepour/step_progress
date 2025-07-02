// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_node/step_node_shape.dart';
import 'package:step_progress/src/step_node/step_node_style.dart';

void main() {
  group('StepNodeStyle', () {
    test('Constructor sets default values correctly', () {
      const style = StepNodeStyle();

      // defaultForegroundColor, activeForegroundColor, shape, activeDecoration,
      // and animationDuration should be null
      expect(style.defaultForegroundColor, isNull);
      expect(style.activeForegroundColor, isNull);
      expect(style.animationDuration, isNull);
      expect(style.shape, isNull);
      expect(style.activeDecoration, isNull);

      // Default decoration color is a semi-transparent white as set in
      // the constructor
      expect(
        style.decoration.color,
        equals(const Color.fromARGB(50, 255, 255, 255)),
      );

      // By default, no icon is set(and activeIcon is defined with a check icon)
      expect(style.icon, isNull);
      expect(style.activeIcon, isA<Icon>());

      // Default icon color
      expect(style.iconColor, isNull);

      // Ripple effect is enabled by default
      expect(style.enableRippleEffect, isTrue);
    });

    test('copyWith returns identical instance when no values provided', () {
      const style = StepNodeStyle(
        defaultForegroundColor: Colors.red,
        activeForegroundColor: Colors.green,
        animationDuration: Duration(seconds: 1),
        iconColor: Colors.blue,
        shape: StepNodeShape.circle,
        activeDecoration: BoxDecoration(color: Colors.orange),
        decoration: BoxDecoration(color: Colors.yellow),
        icon: Icon(Icons.star),
        activeIcon: Icon(Icons.check),
        enableRippleEffect: false,
      );
      final copy = style.copyWith();

      // All properties should remain the same.
      expect(copy.defaultForegroundColor, equals(style.defaultForegroundColor));
      expect(copy.activeForegroundColor, equals(style.activeForegroundColor));
      expect(copy.animationDuration, equals(style.animationDuration));
      expect(
        copy.activeDecoration?.color,
        equals(style.activeDecoration?.color),
      );
      expect(copy.iconColor, equals(style.iconColor));
      expect(copy.shape, equals(style.shape));
      expect(copy.decoration.color, equals(style.decoration.color));

      // Compare widget properties via their string representation
      expect(copy.icon.toString(), equals(style.icon.toString()));
      expect(copy.activeIcon.toString(), equals(style.activeIcon.toString()));

      expect(copy.enableRippleEffect, equals(style.enableRippleEffect));
    });

    test('copyWith updates provided fields correctly', () {
      const style = StepNodeStyle(
        defaultForegroundColor: Colors.red,
        activeForegroundColor: Colors.green,
        animationDuration: Duration(seconds: 1),
        iconColor: Colors.blue,
        shape: StepNodeShape.circle,
        decoration: BoxDecoration(color: Colors.yellow),
        icon: Icon(Icons.star),
        activeDecoration: BoxDecoration(color: Colors.orange),
        activeIcon: Icon(Icons.check),
        enableRippleEffect: false,
      );
      const newForeground = Colors.purple;
      const newActiveForeground = Colors.orange;
      const newDuration = Duration(milliseconds: 500);
      const newIconColor = Colors.black;
      // Assuming that StepNodeShape has another value like "square"
      const newShape = StepNodeShape.square;
      const newDecoration = BoxDecoration(color: Colors.grey);
      const newActiveDecoration = BoxDecoration(color: Colors.brown);
      const newIcon = Icon(Icons.ac_unit);
      const newActiveIcon = Icon(Icons.access_alarm);

      final copy = style.copyWith(
        defaultForegroundColor: newForeground,
        activeForegroundColor: newActiveForeground,
        animationDuration: newDuration,
        iconColor: newIconColor,
        shape: newShape,
        decoration: newDecoration,
        activeDecoration: newActiveDecoration,
        icon: newIcon,
        activeIcon: newActiveIcon,
        enableRippleEffect: true,
      );

      expect(copy.defaultForegroundColor, equals(newForeground));
      expect(copy.activeForegroundColor, equals(newActiveForeground));
      expect(copy.animationDuration, equals(newDuration));
      expect(copy.iconColor, equals(newIconColor));
      expect(copy.shape, equals(newShape));
      expect(copy.decoration.color, equals(Colors.grey));
      expect(copy.activeDecoration?.color, equals(Colors.brown));
      expect(copy.icon.toString(), equals(newIcon.toString()));
      expect(copy.activeIcon.toString(), equals(newActiveIcon.toString()));
      expect(copy.enableRippleEffect, isTrue);
    });

    test(
        'copyWith with explicit null values does not override existing '
        'non-null properties', () {
      // Create a style with non-null values.
      const style = StepNodeStyle(
        defaultForegroundColor: Colors.red,
        activeForegroundColor: Colors.green,
        animationDuration: Duration(seconds: 1),
        iconColor: Colors.blue,
        shape: StepNodeShape.circle,
        decoration: BoxDecoration(color: Colors.yellow),
        activeDecoration: BoxDecoration(color: Colors.orange),
        icon: Icon(Icons.star),
        activeIcon: Icon(Icons.check),
        enableRippleEffect: false,
      );

      // Explicitly passing null should result in using the existing value,
      // because of "?? this.field" in copyWith implementation.
      final copy = style.copyWith(
        defaultForegroundColor: null,
        activeForegroundColor: null,
        animationDuration: null,
        iconColor: null,
        shape: null,
        decoration: null,
        activeDecoration: null,
        icon: null,
        activeIcon: null,
        enableRippleEffect: null,
      );

      expect(copy.defaultForegroundColor, equals(Colors.red));
      expect(copy.activeForegroundColor, equals(Colors.green));
      expect(copy.animationDuration, equals(const Duration(seconds: 1)));
      expect(copy.iconColor, equals(Colors.blue));
      expect(copy.shape, equals(StepNodeShape.circle));
      expect(copy.decoration.color, equals(Colors.yellow));
      expect(copy.activeDecoration?.color, equals(Colors.orange));

      // Compare icon widget properties via toString.
      expect(copy.icon.toString(), equals(const Icon(Icons.star).toString()));
      expect(
        copy.activeIcon.toString(),
        equals(const Icon(Icons.check).toString()),
      );

      expect(copy.enableRippleEffect, equals(false));
    });

    test('Performance: copyWith scales under load', () {
      const style = StepNodeStyle(
        defaultForegroundColor: Colors.red,
        activeForegroundColor: Colors.green,
        animationDuration: Duration(seconds: 1),
        iconColor: Colors.blue,
        shape: StepNodeShape.circle,
        decoration: BoxDecoration(color: Colors.yellow),
        activeDecoration: BoxDecoration(color: Colors.orange),
        icon: Icon(Icons.star),
        activeIcon: Icon(Icons.check),
        enableRippleEffect: false,
      );

      final stopwatch = Stopwatch()..start();
      // Call copyWith 10,000 times with small updates.
      for (int i = 0; i < 10000; i++) {
        style.copyWith(
          defaultForegroundColor: Colors.primaries[i % Colors.primaries.length],
          activeForegroundColor:
              Colors.primaries[(i + 1) % Colors.primaries.length],
        );
      }
      stopwatch.stop();
      // Verify that the total elapsed time is within acceptable performance
      // limits.
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });
}
