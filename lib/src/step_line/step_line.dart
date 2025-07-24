import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:step_progress/src/step_line/breadcrumb_clipper.dart';
import 'package:step_progress/src/step_line/step_value_line.dart';
import 'package:step_progress/step_progress.dart';

/// A widget that represents a step line in a step progress indicator.
///
/// The [StepLine] widget is used to display a line that connects steps in a
/// step progress indicator. It can be oriented either horizontally or
/// vertically, and its appearance can be customized using the
/// `stepLineStyle` parameter.
///
/// The [stepLineStyle] parameter allows customization of the step line's
/// appearance.
///
/// The [highlighted] parameter indicates whether the step line is highlighted
/// or not.
///
/// The [axis] parameter specifies the orientation of the step line. It defaults
/// to [Axis.horizontal].
///
/// The [highlighted] parameter indicates whether the step line is active. It
/// defaults to `false`.
///
/// The [isReversed] parameter indicates whether the step line is displayed in
/// reverse order. It defaults to `false`.
///
/// The [isCurrentStep] parameter indicates whether this step is the current
/// active step. It defaults to `false`.
///
/// The [isAutoStepChange] parameter determines if the step progression advances
///  automatically. It defaults to `false`.
///
/// The [onTap] parameter is a callback function that is executed when the step
/// line is tapped. It is optional and defaults to `null`.
///
/// The [onStepLineAnimationCompleted] parameter is a callback that is
/// triggered when the step line's animation completes. It is optional
/// and defaults to `null`.
///
/// Example usage:
///
/// ```dart
/// StepLine(
///   axis: Axis.vertical,
///   highlighted: true,
///   isReversed: true,
///   isCurrentStep: true,
///   isAutoStepChange: false,
///   stepLineStyle: StepLineStyle(
///     color: Colors.blue,
///     thickness: 2.0,
///   ),
///   onTap: () {
///     print('Step line tapped');
///   },
///   onStepLineAnimationCompleted: () {
///     print('Line animation completed');
///   },
/// )
/// ```
class StepLine extends StatelessWidget {
  const StepLine({
    this.isCurrentStep = false,
    this.isAutoStepChange = false,
    this.axis = Axis.horizontal,
    this.stepLineStyle,
    this.highlighted = false,
    this.isReversed = false,
    this.onStepLineAnimationCompleted,
    this.onTap,
    super.key,
  });

  /// The axis in which the step line is oriented.
  final Axis axis;

  /// Indicates whether the step line is active.
  final bool highlighted;

  /// Callback function to be executed when the step line is tapped.
  final VoidCallback? onTap;

  /// The style of the step line.
  final StepLineStyle? stepLineStyle;

  /// Indicates whether the step line is displayed in reverse order.
  final bool isReversed;

  /// Callback triggered when the line animation completed.
  final VoidCallback? onStepLineAnimationCompleted;

  /// Indicates whether this step is the current active step.
  final bool isCurrentStep;

  /// Determines if step changes occur automatically.
  final bool isAutoStepChange;

  @override
  Widget build(BuildContext context) {
    final theme = StepProgressTheme.of(context)!.data;
    final style = stepLineStyle ?? theme.stepLineStyle;
    final isBreadcrumb = style.isBreadcrumb;
    final borderStyle = style.borderStyle ?? theme.borderStyle;
    final borderRadius = style.borderRadius;
    //
    final activeColor = style.activeColor ?? theme.activeForegroundColor;

    final lineSpacing = EdgeInsets.symmetric(
      horizontal: _isHorizontal ? theme.stepLineSpacing : 0,
      vertical: !_isHorizontal ? theme.stepLineSpacing : 0,
    );

    final containerDecoration = BoxDecoration(
      color: style.foregroundColor ?? theme.defaultForegroundColor,
      borderRadius: BorderRadius.all(borderRadius),
      border: borderStyle != null && !borderStyle.isDotted
          ? Border.all(
              color: highlighted
                  ? borderStyle.activeBorderColor
                  : borderStyle.defaultBorderColor,
              width: borderStyle.borderWidth,
              strokeAlign: BorderSide.strokeAlignOutside,
            )
          : null,
    );

    Widget buildLineWidget(BoxConstraints constraint) {
      final lineSize = Size(
        _width(constraint, style.lineThickness),
        _height(constraint, style.lineThickness),
      );

      Widget lineWidget = Container(
        width: lineSize.width,
        height: lineSize.height,
        decoration: containerDecoration,
        alignment: _isHorizontal
            ? (isReversed
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart)
            : (isReversed
                ? AlignmentDirectional.bottomEnd
                : AlignmentDirectional.topStart),
        child: isCurrentStep && isAutoStepChange
            ? StepValueLine(
                duration:
                    style.animationDuration ?? theme.stepAnimationDuration,
                activeColor: activeColor,
                borderRadius: borderRadius,
                lineSize: lineSize,
                highlighted: highlighted,
                isHorizontal: _isHorizontal,
                onAnimationCompleted: onStepLineAnimationCompleted,
              )
            : Container(
                width: _isHorizontal
                    ? (highlighted ? lineSize.width : 0)
                    : lineSize.width,
                height: !_isHorizontal
                    ? (highlighted ? lineSize.height : 0)
                    : lineSize.height,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.all(borderRadius),
                ),
              ),
      );

      if (isBreadcrumb) {
        final breadcrumbClipper = BreadcrumbClipper(
          angle: style.chevronAngle,
          axis: axis,
          isReversed: isReversed,
        );
        lineWidget = ClipPath(clipper: breadcrumbClipper, child: lineWidget);
      }

      if (borderStyle?.isDotted ?? false) {
        lineWidget = DottedBorder(
          options: isBreadcrumb
              ? CustomPathDottedBorderOptions(
                  strokeWidth: borderStyle!.borderWidth,
                  dashPattern: borderStyle.dashPattern,
                  color: highlighted
                      ? borderStyle.activeBorderColor
                      : borderStyle.defaultBorderColor,
                  padding: EdgeInsets.all(borderStyle.borderWidth / 2),
                  strokeCap: StrokeCap.round,
                  customPath: (size) => BreadcrumbClipper(
                    angle: style.chevronAngle,
                    axis: axis,
                    isReversed: isReversed,
                  ).getClip(size),
                )
              : RectDottedBorderOptions(
                  strokeWidth: borderStyle!.borderWidth,
                  dashPattern: borderStyle.dashPattern,
                  color: highlighted
                      ? borderStyle.activeBorderColor
                      : borderStyle.defaultBorderColor,
                  padding: EdgeInsets.all(borderStyle.borderWidth / 2),
                  strokeCap: StrokeCap.round,
                ),
          child: lineWidget,
        );
      }

      return lineWidget;
    }

    return Expanded(
      child: LayoutBuilder(
        builder: (_, constraint) => Padding(
          padding: lineSpacing,
          child: GestureDetector(
            onTap: onTap,
            child: buildLineWidget(constraint),
          ),
        ),
      ),
    );
  }

  bool get _isHorizontal => axis == Axis.horizontal;

  /// Calculates the width of the step line based on the given constraints and
  /// axis.
  ///
  /// If the axis is horizontal, it returns the constrained width from the given
  /// [BoxConstraints]. Otherwise, it returns the line thickness.
  ///
  /// - Parameter constraint: The constraints to apply when calculating the
  /// width.
  /// - Returns: The calculated width of the step line.
  double _width(BoxConstraints constraint, double lineThickness) {
    return axis == Axis.horizontal
        ? constraint.constrainWidth()
        : lineThickness;
  }

  /// Calculates the height based on the given constraints and the axis
  /// orientation.
  ///
  /// If the axis is vertical, it returns the constrained height of the box.
  /// If the axis is horizontal, it returns the line thickness.
  ///
  /// - Parameter constraint: The constraints of the box.
  /// - Returns: The calculated height based on the axis orientation and
  /// constraints.
  double _height(BoxConstraints constraint, double lineThickness) {
    return axis == Axis.vertical ? constraint.constrainHeight() : lineThickness;
  }
}
