import 'dart:math' show pi, tan;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_line/breadcrumb_clipper.dart';

void main() {
  group('BreadcrumbClipper', () {
    test('constructor parameters are correctly assigned', () {
      const clipper = BreadcrumbClipper(
        angle: 45,
        axis: Axis.horizontal,
        isReversed: false,
      );

      expect(clipper.angle, 45);
      expect(clipper.axis, Axis.horizontal);
      expect(clipper.isReversed, false);
    });

    group('getClip - Horizontal Axis', () {
      test('creates correct path for normal direction', () {
        const clipper = BreadcrumbClipper(
          angle: 45,
          axis: Axis.horizontal,
          isReversed: false,
        );
        const size = Size(100, 50);

        final path = clipper.getClip(size);
        final chevronWidth = size.height * tan(45 * pi / 180);

        // Verify path contains correct number of points
        expect(path.contains(Offset.zero), isTrue);
        expect(path.contains(Offset(100 - chevronWidth, 0)), isTrue);
        expect(path.contains(const Offset(100, 25)), isTrue);
        expect(path.contains(Offset(100 - chevronWidth, 50)), isTrue);
        expect(path.contains(const Offset(0, 50)), isTrue);
        expect(path.contains(Offset(chevronWidth, 25)), isTrue);
      });

      test('creates correct path for reversed direction', () {
        const clipper = BreadcrumbClipper(
          angle: 45,
          axis: Axis.horizontal,
          isReversed: true,
        );
        const size = Size(100, 50);

        final path = clipper.getClip(size);
        final chevronWidth = size.height * tan(45 * pi / 180);

        expect(path.contains(const Offset(100, 0)), isTrue);
        expect(path.contains(Offset(chevronWidth, 0)), isTrue);
        expect(path.contains(const Offset(0, 25)), isTrue);
        expect(path.contains(Offset(chevronWidth, 50)), isTrue);
        expect(path.contains(const Offset(100, 50)), isTrue);
        expect(path.contains(Offset(100 - chevronWidth, 25)), isTrue);
      });
    });

    group('getClip - Vertical Axis', () {
      test('creates correct path for normal direction', () {
        const clipper = BreadcrumbClipper(
          angle: 45,
          axis: Axis.vertical,
          isReversed: false,
        );
        const size = Size(50, 100);

        final path = clipper.getClip(size);
        final chevronHeight = size.width * tan(45 * pi / 180);

        expect(path.contains(Offset.zero), isTrue);
        expect(path.contains(Offset(0, 100 - chevronHeight)), isTrue);
        expect(path.contains(const Offset(25, 100)), isTrue);
        expect(path.contains(Offset(50, 100 - chevronHeight)), isTrue);
        expect(path.contains(const Offset(50, 0)), isTrue);
        expect(path.contains(Offset(25, chevronHeight)), isTrue);
      });

      test('creates correct path for reversed direction', () {
        const clipper = BreadcrumbClipper(
          angle: 45,
          axis: Axis.vertical,
          isReversed: true,
        );
        const size = Size(50, 100);

        final path = clipper.getClip(size);
        final chevronHeight = size.width * tan(45 * pi / 180);

        expect(path.contains(const Offset(0, 100)), isTrue);
        expect(path.contains(Offset(0, chevronHeight)), isTrue);
        expect(path.contains(const Offset(25, 0)), isTrue);
        expect(path.contains(Offset(50, chevronHeight)), isTrue);
        expect(path.contains(const Offset(50, 100)), isTrue);
        expect(path.contains(Offset(25, 100 - chevronHeight)), isTrue);
      });
    });

    group('shouldReclip', () {
      test('returns true when angle changes', () {
        const oldClipper = BreadcrumbClipper(
          angle: 45,
          axis: Axis.horizontal,
          isReversed: false,
        );
        const newClipper = BreadcrumbClipper(
          angle: 60,
          axis: Axis.horizontal,
          isReversed: false,
        );

        expect(newClipper.shouldReclip(oldClipper), isTrue);
      });

      test('returns true when axis changes', () {
        const oldClipper = BreadcrumbClipper(
          angle: 45,
          axis: Axis.horizontal,
          isReversed: false,
        );
        const newClipper = BreadcrumbClipper(
          angle: 45,
          axis: Axis.vertical,
          isReversed: false,
        );

        expect(newClipper.shouldReclip(oldClipper), isTrue);
      });

      test('returns false when all parameters are same', () {
        const oldClipper = BreadcrumbClipper(
          angle: 45,
          axis: Axis.horizontal,
          isReversed: false,
        );
        const newClipper = BreadcrumbClipper(
          angle: 45,
          axis: Axis.horizontal,
          isReversed: false,
        );

        expect(newClipper.shouldReclip(oldClipper), isFalse);
      });
    });
  });
}
