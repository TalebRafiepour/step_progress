import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

/// A class that defines the theme data for the Step Progress widget.
///
/// This class allows customization of various aspects of the Step Progress
/// widget, including colors, shapes, styles, and animations.
///
/// The following properties can be customized:
///
/// * [defaultForegroundColor]: The default color of the step nodes.
/// * [activeForegroundColor]: The color of the active step node.
/// * [enableRippleEffect]: Whether to enable the ripple effect on step nodes.
/// * [shape]: The shape of the step nodes (e.g., circle, square).
/// * [stepAnimationDuration]: The duration of the animation for step
/// transitions.
/// * [stepLineSpacing]: The spacing between step lines.
/// * [nodeLabelAlignment]: The alignment of the labels for the step nodes.
/// * [lineLabelAlignment]: The alignment of the labels for line segment.
/// * [nodeLabelStyle]: The style of the labels for the step nodes.
/// * [lineLabelStyle]: The style of the labels for the step lines.
/// * [stepNodeStyle]: The style of the step nodes.
/// * [stepLineStyle]: The style of the lines connecting the step nodes.
/// * [rippleEffectStyle]: The style of the ripple effect on step nodes.
/// * [borderStyle]: The style of the border around the step nodes.
class StepProgressThemeData {
  const StepProgressThemeData({
    this.defaultForegroundColor = const Color.fromARGB(255, 191, 196, 195),
    this.activeForegroundColor = const Color.fromARGB(255, 0, 167, 160),
    this.borderStyle,
    this.enableRippleEffect = false,
    this.shape = StepNodeShape.circle,
    this.stepAnimationDuration = const Duration(milliseconds: 150),
    this.stepLineSpacing = 0,
    this.nodeLabelAlignment,
    this.lineLabelAlignment,
    this.nodeLabelStyle = const StepLabelStyle(),
    this.lineLabelStyle = const StepLabelStyle(maxWidth: double.infinity),
    this.stepNodeStyle = const StepNodeStyle(),
    this.stepLineStyle = const StepLineStyle(),
    this.rippleEffectStyle = const RippleEffectStyle(),
  });

  /// The default color used for the foreground elements in the step progress.
  final Color defaultForegroundColor;

  /// The color of the foreground when the step is active.
  final Color activeForegroundColor;

  /// The duration of the step animation.
  final Duration stepAnimationDuration;

  /// Determines if the ripple effect is enabled.
  final bool enableRippleEffect;

  /// The shape of the step node in the step progress indicator.
  final StepNodeShape shape;

  /// The spacing between each step line in the progress indicator.
  final double stepLineSpacing;

  /// The style to be applied to the step node labels.
  final StepLabelStyle nodeLabelStyle;

  /// The style to be applied to the step line labels.
  final StepLabelStyle lineLabelStyle;

  /// Specifies the alignment of labels along the progress indicator's
  /// line segments.
  final Alignment? lineLabelAlignment;

  /// The style configuration for the step node.
  final StepNodeStyle stepNodeStyle;

  /// Defines the style for the step line in the step progress indicator.
  final StepLineStyle stepLineStyle;

  /// The style of the ripple effect for the step progress.
  final RippleEffectStyle rippleEffectStyle;

  /// Alignment of the step node labels in the step progress indicator.
  final StepLabelAlignment? nodeLabelAlignment;

  /// The style of the outer border for the step progress widget.
  final OuterBorderStyle? borderStyle;

  /// Creates a copy of this [StepProgressThemeData] but with the given fields
  /// replaced with the new values.
  ///
  /// The [copyWith] method allows you to create a new instance of
  /// [StepProgressThemeData] with some properties modified while keeping the
  /// rest of the properties unchanged.
  ///
  /// The parameters correspond to the properties of [StepProgressThemeData]:
  ///
  /// - [defaultForegroundColor]: The default color for the foreground elements.
  /// - [activeForegroundColor]: The color for the active foreground elements.
  /// - [stepAnimationDuration]: The duration of the step animation.
  /// - [enableRippleEffect]: Whether the ripple effect is enabled.
  /// - [shape]: The shape of the step nodes.
  /// - [stepLineSpacing]: The spacing between step lines.
  /// - [nodeLabelStyle]: The style of the step labels of nodes.
  /// - [lineLabelStyle]: The style of the step labels of lines.
  /// - [stepNodeStyle]: The style of the step nodes.
  /// - [stepLineStyle]: The style of the step lines.
  /// - [rippleEffectStyle]: The style of the ripple effect.
  /// - [highlightCompletedSteps]: Whether to highlight completed steps.
  /// - [nodeLabelAlignment]: The alignment of the step node labels.
  /// - [lineLabelAlignment]: The alignment of the line segment labels.
  /// - [borderStyle]: The style of the border around the step nodes.
  ///
  /// Returns a new instance of [StepProgressThemeData] with the updated values.
  StepProgressThemeData copyWith({
    Color? defaultForegroundColor,
    Color? activeForegroundColor,
    Duration? stepAnimationDuration,
    bool? enableRippleEffect,
    StepNodeShape? shape,
    double? stepLineSpacing,
    StepLabelStyle? nodeLabelStyle,
    StepLabelStyle? lineLabelStyle,
    StepNodeStyle? stepNodeStyle,
    StepLineStyle? stepLineStyle,
    RippleEffectStyle? rippleEffectStyle,
    bool? highlightCompletedSteps,
    StepLabelAlignment? nodeLabelAlignment,
    Alignment? lineLabelAlignment,
    OuterBorderStyle? borderStyle,
  }) {
    return StepProgressThemeData(
      defaultForegroundColor:
          defaultForegroundColor ?? this.defaultForegroundColor,
      activeForegroundColor:
          activeForegroundColor ?? this.activeForegroundColor,
      stepAnimationDuration:
          stepAnimationDuration ?? this.stepAnimationDuration,
      enableRippleEffect: enableRippleEffect ?? this.enableRippleEffect,
      shape: shape ?? this.shape,
      stepLineSpacing: stepLineSpacing ?? this.stepLineSpacing,
      nodeLabelStyle: nodeLabelStyle ?? this.nodeLabelStyle,
      lineLabelStyle: lineLabelStyle ?? this.lineLabelStyle,
      stepNodeStyle: stepNodeStyle ?? this.stepNodeStyle,
      stepLineStyle: stepLineStyle ?? this.stepLineStyle,
      rippleEffectStyle: rippleEffectStyle ?? this.rippleEffectStyle,
      nodeLabelAlignment: nodeLabelAlignment ?? this.nodeLabelAlignment,
      lineLabelAlignment: lineLabelAlignment ?? this.lineLabelAlignment,
      borderStyle: borderStyle ?? this.borderStyle,
    );
  }
}
