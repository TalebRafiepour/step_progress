import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

/// A class that defines the style for a step node in a step progress indicator.
///
/// The [StepNodeStyle] class allows customization of various aspects of the
/// step node's appearance, including colors, shapes, icons, and animations.
///
/// The following properties can be customized:
///
/// * [defaultForegroundColor]: The default color of the step node's foreground.
/// * [activeForegroundColor]: The color of the step node's foreground when it
/// is active.
/// * [animationDuration]: The duration of the animation when the step node
/// changes state.
/// * [shape]: The shape of the step node.
/// * [decoration]: The decoration of the step node. Defaults to a
/// [BoxDecoration] with a semi-transparent white color.
/// * [activeDecoration]: The decoration of the step node when it is active.
/// * [icon]: The icon to display inside the step node.
/// * [activeIcon]: The icon to display inside the step node when it is active.
/// Defaults to a check icon.
/// * [iconColor]: The color of the icon inside the step node. Defaults to a
/// teal color.
/// * [enableRippleEffect]: Whether to enable the ripple effect on the step
/// node. Defaults to true.
/// * [borderStyle]: The style of the outer border for the step node.
class StepNodeStyle {
  const StepNodeStyle({
    this.defaultForegroundColor,
    this.activeForegroundColor,
    this.animationDuration,
    this.shape,
    this.decoration = const BoxDecoration(
      color: Color.fromARGB(50, 255, 255, 255),
    ),
    this.activeDecoration,
    this.icon,
    this.activeIcon = const Icon(Icons.check, size: 18, color: Colors.white),
    this.iconColor = const Color.fromARGB(253, 6, 138, 129),
    this.enableRippleEffect = true,
    this.borderStyle,
  });

  /// The default color for the foreground of the step node.
  /// If not set, it will be read from the theme.
  final Color? defaultForegroundColor;

  /// The color for the foreground of the step node when it is active.
  /// If not set, it will be read from the theme.
  final Color? activeForegroundColor;

  /// The duration of the animation for the step node.
  /// If not set, it will be read from the theme.
  final Duration? animationDuration;

  /// The color of the icon.
  final Color iconColor;

  /// The shape of the step node.
  final StepNodeShape? shape;

  /// The decoration of the step node.
  final BoxDecoration decoration;

  /// The decoration of the step node when it is active.
  final BoxDecoration? activeDecoration;

  /// The icon widget to display.
  final Widget? icon;

  /// The icon widget to display when the step is active.
  final Widget? activeIcon;

  /// Whether to enable the ripple effect.
  final bool enableRippleEffect;

  /// The style of the outer border for the step node.
  final OuterBorderStyle? borderStyle;

  /// Creates a copy of this [StepNodeStyle] but with the given fields replaced
  /// with the new values.
  ///
  /// If a field is not provided, the value from the current instance is used.
  ///
  /// - [defaultForegroundColor]: The default color for the foreground.
  /// - [activeForegroundColor]: The color for the foreground when active.
  /// - [iconColor]: The color of the icon.
  /// - [shape]: The shape of the step node.
  /// - [decoration]: The decoration for the step node.
  /// - [activeDecoration]: The decoration for the step node when active.
  /// - [icon]: The icon widget.
  /// - [activeIcon]: The icon widget when active.
  /// - [enableRippleEffect]: Whether to enable the ripple effect.
  /// - [animationDuration]: The duration of the animation.
  /// - [borderStyle]: The style of the border for the step node.
  StepNodeStyle copyWith({
    Color? defaultForegroundColor,
    Color? activeForegroundColor,
    Color? iconColor,
    StepNodeShape? shape,
    BoxDecoration? decoration,
    BoxDecoration? activeDecoration,
    Widget? icon,
    Widget? activeIcon,
    bool? enableRippleEffect,
    Duration? animationDuration,
    OuterBorderStyle? borderStyle,
  }) {
    return StepNodeStyle(
      defaultForegroundColor:
          defaultForegroundColor ?? this.defaultForegroundColor,
      activeForegroundColor:
          activeForegroundColor ?? this.activeForegroundColor,
      iconColor: iconColor ?? this.iconColor,
      shape: shape ?? this.shape,
      decoration: decoration ?? this.decoration,
      activeDecoration: activeDecoration ?? this.activeDecoration,
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      enableRippleEffect: enableRippleEffect ?? this.enableRippleEffect,
      animationDuration: animationDuration ?? this.animationDuration,
      borderStyle: borderStyle ?? this.borderStyle,
    );
  }
}
