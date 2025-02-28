import 'package:flutter/material.dart';
import 'package:step_progress/src/helpers/keep_size_visibility.dart';
import 'package:step_progress/src/step_line/step_line_label.dart';
import 'package:step_progress/src/step_line/step_line_style.dart';
import 'package:step_progress/src/step_progress_theme.dart';

/// A widget that represents a step line in a step progress indicator.
///
/// The [StepLine] widget is used to display a line that connects steps in a
/// step progress indicator. It can be oriented either horizontally or
/// vertically, and its appearance can be customized using the
/// [style] parameter.
///
/// The [isActive] parameter indicates whether the step line is active or not.
///
/// The [axis] parameter specifies the orientation of the step line. It defaults
/// to [Axis.horizontal].
///
/// The [style] parameter allows customization of the step line's appearance.
/// It defaults to an instance of [StepLineStyle].
///
/// The [isActive] parameter indicates whether the step line is active. It
/// defaults to `false`.
///
/// The [label] parameter provides a brief label that gives additional context
/// for the step line, such as a description of its purpose or status. It is
/// optional and defaults to `null`.
///
/// The [onTap] parameter is a callback function that is executed when the step
/// line is tapped. It is optional and defaults to `null`.
///
/// Example usage:
///
/// ```dart
/// StepLine(
///   axis: Axis.vertical,
///   label: 'Step 1',
///   style: StepLineStyle(
///     color: Colors.blue,
///     thickness: 2.0,
///   ),
///   isActive: true,
///   onTap: () {
///     print('Step line tapped');
///   },
/// )
/// ```
class StepLine extends StatelessWidget {
  const StepLine({
    this.axis = Axis.horizontal,
    this.style = const StepLineStyle(),
    this.isActive = false,
    this.label,
    this.onTap,
    super.key,
  });

  /// A brief label that is displayed on the step line.
  ///
  /// This label helps indicate the purpose or status of the step line,
  /// providing additional context to the user.
  final String? label;

  /// The axis in which the step line is oriented.
  final Axis axis;

  /// Indicates whether the step line is active.
  final bool isActive;

  /// The style of the step line.
  final StepLineStyle style;

  /// Callback function to be executed when the step line is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = StepProgressTheme.of(context)!.data;
    final borderWidth = theme.borderWidth;
    final borderColor = theme.borderColor;
    final activeBorderColor = theme.activeBorderColor;
    final Alignment lineLabelAlignment =
        theme.lineLabelAlignment ??
        (_isHorizontal ? Alignment.topCenter : Alignment.centerRight);
    //
    return Expanded(
      child: LayoutBuilder(
        builder: (_, constraint) {
          final padding = EdgeInsets.symmetric(
            horizontal: _isHorizontal ? theme.stepLineSpacing : 0,
            vertical: !_isHorizontal ? theme.stepLineSpacing : 0,
          );

          final containerDecoration = BoxDecoration(
            color: style.foregroundColor ?? theme.defaultForegroundColor,
            borderRadius: style.borderRadius,
            border:
                borderWidth > 0
                    ? Border.all(
                      color:
                          (isActive && activeBorderColor != null)
                              ? activeBorderColor
                              : borderColor,
                      width: borderWidth,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    )
                    : null,
          );

          final animatedContainerDecoration = BoxDecoration(
            color: style.activeColor ?? theme.activeForegroundColor,
            borderRadius: style.borderRadius,
          );

          final double animatedContainerWidth =
              _isHorizontal
                  ? (isActive ? _width(constraint) : 0)
                  : _width(constraint);

          final double animatedContainerHeight =
              _isHorizontal
                  ? _height(constraint)
                  : (isActive ? _height(constraint) : 0);

          final animationDuration =
              style.animationDuration ?? theme.stepAnimationDuration;
          Widget buildLineWidget() {
            return Padding(
              padding: padding,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: _width(constraint),
                  height: _height(constraint),
                  decoration: containerDecoration,
                  alignment: AlignmentDirectional.centerStart,
                  child: AnimatedContainer(
                    width: animatedContainerWidth,
                    height: animatedContainerHeight,
                    decoration: animatedContainerDecoration,
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: animationDuration,
                  ),
                ),
              ),
            );
          }

          if (label == null) {
            return buildLineWidget();
          } else if (_isHorizontal) {
            if (lineLabelAlignment == Alignment.topCenter ||
                lineLabelAlignment == Alignment.topRight ||
                lineLabelAlignment == Alignment.topLeft) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: lineLabelAlignment,
                    child: StepLineLabel(label: label!),
                  ),
                  buildLineWidget(),
                  KeepSizeVisibility(
                    visible: false,
                    child: StepLineLabel(label: label!),
                  ),
                ],
              );
            } else if (lineLabelAlignment == Alignment.bottomCenter ||
                lineLabelAlignment == Alignment.bottomRight ||
                lineLabelAlignment == Alignment.bottomLeft) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  KeepSizeVisibility(
                    visible: false,
                    child: StepLineLabel(label: label!),
                  ),
                  buildLineWidget(),
                  Align(
                    alignment: lineLabelAlignment,
                    child: StepLineLabel(label: label!),
                  ),
                ],
              );
            } else {
              return Stack(
                alignment: Alignment.center,
                children: [
                  buildLineWidget(),
                  Align(
                    alignment: lineLabelAlignment,
                    child: StepLineLabel(label: label!),
                  ),
                ],
              );
            }
          } else {
            if (lineLabelAlignment == Alignment.centerLeft ||
                lineLabelAlignment == Alignment.topLeft ||
                lineLabelAlignment == Alignment.bottomLeft) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: lineLabelAlignment,
                    child: StepLineLabel(label: label!),
                  ),
                  buildLineWidget(),
                  KeepSizeVisibility(
                    visible: false,
                    child: StepLineLabel(label: label!),
                  ),
                ],
              );
            } else if (lineLabelAlignment == Alignment.topRight ||
                lineLabelAlignment == Alignment.bottomRight ||
                lineLabelAlignment == Alignment.centerRight) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  KeepSizeVisibility(
                    visible: false,
                    child: StepLineLabel(label: label!),
                  ),
                  buildLineWidget(),
                  Align(
                    alignment: lineLabelAlignment,
                    child: StepLineLabel(label: label!),
                  ),
                ],
              );
            } else {
              return Stack(
                alignment: Alignment.center,
                children: [
                  buildLineWidget(),
                  Align(
                    alignment: lineLabelAlignment,
                    child: StepLineLabel(label: label!),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }

  bool get _isHorizontal => axis == Axis.horizontal;

  /// Calculates the width of the step line based on the given constraints and
  /// axis.
  ///
  /// If the axis is horizontal, it returns the constrained width from the given
  /// [BoxConstraints]. Otherwise, it returns the line thickness from the
  /// [style].
  ///
  /// - Parameter constraint: The constraints to apply when calculating the
  /// width.
  /// - Returns: The calculated width of the step line.
  double _width(BoxConstraints constraint) {
    return axis == Axis.horizontal
        ? constraint.constrainWidth()
        : style.lineThickness;
  }

  /// Calculates the height based on the given constraints and the axis
  /// orientation.
  ///
  /// If the axis is vertical, it returns the constrained height of the box.
  /// If the axis is horizontal, it returns the line thickness from the style.
  ///
  /// - Parameter constraint: The constraints of the box.
  /// - Returns: The calculated height based on the axis orientation and
  /// constraints.
  double _height(BoxConstraints constraint) {
    return axis == Axis.vertical
        ? constraint.constrainHeight()
        : style.lineThickness;
  }
}
