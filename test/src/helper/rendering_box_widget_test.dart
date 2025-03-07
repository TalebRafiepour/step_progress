import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/helpers/rendering_box_widget.dart';

void main() {
  group('RenderingBoxWidget', () {
    testWidgets('should render child widget correctly', (tester) async {
      const childKey = Key('test-child');
      final boxNotifier = ValueNotifier<RenderBox?>(null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RenderingBoxWidget(
              boxNotifier: boxNotifier,
              child: const SizedBox(key: childKey, width: 100, height: 100),
            ),
          ),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('should notify with RenderBox after build', (tester) async {
      final boxNotifier = ValueNotifier<RenderBox?>(null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RenderingBoxWidget(
              boxNotifier: boxNotifier,
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );

      // Wait for microtask to complete
      await tester.pumpAndSettle();

      expect(boxNotifier.value, isNotNull);
      expect(boxNotifier.value, isA<RenderBox>());
    });

    testWidgets('should update RenderBox size on widget size change rebuild', (
      tester,
    ) async {
      final boxNotifier = ValueNotifier<RenderBox?>(null);
      late StateSetter setState;
      double size = 100;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setStateCallback) {
                setState = setStateCallback;
                return RenderingBoxWidget(
                  boxNotifier: boxNotifier,
                  child: SizedBox(width: size, height: size),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final initialRenderBox = boxNotifier.value;
      expect(initialRenderBox, isNotNull);

      // Change container size
      setState(() {
        size = 200;
      });
      await tester.pumpAndSettle();

      expect(boxNotifier.value, isNotNull);
      expect(boxNotifier.value?.size.width, equals(200));
    });

    testWidgets('should maintain correct box properties', (tester) async {
      final boxNotifier = ValueNotifier<RenderBox?>(null);
      const expectedSize = Size(100, 100);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RenderingBoxWidget(
                boxNotifier: boxNotifier,
                child: SizedBox(
                  width: expectedSize.width,
                  height: expectedSize.height,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(boxNotifier.value, isNotNull);
      expect(boxNotifier.value!.size, equals(expectedSize));
    });

    testWidgets('should work with different child widget types', (
      tester,
    ) async {
      final boxNotifier = ValueNotifier<RenderBox?>(null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RenderingBoxWidget(
              boxNotifier: boxNotifier,
              child: const Text('Test Text'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(boxNotifier.value, isNotNull);
      expect(find.text('Test Text'), findsOneWidget);
    });
  });
}
