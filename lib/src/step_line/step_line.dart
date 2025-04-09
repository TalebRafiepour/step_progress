import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:step_progress/src/step_line/breadcrumb_clipper.dart';
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
/// The [isActive] parameter indicates whether the step line is active or not.
///
/// The [axis] parameter specifies the orientation of the step line. It defaults
/// to [Axis.horizontal].
///
/// The [isActive] parameter indicates whether the step line is active. It
/// defaults to `false`.
///
/// The [isReversed] parameter indicates whether the step line is displayed in
/// reverse order. It defaults to `false`.
///
/// The [onTap] parameter is a callback function that is executed when the step
/// line is tapped. It is optional and defaults to `null`.
///
/// Example usage:
///
/// ```dart
/// StepLine(
///   axis: Axis.vertical,
///   isActive: true,
///   isReversed: true,
///   stepLineStyle: StepLineStyle(
///     color: Colors.blue,
///     thickness: 2.0,
///   ),
///   onTap: () {
///     print('Step line tapped');
///   },
/// )
/// ```
class StepLine extends StatelessWidget {
  const StepLine({
    this.axis = Axis.horizontal,
    this.stepLineStyle,
    this.isActive = false,
    this.isReversed = false,
    this.onTap,
    super.key,
  });

  /// The axis in which the step line is oriented.
  final Axis axis;

  /// Indicates whether the step line is active.
  final bool isActive;

  /// Callback function to be executed when the step line is tapped.
  final VoidCallback? onTap;

  /// The style of the step line.
  final StepLineStyle? stepLineStyle;

  /// Indicates whether the step line is displayed in reverse order.
  final bool isReversed;

  @override
  Widget build(BuildContext context) {
    final theme = StepProgressTheme.of(context)!.data;
    final style = stepLineStyle ?? theme.stepLineStyle;
    final isBreadcrumb = style.isBreadcrumb;
    final borderStyle = style.borderStyle ?? theme.borderStyle;
    final borderRadius = style.borderRadius;

    final lineSpacing = EdgeInsets.symmetric(
      horizontal: _isHorizontal ? theme.stepLineSpacing : 0,
      vertical: !_isHorizontal ? theme.stepLineSpacing : 0,
    );

    final containerDecoration = BoxDecoration(
      color: style.foregroundColor ?? theme.defaultForegroundColor,
      borderRadius: BorderRadius.all(borderRadius),
      border:
          borderStyle != null && !borderStyle.isDotted
              ? Border.all(
                color:
                    isActive
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
        alignment: AlignmentDirectional.centerStart,
        child: AnimatedContainer(
          width:
              _isHorizontal ? (isActive ? lineSize.width : 0) : lineSize.width,
          height:
              !_isHorizontal
                  ? (isActive ? lineSize.height : 0)
                  : lineSize.height,
          decoration: BoxDecoration(
            color: style.activeColor ?? theme.activeForegroundColor,
            borderRadius: BorderRadius.all(borderRadius),
          ),
          curve: Curves.fastLinearToSlowEaseIn,
          duration: style.animationDuration ?? theme.stepAnimationDuration,
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
          strokeWidth: borderStyle!.borderWidth,
          color:
              isActive
                  ? borderStyle.activeBorderColor
                  : borderStyle.defaultBorderColor,
          radius: borderRadius,
          padding: EdgeInsets.all(borderStyle.borderWidth / 2),
          strokeCap: StrokeCap.round,
          borderType: BorderType.RRect,
          dashPattern: borderStyle.dashPattern,
          customPath:
              isBreadcrumb
                  ? (size) => BreadcrumbClipper(
                    angle: style.chevronAngle,
                    axis: axis,
                    isReversed: isReversed,
                  ).getClip(size)
                  : null,
          child: lineWidget,
        );
      }

      return lineWidget;
    }

    return Expanded(
      child: LayoutBuilder(
        builder:
            (_, constraint) => Padding(
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
