import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/outer_border_style.dart';

void main() {
  group('OuterBorderStyle', () {
    test('should have correct default values', () {
      const style = OuterBorderStyle();

      expect(style.borderWidth, equals(2.0));
      expect(
        style.defaultBorderColor,
        equals(const Color.fromARGB(255, 191, 196, 195)),
      );
      expect(
        style.activeBorderColor,
        equals(const Color.fromARGB(255, 0, 167, 160)),
      );
      expect(style.isDotted, isFalse);
      expect(style.dashPattern, equals(const [0.7, 4]));
    });

    test('should create instance with custom values', () {
      const style = OuterBorderStyle(
        borderWidth: 3,
        defaultBorderColor: Colors.red,
        activeBorderColor: Colors.blue,
        isDotted: true,
        dashPattern: [2.0, 2.0],
      );

      expect(style.borderWidth, equals(3.0));
      expect(style.defaultBorderColor, equals(Colors.red));
      expect(style.activeBorderColor, equals(Colors.blue));
      expect(style.isDotted, isTrue);
      expect(style.dashPattern, equals(const [2.0, 2.0]));
    });

    test('should throw assertion error when borderWidth is <= 0', () {
      expect(() => OuterBorderStyle(borderWidth: 0), throwsAssertionError);
      expect(() => OuterBorderStyle(borderWidth: -1), throwsAssertionError);
    });

    group('copyWith', () {
      test('should return new instance with updated values', () {
        const original = OuterBorderStyle();
        final copied = original.copyWith(
          borderWidth: 5,
          defaultBorderColor: Colors.green,
          activeBorderColor: Colors.yellow,
          isDotted: true,
          dashPattern: const [1.0, 1.0],
        );

        expect(copied.borderWidth, equals(5.0));
        expect(copied.defaultBorderColor, equals(Colors.green));
        expect(copied.activeBorderColor, equals(Colors.yellow));
        expect(copied.isDotted, isTrue);
        expect(copied.dashPattern, equals(const [1.0, 1.0]));
      });

      test('should keep original values when parameters are null', () {
        const original = OuterBorderStyle(
          borderWidth: 3,
          defaultBorderColor: Colors.red,
          activeBorderColor: Colors.blue,
          isDotted: true,
          dashPattern: [2.0, 2.0],
        );
        final copied = original.copyWith();

        expect(copied.borderWidth, equals(original.borderWidth));
        expect(copied.defaultBorderColor, equals(original.defaultBorderColor));
        expect(copied.activeBorderColor, equals(original.activeBorderColor));
        expect(copied.isDotted, equals(original.isDotted));
        expect(copied.dashPattern, equals(original.dashPattern));
      });

      test('should update only specified values', () {
        const original = OuterBorderStyle();
        final copied = original.copyWith(
          borderWidth: 4,
          defaultBorderColor: Colors.purple,
        );

        expect(copied.borderWidth, equals(4.0));
        expect(copied.defaultBorderColor, equals(Colors.purple));
        expect(copied.activeBorderColor, equals(original.activeBorderColor));
        expect(copied.isDotted, equals(original.isDotted));
        expect(copied.dashPattern, equals(original.dashPattern));
      });
    });
  });
}
