import 'package:flutter/material.dart';
import 'package:step_progress/src/step_label/step_label_style.dart';
import 'package:step_progress/src/step_progress_theme.dart';

/// A widget that displays a label for a step in a step progress indicator.
///
/// The [StepLabel] widget can display a title and a subtitle, and can be styled
/// using the [StepLabelStyle]. It also has an option to indicate whether the
/// step is active.
///
/// The [title] and [subTitle] are optional and can be used to provide
/// additional information about the step. The [isActive] flag indicates whether
/// the step is currently active, and defaults to `false`.
///
/// The [style] property allows you to customize the appearance of the label,
/// including text styles, colors, and other visual properties.
///
/// Example usage:
///
/// ```dart
/// StepLabel(
///   style: StepLabelStyle(),
///   alignment: Alignment.center,
///   title: 'Step 1',
///   subTitle: 'Introduction',
///   isActive: true,
/// )
/// ```
class StepLabel extends StatelessWidget {
  const StepLabel({
    this.style = const StepLabelStyle(),
    this.alignment = Alignment.center,
    this.customLabel,
    this.title,
    this.subTitle,
    this.isActive = false,
    super.key,
  });

  /// The title of the step label.
  final String? title;

  /// The subtitle of the step label.
  final String? subTitle;

  /// Indicates whether the step label is active.
  final bool isActive;

  /// The style to appliy on label
  final StepLabelStyle style;

  /// The alignment for whole label
  final Alignment alignment;

  /// A custom widget to display as the label for the step.
  ///
  /// If a custom label widget is provided, it takes priority over the title and
  /// subtitle.
  final Widget? customLabel;

  @override
  Widget build(BuildContext context) {
    final theme = StepProgressTheme.of(context)!.data;
    //
    return Container(
      padding: style.padding,
      margin: style.margin,
      alignment: alignment,
      constraints: BoxConstraints(maxWidth: style.maxWidth),
      child: customLabel != null
          ? customLabel!
          : (title == null && subTitle == null)
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: style.labelAxisAlignment,
              children: [
                if (title != null)
                  AnimatedDefaultTextStyle(
                    duration:
                        style.animationDuration ?? theme.stepAnimationDuration,
                    style: _titleStyle(style.titleStyle, context).copyWith(
                      color: isActive
                          ? style.activeColor ?? theme.activeForegroundColor
                          : style.defualtColor ?? theme.defaultForegroundColor,
                    ),
                    child: Text(
                      title!,
                      textAlign: style.textAlign,
                      overflow: style.overflow,
                      maxLines: style.titleMaxLines,
                    ),
                  ),
                if (subTitle != null)
                  AnimatedDefaultTextStyle(
                    duration:
                        style.animationDuration ?? theme.stepAnimationDuration,
                    style: _subTitleStyle(style.subTitleStyle, context)
                        .copyWith(
                          color: isActive
                              ? style.activeColor ?? theme.activeForegroundColor
                              : style.defualtColor ??
                                    theme.defaultForegroundColor,
                        ),
                    child: Text(
                      subTitle!,
                      textAlign: style.textAlign,
                      overflow: style.overflow,
                      maxLines: style.subTitleMaxLines,
                    ),
                  ),
              ],
            ),
    );
  }

  /// Returns the text style for the title. If a custom title style is provided,
  /// it will be used. Otherwise, it falls back to the `labelMedium` text style
  /// from the current theme. If neither is available, it returns a default
  /// `TextStyle`.
  ///
  /// This method is used to ensure that the title text style is consistently
  /// applied throughout the application, with a preference for custom styles
  /// when available.
  ///
  TextStyle _titleStyle(TextStyle? titleStyle, BuildContext context) {
    return titleStyle ??
        Theme.of(context).textTheme.labelMedium ??
        const TextStyle();
  }

  /// Returns the text style for the subtitle of a step label.
  ///
  /// The style is determined in the following order:
  /// 1. If `style.subTitleStyle` is not null, it is used.
  /// 2. Otherwise, if the theme's `labelSmall` text style is not null, it is
  /// used.
  /// 3. If neither of the above conditions are met, a default text style with
  /// a font size of 10 is used.
  ///
  TextStyle _subTitleStyle(TextStyle? subTitleStyle, BuildContext context) {
    return subTitleStyle ??
        Theme.of(context).textTheme.labelSmall ??
        const TextStyle(fontSize: 10);
  }
}
