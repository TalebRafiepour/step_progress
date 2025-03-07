import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/helpers/keep_size_visibility.dart';

void main() {
  group('KeepSizeVisibility', () {
    testWidgets('should show child when visible is true', (tester) async {
      const childKey = Key('test-child');
      await tester.pumpWidget(
        MaterialApp(
          home: KeepSizeVisibility(
            visible: true,
            child: Container(
              key: childKey,
              width: 100,
              height: 100,
              color: Colors.red,
            ),
          ),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('should hide child but preserve size when visible is false', (
      tester,
    ) async {
      const childKey = Key('test-child');
      const childSize = 100.0;

      // First render with visible true
      await tester.pumpWidget(
        MaterialApp(
          home: KeepSizeVisibility(
            visible: true,
            child: Container(
              key: childKey,
              width: childSize,
              height: childSize,
              color: Colors.red,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Then render with visible false
      await tester.pumpWidget(
        MaterialApp(
          home: KeepSizeVisibility(
            visible: false,
            child: Container(
              key: childKey,
              width: childSize,
              height: childSize,
              color: Colors.red,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Child should be hidden
      expect(find.byKey(childKey), findsNothing);

      // But a SizedBox with the same size should exist
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, equals(childSize));
      expect(sizedBox.height, equals(childSize));
    });

    testWidgets('should update size when child size changes', (tester) async {
      const initialSize = 100.0;
      const newSize = 150.0;
      late StateSetter stateSetter;

      double size = initialSize;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return KeepSizeVisibility(
                visible: true,
                child: Container(width: size, height: size, color: Colors.red),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Change size
      stateSetter(() {
        size = newSize;
      });
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.maxWidth, equals(newSize));
      expect(container.constraints?.maxHeight, equals(newSize));
    });

    testWidgets('should maintain size when toggling visibility', (
      tester,
    ) async {
      const childSize = 100.0;
      late StateSetter stateSetter;
      var isVisible = true;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return KeepSizeVisibility(
                visible: isVisible,
                child: Container(
                  width: childSize,
                  height: childSize,
                  color: Colors.red,
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Toggle visibility
      stateSetter(() {
        isVisible = false;
      });
      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, equals(childSize));
      expect(sizedBox.height, equals(childSize));
    });
  });

  group('MeasureSize', () {
    testWidgets('should report size changes', (tester) async {
      Size? reportedSize;

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: MeasureSize(
              onChange: (size) {
                reportedSize = size;
              },
              child: Container(width: 100, height: 100, color: Colors.blue),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(reportedSize, isNotNull);
      expect(reportedSize!.width, equals(100));
      expect(reportedSize!.height, equals(100));
    });

    testWidgets('should report new size when child size changes', (
      tester,
    ) async {
      Size? reportedSize;
      late StateSetter stateSetter;
      double size = 100;

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: StatefulBuilder(
              builder: (context, setState) {
                stateSetter = setState;
                return MeasureSize(
                  onChange: (newSize) {
                    reportedSize = newSize;
                  },
                  child: Container(
                    width: size,
                    height: size,
                    color: Colors.blue,
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(reportedSize!.width, equals(100));

      stateSetter(() {
        size = 150;
      });
      await tester.pumpAndSettle();

      expect(reportedSize!.width, equals(150));
    });
  });
}
