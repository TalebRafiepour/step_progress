import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_label/step_label.dart';
import 'package:step_progress/step_progress.dart';

import '../helper/test_theme_wrapper.dart';

void main() {
  // Create a dummy StepLabelStyle with required fields.
  const dummyLabelStyle = StepLabelStyle(
    padding: EdgeInsets.all(8),
    margin: EdgeInsets.all(4),
    maxWidth: 200,
    animationDuration: Duration(milliseconds: 300),
    titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    subTitleStyle: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
    titleMaxLines: 1,
    activeColor: Colors.green,
    defualtColor: Colors.grey,
  );

  // Create a dummy StepProgressThemeData
  const dummyThemeData = StepProgressThemeData(
    nodeLabelStyle: dummyLabelStyle,
    stepAnimationDuration: Duration(milliseconds: 350),
    activeForegroundColor: Colors.blue,
    defaultForegroundColor: Colors.red,
  );

  group('StepLabel Widget Tests', () {
    testWidgets('Displays title and subtitle when provided', (tester) async {
      await tester.pumpWidget(
        const TestThemeWrapper(
          themeData: dummyThemeData,
          child: StepLabel(
            style: dummyLabelStyle,
            title: 'Step 1',
            subTitle: 'Introduction',
            isActive: true,
          ),
        ),
      );
      expect(find.text('Step 1'), findsOneWidget);
      expect(find.text('Introduction'), findsOneWidget);
    });

    testWidgets('Displays only title when subTitle is null', (tester) async {
      await tester.pumpWidget(
        const TestThemeWrapper(
          themeData: dummyThemeData,
          child: StepLabel(style: dummyLabelStyle, title: 'Only Title'),
        ),
      );
      expect(find.text('Only Title'), findsOneWidget);
      // There should be no widget with an empty subtitle.
      expect(
        find.byWidgetPredicate((widget) {
          return widget is Text && widget.data == '';
        }),
        findsNothing,
      );
    });

    testWidgets('Displays only subtitle when title is null', (tester) async {
      await tester.pumpWidget(
        const TestThemeWrapper(
          themeData: dummyThemeData,
          child: StepLabel(style: dummyLabelStyle, subTitle: 'Only Subtitle'),
        ),
      );
      expect(find.text('Only Subtitle'), findsOneWidget);
      expect(
        find.byWidgetPredicate((widget) {
          return widget is Text && widget.data == '';
        }),
        findsNothing,
      );
    });

    testWidgets('Uses active color when isActive is true', (tester) async {
      await tester.pumpWidget(
        const TestThemeWrapper(
          themeData: dummyThemeData,
          child: StepLabel(
            style: dummyLabelStyle,
            title: 'Active Step',
            isActive: true,
          ),
        ),
      );

      // Find the AnimatedDefaultTextStyle widget for the title.
      final activeTextWidget = tester.widget<AnimatedDefaultTextStyle>(
        find
            .descendant(
              of: find.byType(StepLabel),
              matching: find.byType(AnimatedDefaultTextStyle),
            )
            .first,
      );

      // We expect the color to come from the label style activeColor.
      expect(activeTextWidget.style.color, dummyLabelStyle.activeColor);
    });

    testWidgets('Uses default color when isActive is false', (tester) async {
      await tester.pumpWidget(
        const TestThemeWrapper(
          themeData: dummyThemeData,
          child: StepLabel(style: dummyLabelStyle, title: 'Inactive Step'),
        ),
      );

      final defaultTextWidget = tester.widget<AnimatedDefaultTextStyle>(
        find
            .descendant(
              of: find.byType(StepLabel),
              matching: find.byType(AnimatedDefaultTextStyle),
            )
            .first,
      );

      expect(defaultTextWidget.style.color, dummyLabelStyle.defualtColor);
    });

    testWidgets(
      'Falls back to Material Theme text style when no custom titleStyle is'
      ' provided',
      (tester) async {
        const customThemeData = StepProgressThemeData(
          stepAnimationDuration: Duration(milliseconds: 350),
          activeForegroundColor: Colors.blue,
          defaultForegroundColor: Colors.red,
        );
        await tester.pumpWidget(
          const TestThemeWrapper(
            themeData: customThemeData,
            child: StepLabel(title: 'Test Title'),
          ),
        );
        // Grab the AnimatedDefaultTextStyle for title.
        final animatedText = tester.widget<AnimatedDefaultTextStyle>(
          find
              .descendant(
                of: find.byType(StepLabel),
                matching: find.byType(AnimatedDefaultTextStyle),
              )
              .first,
        );
        // The fallback should be Theme.of(context).textTheme.labelMedium.
        final expectedStyle =
            Theme.of(
              tester.element(find.byType(StepLabel)),
            ).textTheme.labelMedium;
        expect(animatedText.style.fontSize, expectedStyle?.fontSize);
      },
    );

    testWidgets(
      'Falls back to Material Theme text style when no custom subTitleStyle'
      ' is provided',
      (tester) async {
        const customThemeData = StepProgressThemeData(
          stepAnimationDuration: Duration(milliseconds: 350),
          activeForegroundColor: Colors.blue,
          defaultForegroundColor: Colors.red,
        );
        await tester.pumpWidget(
          const TestThemeWrapper(
            themeData: customThemeData,
            child: StepLabel(subTitle: 'Test Subtitle'),
          ),
        );
        // Grab the AnimatedDefaultTextStyle for subtitle.
        final animatedText = tester.widget<AnimatedDefaultTextStyle>(
          find
              .descendant(
                of: find.byType(StepLabel),
                matching: find.byType(AnimatedDefaultTextStyle),
              )
              .first,
        );
        final expectedStyle =
            Theme.of(
              tester.element(find.byType(StepLabel)),
            ).textTheme.labelSmall;
        expect(animatedText.style.fontSize, expectedStyle?.fontSize);
      },
    );
  });

  group('StepLabel Private Methods (Indirect Testing)', () {
    testWidgets(
      'The _titleStyle method falls back to Theme.textTheme.labelMedium '
      'when null',
      (tester) async {
        // We indirectly test _titleStyle by not providing a custom titleStyle.
        const customThemeData = StepProgressThemeData(
          stepAnimationDuration: Duration(milliseconds: 350),
          activeForegroundColor: Colors.blue,
          defaultForegroundColor: Colors.red,
        );
        await tester.pumpWidget(
          const TestThemeWrapper(
            themeData: customThemeData,
            child: StepLabel(title: 'Fallback TitleStyle'),
          ),
        );
        // The AnimatedDefaultTextStyle widget used should have style similar
        // to Theme.of(context).textTheme.labelMedium.
        final widgetTitle = tester.widget<AnimatedDefaultTextStyle>(
          find
              .descendant(
                of: find.byType(StepLabel),
                matching: find.byType(AnimatedDefaultTextStyle),
              )
              .first,
        );
        final expectedStyle =
            Theme.of(
              tester.element(find.byType(StepLabel)),
            ).textTheme.labelMedium;
        expect(widgetTitle.style.fontSize, expectedStyle?.fontSize);
      },
    );

    testWidgets(
      'The _subTitleStyle method falls back to Theme.textTheme.labelSmall '
      'when null',
      (tester) async {
        // Similar test for subTitleStyle fallback.
        const customThemeData = StepProgressThemeData(
          stepAnimationDuration: Duration(milliseconds: 350),
          activeForegroundColor: Colors.blue,
          defaultForegroundColor: Colors.red,
        );
        await tester.pumpWidget(
          const TestThemeWrapper(
            themeData: customThemeData,
            child: StepLabel(subTitle: 'Fallback SubTitleStyle'),
          ),
        );
        final widgetSubTitle = tester.widget<AnimatedDefaultTextStyle>(
          find
              .descendant(
                of: find.byType(StepLabel),
                matching: find.byType(AnimatedDefaultTextStyle),
              )
              .first,
        );
        final expectedStyle =
            Theme.of(
              tester.element(find.byType(StepLabel)),
            ).textTheme.labelSmall;
        expect(widgetSubTitle.style.fontSize, expectedStyle?.fontSize);
      },
    );
  });
}
