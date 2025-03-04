import 'package:flutter/material.dart';

/// A class that defines the style for a step label in a step progress widget.
///
/// This class can be used to customize the appearance of the step labels,
/// such as their text style, color, and other visual properties.
class StepLabelStyle {
  /// Creates a [StepLabelStyle] with the given properties.
  ///
  /// The [labelAxisAlignment] defaults to [CrossAxisAlignment.center].
  /// The [titleMaxLines] defaults to 3.
  /// The [subTitleMaxLines] defaults to 1.
  /// The [overflow] defaults to [TextOverflow.ellipsis].
  /// The [padding] defaults to [EdgeInsets.zero].
  /// The [textAlign] defaults to [TextAlign.center].
  /// The [margin] defaults to [EdgeInsets.all(2)].
  /// The [maxWidth] defaults to 80.
  const StepLabelStyle({
    this.labelAxisAlignment = CrossAxisAlignment.center,
    this.activeColor,
    this.defualtColor,
    this.titleStyle,
    this.subTitleStyle,
    this.titleMaxLines = 3,
    this.subTitleMaxLines = 3,
    this.overflow = TextOverflow.ellipsis,
    this.padding = EdgeInsets.zero,
    this.textAlign = TextAlign.center,
    this.maxWidth = 48,
    this.margin = const EdgeInsets.all(2),
    this.animationDuration,
  });

  /// The alignment of the label along the cross axis.
  final CrossAxisAlignment labelAxisAlignment;

  /// The style to use for the title text.
  final TextStyle? titleStyle;

  /// The style to use for the subtitle text.
  final TextStyle? subTitleStyle;

  /// The color to use when the step is active.
  final Color? activeColor;

  /// The color to use when the step is not active.
  final Color? defualtColor;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The maximum number of lines for the title text.
  final int titleMaxLines;

  /// The maximum width of the step label.
  final double maxWidth;

  /// The maximum number of lines for the subtitle text.
  final int subTitleMaxLines;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The amount of space to surround the label with.
  final EdgeInsets padding;

  /// The amount of space to surround the label with.
  final EdgeInsets margin;

  /// The duration of the animation when the style changes.
  final Duration? animationDuration;

  /// Creates a copy of this [StepLabelStyle] but with the given fields
  /// replaced with the new values.
  StepLabelStyle copyWith({
    CrossAxisAlignment? labelAxisAlignment,
    TextStyle? titleStyle,
    TextStyle? subTitleStyle,
    Color? activeColor,
    Color? defualtColor,
    TextAlign? textAlign,
    int? titleMaxLines,
    int? subTitleMaxLines,
    TextOverflow? overflow,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? maxWidth,
    Duration? animationDuration,
  }) {
    return StepLabelStyle(
      labelAxisAlignment: labelAxisAlignment ?? this.labelAxisAlignment,
      titleStyle: titleStyle ?? this.titleStyle,
      subTitleStyle: subTitleStyle ?? this.subTitleStyle,
      activeColor: activeColor ?? this.activeColor,
      defualtColor: defualtColor ?? this.defualtColor,
      textAlign: textAlign ?? this.textAlign,
      titleMaxLines: titleMaxLines ?? this.titleMaxLines,
      subTitleMaxLines: subTitleMaxLines ?? this.subTitleMaxLines,
      overflow: overflow ?? this.overflow,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      maxWidth: maxWidth ?? this.maxWidth,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }
}
