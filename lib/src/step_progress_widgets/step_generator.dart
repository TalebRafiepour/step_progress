import 'package:flutter/material.dart';
import 'package:step_progress/src/helpers/keep_size_visibility.dart';
import 'package:step_progress/src/step_label/step_label.dart';
import 'package:step_progress/src/step_node/step_node.dart';
import 'package:step_progress/src/step_node/step_node_ripple.dart';
import 'package:step_progress/step_progress.dart';

/// A widget that generates a step in a step progress indicator.
///
/// The [StepGenerator] widget is used to create a step with customizable
/// width, height, active state, axis, title, subtitle, an optional tap
/// callback, and icons for the step node.
///
/// The [width] and [height] parameters are required to define the size of the
/// step.
/// The [anyLabelExist] required to detect if any other step nodes contains
/// label.
/// The [isActive] parameter indicates whether the step is active or not, with
/// a default value of false.
/// The [axis] parameter specifies the orientation of the step, either
/// horizontal or vertical, with a default value of [Axis.horizontal].
/// The [title] and [subTitle] parameters are optional and can be used to
/// display additional information about the step.
/// The [onTap] parameter is an optional callback function that is triggered
/// when the widget is tapped.
/// The [stepNodeIcon] parameter is an optional widget to display inside the
/// `StepNode` by default.
/// The [stepNodeActiveIcon] parameter is an optional widget to display inside
/// the `StepNode` when the step is active.
/// The [stepIndex] parameter specifies the index of the current step in the
/// step progress.
///
/// Example usage:
/// ```dart
/// StepGenerator(
///   width: 50.0,
///   height: 50.0,
///   anyLabelExist: true,
///   stepIndex: 1,
///   isActive: true,
///   axis: Axis.vertical,
///   title: 'Step 1',
///   subTitle: 'Introduction',
///   onTap: () {
///     print('Step tapped');
///   },
///   stepNodeIcon: Icon(Icons.check),
///   stepNodeActiveIcon: Icon(Icons.check_circle),
/// )
/// ```
class StepGenerator extends StatelessWidget {
  const StepGenerator({
    required this.width,
    required this.height,
    required this.stepIndex,
    required this.anyLabelExist,
    this.isActive = false,
    this.axis = Axis.horizontal,
    this.title,
    this.subTitle,
    this.onTap,
    this.stepNodeIcon,
    this.stepNodeActiveIcon,
    super.key,
  });

  /// Indicates whether the step is active.
  final bool isActive;

  /// The axis along which the step is oriented.
  final Axis axis;

  /// The width of the step.
  final double width;

  /// The height of the step.
  final double height;

  /// The title of the step.
  final String? title;

  /// The subtitle of the step.
  final String? subTitle;

  /// A callback function triggered when the widget is tapped.
  final VoidCallback? onTap;

  /// Icon widget to display inside `StepNode` by default.
  final Widget? stepNodeIcon;

  /// Icon widget to display inside `StepNode` when the step is active.
  final Widget? stepNodeActiveIcon;

  /// The index of the current step in the step progress.
  final int stepIndex;

  /// This means any other step nodes has label or not
  final bool anyLabelExist;

  /// Builds a widget that represents a step in a step progress indicator.
  ///
  /// The widget can be displayed either vertically or horizontally based on the
  /// `axis` property. It supports an optional ripple effect around the step
  /// node and can display a title and subtitle.
  ///
  /// The appearance of the step node, label, and ripple effect is determined by
  /// the theme data provided by `StepProgressTheme`.
  ///
  /// - If `axis` is `Axis.vertical`, the step node and label are arranged in a
  /// row.
  /// - If `axis` is `Axis.horizontal`, the step node and label are arranged in
  /// a column.
  /// - If `enableRippleEffect` is true, a ripple effect is displayed around the
  /// step node.
  ///
  /// The widget uses the following properties from the theme data:
  /// - `enableRippleEffect`: Determines if the ripple effect is enabled.
  /// - `labelStyle`: The style for the step label.
  /// - `stepNodeStyle`: The style for the step node.
  /// - `shape`: The shape of the step node.
  /// - `rippleEffectStyle`: The style for the ripple effect.
  @override
  Widget build(BuildContext context) {
    final themeData = StepProgressTheme.of(context)!.data;

    Widget buildStepNode() {
      return Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (themeData.enableRippleEffect)
              StepNodeRipple(
                stepNodeShape: themeData.shape,
                style: themeData.rippleEffectStyle,
                width: width,
                height: height,
                isVisible: isActive,
              ),
            StepNode(
              width: themeData.enableRippleEffect ? width / 1.5 : width,
              height: themeData.enableRippleEffect ? height / 1.5 : height,
              isActive: isActive,
              icon: stepNodeIcon,
              activeIcon: stepNodeActiveIcon,
            ),
          ],
        ),
      );
    }

    Widget buildStepLabel() {
      if (title == null && subTitle == null) {
        if (anyLabelExist) {
          final style = themeData.labelStyle;
          return Container(
            padding: style.padding,
            margin: style.margin,
            alignment: Alignment.center,
            constraints: BoxConstraints(maxWidth: style.maxWidth),
          );
        } else {
          return const SizedBox.shrink();
        }
      }
      return StepLabel(title: title, subTitle: subTitle, isActive: isActive);
    }

    Widget buildStep({
      required bool isVertical,
      required bool showLabelFirst,
      bool isMultipleSide = false,
    }) {
      final children =
          isMultipleSide
              ? [
                KeepSizeVisibility(
                  visible: showLabelFirst,
                  child: buildStepLabel(),
                ),
                buildStepNode(),
                KeepSizeVisibility(
                  visible: !showLabelFirst,
                  child: buildStepLabel(),
                ),
              ]
              : [
                if (showLabelFirst) buildStepLabel(),
                buildStepNode(),
                if (!showLabelFirst) buildStepLabel(),
              ];

      return Directionality(
        textDirection: TextDirection.ltr,
        child:
            isVertical
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                )
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
      );
    }

    final labelAlignment =
        themeData.stepLabelAlignment ??
        (axis == Axis.horizontal
            ? StepLabelAlignment.top
            : StepLabelAlignment.right);

    return GestureDetector(
      onTap: onTap,
      child: Builder(
        builder: (context) {
          switch (labelAlignment) {
            case StepLabelAlignment.left:
              return buildStep(isVertical: true, showLabelFirst: true);
            case StepLabelAlignment.right:
              return buildStep(isVertical: true, showLabelFirst: false);
            case StepLabelAlignment.top:
              return buildStep(isVertical: false, showLabelFirst: true);
            case StepLabelAlignment.bottom:
              return buildStep(isVertical: false, showLabelFirst: false);
            case StepLabelAlignment.topBottom:
              return buildStep(
                isMultipleSide: true,
                isVertical: false,
                showLabelFirst: stepIndex.isEven,
              );
            case StepLabelAlignment.bottomTop:
              return buildStep(
                isVertical: false,
                isMultipleSide: true,
                showLabelFirst: stepIndex.isOdd,
              );

            case StepLabelAlignment.rightLeft:
              return buildStep(
                isMultipleSide: true,
                isVertical: true,
                showLabelFirst: stepIndex.isOdd,
              );
            case StepLabelAlignment.leftRight:
              return buildStep(
                isMultipleSide: true,
                isVertical: true,
                showLabelFirst: stepIndex.isEven,
              );
          }
        },
      ),
    );
  }
}
