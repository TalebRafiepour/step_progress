import 'package:flutter/material.dart';
import 'package:step_progress/src/outter_border_style.dart';

/// A class that defines the style for a step line in a step progress.
///
/// This class can be used to customize the appearance of the step lines,
/// such as their color, thickness, and other visual properties.
class StepLineStyle {
  const StepLineStyle({
    this.lineThickness = 4,
    this.isBreadcrumb = false,
    this.chevronAngle = 30,
    this.foregroundColor,
    this.activeColor,
    this.animationDuration,
    this.borderStyle,
    this.borderRadius = Radius.zero,
  }) : assert(
         lineThickness >= 0,
         'lineThickness must be equal or greater than 0',
       );

  /// The color of the foreground elements. If not set, it will be
  /// determined by the theme.
  final Color? foregroundColor;

  /// The color used when the step is active. If not set, it will be
  /// determined by the theme.
  final Color? activeColor;

  /// The duration of the animation. If not set, it will be determined
  /// by the theme.
  final Duration? animationDuration;

  /// The thickness of the line in the step progress.
  final double lineThickness;

  /// Indicates whether the step line is displayed as a breadcrumb.
  final bool isBreadcrumb;

  /// Specifies the angle of the chevron in the step line.
  final double chevronAngle;

  /// The style of the outer border for the step line.
  final OuterBorderStyle? borderStyle;

  /// The radius of the border corners for the step line.
  final Radius borderRadius;

  /// Creates a copy of this [StepLineStyle] but with the given fields replaced
  /// with the new values.
  ///
  /// The optional parameters allow you to override the properties of the
  /// [StepLineStyle] instance. If a parameter is not provided, the value from
  /// the current instance will be used.
  ///
  /// - `foregroundColor`: The color of the foreground elements.
  /// - `activeColor`: The color used when the step is active.
  /// - `animationDuration`: The duration of the animation.
  /// - `lineThickness`: The thickness of the step line.
  /// - `borderRadius`: The border radius of the step line.
  /// - `isBreadcrumb`: Indicates whether the step line is displayed as a
  /// breadcrumb.
  /// - `chevronAngle`: Specifies the angle of the chevron in the step line.
  /// - `borderStyle`: Defines the style of the border for the step line.
  StepLineStyle copyWith({
    Color? foregroundColor,
    Color? activeColor,
    Duration? animationDuration,
    double? lineThickness,
    bool? isBreadcrumb,
    double? chevronAngle,
    OuterBorderStyle? borderStyle,
    Radius? borderRadius,
  }) {
    return StepLineStyle(
      foregroundColor: foregroundColor ?? this.foregroundColor,
      activeColor: activeColor ?? this.activeColor,
      animationDuration: animationDuration ?? this.animationDuration,
      lineThickness: lineThickness ?? this.lineThickness,
      isBreadcrumb: isBreadcrumb ?? this.isBreadcrumb,
      chevronAngle: chevronAngle ?? this.chevronAngle,
      borderStyle: borderStyle ?? this.borderStyle,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}
