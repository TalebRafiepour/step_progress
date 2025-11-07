import 'dart:math';

import 'package:flutter/material.dart';
import 'package:step_progress/src/helpers/rendering_box_widget.dart';
import 'package:step_progress/src/step_label/step_label_style.dart';
import 'package:step_progress/src/step_label_alignment.dart';
import 'package:step_progress/src/step_line/step_line_style.dart';
import 'package:step_progress/src/step_progress.dart';
import 'package:step_progress/src/step_progress_controller.dart';
import 'package:step_progress/src/step_progress_highlight_options.dart';
import 'package:step_progress/src/step_progress_theme.dart';
import 'package:step_progress/src/step_progress_visibility_options.dart';

/// Signature for a callback that is invoked when the step line animation is
/// completed.
///
/// [index] is the index of the step whose animation has completed.
typedef OnStepLineAnimationCompleted = void Function({
  int index,
});

/// An abstract class representing a step progress widget.
///
/// This widget displays a progress indicator with multiple steps, allowing for
/// customization of titles, subtitles, and tap events for each step.
///
/// The [StepProgressWidget] class extends [StatelessWidget] and requires the
/// total number of steps, the current step, and the size of each step. It also
/// provides options for customizing the appearance and behavior of the steps.
///
/// Parameters:
/// - [totalSteps]: The total number of steps in the progress indicator.
/// - [currentStep]: The current step in the progress indicator.
/// - [stepSize]: The size of each step in the progress indicator.
/// - [nodeTitles]: An optional list of titles for each step.
/// - [lineTitles]: An optional list of titles for each line segment.
/// - [lineSubTitles]: An optional list of subtitles for each line segment.
/// - [axis]: The axis in which the step progress is laid out
///   (horizontal or vertical).
/// - [visibilityOptions]: Options to control the visibility of elements.
/// - [nodeSubTitles]: An optional list of subtitles for each step.
/// - [onStepNodeTapped]: An optional callback function triggered when a step
///   node is tapped.
/// - [onStepLineTapped]: An optional callback function triggered when a step
///   line is tapped.
/// - [onStepLineAnimationCompleted]: An optional callback function triggered
///   when a step line is highlighted.
/// - [nodeIconBuilder]: An optional builder for the icon of a step node.
/// - [nodeLabelBuilder]: A builder for creating custom label widgets for
///   step nodes.
/// - [lineLabelBuilder]: A builder for creating custom label widgets for step
///   lines.
/// - [reversed]: Indicates whether the step progress is displayed in reverse
///   order. It defaults to false.
/// - [needsRebuildWidget]: Callback to request a rebuild of the parent widget.
///   This is triggered when dynamic size calculations are needed.
/// - [highlightOptions]: Options to customize the highlight behavior of the
///   step progress widget.
/// - [controller]: Optional controller to manage and update the step progress
/// state.
/// - [hasEqualNodeAndLineCount]: Indicates whether the number of nodes and
///   lines are equal in the step progress widget.
abstract class StepProgressWidget extends StatelessWidget {
  const StepProgressWidget({
    required this.totalSteps,
    required this.currentStep,
    required this.stepSize,
    required this.axis,
    required this.visibilityOptions,
    required this.needsRebuildWidget,
    this.hasEqualNodeAndLineCount = false,
    this.highlightOptions =
        StepProgressHighlightOptions.highlightCompletedNodesAndLines,
    this.controller,
    this.onStepLineAnimationCompleted,
    this.isAutoStepChange = false,
    this.reversed = false,
    this.nodeTitles,
    this.nodeSubTitles,
    this.lineTitles,
    this.lineSubTitles,
    this.onStepNodeTapped,
    this.onStepLineTapped,
    this.nodeIconBuilder,
    this.nodeLabelBuilder,
    this.lineLabelBuilder,
    super.key,
  })  : assert(
          nodeTitles == null || nodeTitles.length <= totalSteps,
          'nodeTitles lenght must be equals to or less than total steps',
        ),
        assert(
          nodeSubTitles == null || nodeSubTitles.length <= totalSteps,
          'nodeSubTitles lenght must be equals to or less than total steps',
        ),
        assert(
          lineTitles == null || lineTitles.length <= totalSteps,
          'lineTitles lenght must be equals to or less than total steps',
        ),
        assert(
          lineSubTitles == null || lineSubTitles.length <= totalSteps,
          'lineSubTitles lenght must be equals to or less than total steps',
        );

  /// The total number of steps in the progress indicator.
  final int totalSteps;

  /// The current step that is active or completed.
  final int currentStep;

  /// Determines if the step changes automatically without user interaction.
  final bool isAutoStepChange;

  /// The size of each step in the progress indicator.
  final double stepSize;

  /// Indicates whether the number of nodes equals the number of lines.
  final bool hasEqualNodeAndLineCount;

  /// The titles for each step node, if any.
  final List<String>? nodeTitles;

  /// The subtitles for each step node, if any.
  final List<String>? nodeSubTitles;

  /// The titles for each line segment in the progress indicator.
  final List<String>? lineTitles;

  /// The subTitles for each line segment in the progress indicator.
  final List<String>? lineSubTitles;

  /// Callback function when a step is tapped.
  final OnStepNodeTapped? onStepNodeTapped;

  /// Callback function that is triggered when a step line is tapped.
  final OnStepLineTapped? onStepLineTapped;

  /// The axis in which the step progress is laid out (horizontal or vertical).
  final Axis axis;

  /// Options to control the visibility of step progress elements.
  final StepProgressVisibilityOptions visibilityOptions;

  /// Builder for the icon of a step node.
  final StepNodeIconBuilder? nodeIconBuilder;

  /// A builder for creating custom label widgets for step nodes.
  final StepLabelBuilder? nodeLabelBuilder;

  /// A builder for creating custom label widgets for step lines.
  final StepLabelBuilder? lineLabelBuilder;

  /// Indicates whether the step progress is displayed in reverse order.
  final bool reversed;

  /// Callback to request a rebuild of the parent widget. This is triggered when
  /// dynamic size calculations are needed.
  final VoidCallback needsRebuildWidget;

  /// Options to customize the highlight behavior of the step progress widget.
  final StepProgressHighlightOptions highlightOptions;

  /// Callback triggered when the step line animation completes.
  final OnStepLineAnimationCompleted? onStepLineAnimationCompleted;

  /// Optional controller to manage and update the step progress state.
  final StepProgressController? controller;

  /// Returns `true` if the progress widget should start with a line.
  ///
  /// This is determined by checking if [visibilityOptions] is set to either
  /// [StepProgressVisibilityOptions.lineOnly] or
  /// [StepProgressVisibilityOptions.lineThenNode].
  bool get isStartWithLine =>
      visibilityOptions == StepProgressVisibilityOptions.lineOnly ||
      visibilityOptions == StepProgressVisibilityOptions.lineThenNode;

  /// Determines if a step line at the given index should be highlighted
  /// based on the current step and highlight options.
  bool isHighlightedStepLine(int index) {
    final shouldHighlightCompleted = highlightOptions ==
            StepProgressHighlightOptions.highlightCompletedLines ||
        highlightOptions ==
            StepProgressHighlightOptions.highlightCompletedNodesAndLines;

    final shouldHighlightCurrent =
        highlightOptions == StepProgressHighlightOptions.highlightCurrentLine ||
            highlightOptions ==
                StepProgressHighlightOptions.highlightCurrentNodeAndLine;

    final isStartWithLineOrEqualCount =
        isStartWithLine || hasEqualNodeAndLineCount;

    if (shouldHighlightCompleted) {
      return isStartWithLineOrEqualCount
          ? index <= currentStep
          : index < currentStep;
    }

    if (shouldHighlightCurrent) {
      return isStartWithLineOrEqualCount
          ? index == currentStep
          : index == currentStep - 1;
    }

    return false;
  }

  /// Determines if a step node at a given index should be highlighted.
  /// The highlighting behavior depends on the specified highlight options.
  bool isHighlightedStepNode(int index) {
    final isStartWithLineAndUnequalCount =
        isStartWithLine && !hasEqualNodeAndLineCount;

    switch (highlightOptions) {
      case StepProgressHighlightOptions.highlightCompletedNodes:
      case StepProgressHighlightOptions.highlightCompletedNodesAndLines:
        return isStartWithLineAndUnequalCount
            ? index < currentStep
            : index <= currentStep;

      case StepProgressHighlightOptions.highlightCurrentNode:
      case StepProgressHighlightOptions.highlightCurrentNodeAndLine:
        return isStartWithLineAndUnequalCount
            ? index == currentStep - 1
            : index == currentStep;
      case StepProgressHighlightOptions.highlightCurrentLine:
      case StepProgressHighlightOptions.highlightCompletedLines:
        return false;
    }
  }

  /// Determine if the step nodes have associated labels.
  bool get hasNodeLabels =>
      (nodeTitles != null && nodeTitles!.isNotEmpty) ||
      (nodeSubTitles != null && nodeSubTitles!.isNotEmpty) ||
      nodeLabelBuilder != null;

  /// Indicates whether the step progress widget has line labels.
  bool get hasLineLabels =>
      (lineTitles != null && lineTitles!.isNotEmpty) ||
      (lineSubTitles != null && lineSubTitles!.isNotEmpty) ||
      lineLabelBuilder != null;

  /// Builds the step nodes widget.
  ///
  /// This method should be implemented to create the visual representation
  /// of the step nodes in the step progress widget.
  ///
  /// The [labelAlignment] parameters indicates the alignment of labels.
  /// [lineSpacing] defines the spacing between step lines.
  /// [maxStepSize] determines the maximum size of a step node.
  /// [labelMaxWidth] is the maximum width allowed for the label widget.
  Widget buildStepNodes({
    required StepLabelAlignment labelAlignment,
    required double lineSpacing,
    required Size maxStepSize,
    required double labelMaxWidth,
  });

  /// Builds the step lines widget with the given style.
  ///
  /// This method should be implemented to create the visual representation
  /// of the lines connecting the step nodes in the step progress widget.
  ///
  /// [style] defines the appearance and style of the step lines.
  /// [maxStepSize] is the maximum size of the step nodes.
  Widget buildStepLines({
    required StepLineStyle style,
    required Size maxStepSize,
    ValueNotifier<RenderBox?>? boxNotifier,
  });

  /// Builds the labels for the step lines in the step progress widget.
  ///
  /// This method is responsible for creating the labels that are displayed
  /// alongside the step lines in the step progress widget.
  ///
  /// The [context] parameter is required and provides the build context
  /// in which the widget is built.
  ///
  /// Returns a [Widget] that represents the labels for the step lines.
  Widget buildStepLineLabels({required BuildContext context});

  /// Returns the alignment for the stack based on the provided
  /// [stepLabelAlignment].
  ///
  /// The [stepLabelAlignment] parameter is required and determines the
  /// alignment of the step label within the stack.
  ///
  /// - [stepLabelAlignment]: The alignment of the step node label.
  ///
  /// Returns an [Alignment] object that specifies the alignment for the stack.
  Alignment getStackAlignment({required StepLabelAlignment stepLabelAlignment});

  /// Returns the box constraints based on the provided constraints.
  /// This method is required to be implemented.
  BoxConstraints getBoxConstraint({required BoxConstraints constraints});

  /// Returns the total number of line segments to display in the step
  /// progress widget.
  ///
  /// If [isStartWithLine] is `true`, the total number of lines equals
  /// [totalSteps].Otherwise, it is one less than [totalSteps], as lines
  /// connect steps.
  int get totalLineNumbers {
    if (hasEqualNodeAndLineCount) {
      return totalSteps;
    }
    return isStartWithLine ? totalSteps : totalSteps - 1;
  }

  /// Returns the total number of nodes to display in the step progress widget.
  ///
  /// If [isStartWithLine] is `true`, the total number of nodes is one less
  /// than [totalSteps], otherwise it is equal to [totalSteps].
  int get totalNodeNumbers {
    if (hasEqualNodeAndLineCount) {
      return totalSteps;
    }
    return isStartWithLine ? totalSteps - 1 : totalSteps;
  }

  /// Returns the line index within the parent widget based on the [index] and
  /// the [isStartWithLine] flag.
  ///
  /// If [isStartWithLine] is `true`, the returned index is the same as the
  /// input [index].
  /// If [isStartWithLine] is `false`, the returned index is incremented by 1.
  ///
  /// This is useful for determining the correct line position when rendering
  /// step progress indicators.
  int getLineIndexInParentWidget(int index) =>
      isStartWithLine ? index : index + 1;

  /// Returns the node index in the parent widget based on the
  /// [isStartWithLine] flag.
  ///
  /// If [isStartWithLine] is `true`, the index is incremented by 1; otherwise,
  /// the original [index] is returned.
  ///
  /// [index]: The current node index.
  ///
  /// Returns the adjusted node index depending on whether the progress starts
  /// with a line.
  int getNodeIndexInParentWidget(int index) =>
      isStartWithLine ? index + 1 : index;

  /// Calculates the maximum height for a step node based on the provided
  /// [labelStyle].
  ///
  /// This method takes into account the padding and margin specified in the
  ///  [StepLabelStyle]
  /// to determine the total height required for the label. If node labels are
  /// present
  /// ([hasNodeLabels] is true), and the calculated label height is both finite
  /// and greater
  /// than the default [stepSize], the method returns the label's maximum
  /// height. Otherwise, it returns the default [stepSize].
  ///
  /// - Parameter labelStyle: The style configuration for the step label,
  /// including padding and margin.
  /// - Returns: The maximum height for the step node, considering label
  /// dimensions and step size.
  double maxStepHeight(StepLabelStyle labelStyle, BuildContext context) {
    final labelPadding = labelStyle.padding;
    final labelMargin = labelStyle.margin;

    double tallestTitleHeight = 0;

    if (nodeTitles != null && nodeTitles!.isNotEmpty) {
      final style = labelStyle.titleStyle ??
          Theme.of(context).textTheme.labelMedium ??
          const TextStyle();
      for (final title in [nodeTitles!.first, nodeTitles!.last]) {
        final titleHeight = calculateTextSize(
          text: title,
          style: style,
          maxWidth: maxStepWidth(labelStyle, context),
        ).height;
        if (titleHeight > tallestTitleHeight) {
          tallestTitleHeight = titleHeight;
        }
      }
    }

    double tallestSubTitleHeight = 0;
    if (nodeSubTitles != null && nodeSubTitles!.isNotEmpty) {
      final style = labelStyle.subTitleStyle ??
          Theme.of(context).textTheme.bodySmall ??
          const TextStyle();
      for (final subTitle in [nodeSubTitles!.first, nodeSubTitles!.last]) {
        final subTitleHeight = calculateTextSize(
          text: subTitle,
          style: style,
          maxWidth: maxStepWidth(labelStyle, context),
        ).height;
        if (subTitleHeight > tallestSubTitleHeight) {
          tallestSubTitleHeight = subTitleHeight;
        }
      }
    }

    final labelMaxHeight = tallestTitleHeight +
        tallestSubTitleHeight +
        labelPadding.top +
        labelPadding.bottom +
        labelMargin.top +
        labelMargin.bottom;

    // Calculate the maximum size for the step node.
    return (hasNodeLabels &&
            labelMaxHeight.isFinite &&
            labelMaxHeight > stepSize)
        ? labelMaxHeight
        : stepSize;
  }

  /// Calculates the maximum width required for a step widget, taking into
  /// account the label style's padding, margin, and maximum width constraints.
  ///
  /// If node labels are not present, returns the default step size.
  /// If a maximum width is specified and is finite, returns the greater of the
  /// maximum width or the step size.
  /// Otherwise, computes the width based on the rendered text of the first and
  /// last node titles, including padding and margin.
  ///
  /// - [labelStyle]: The style to apply to the step label, including padding,
  ///   margin, and maximum width.
  /// - [context]: The build context used to resolve text styles.
  ///
  /// Returns the maximum width as a [double].
  double maxStepWidth(StepLabelStyle labelStyle, BuildContext context) {
    final padding = labelStyle.padding;
    final margin = labelStyle.margin;
    final maxWidth = labelStyle.maxWidth +
        padding.left +
        padding.right +
        margin.left +
        margin.right;

    if (!hasNodeLabels) return stepSize;

    if (maxWidth.isFinite) {
      return maxWidth > stepSize ? maxWidth : stepSize;
    }

    double widestTitleWidth = 0;
    if (nodeTitles != null && nodeTitles!.isNotEmpty) {
      final style = labelStyle.titleStyle ??
          Theme.of(context).textTheme.labelMedium ??
          const TextStyle();
      for (final title in [nodeTitles!.first, nodeTitles!.last]) {
        final titleWidth = calculateTextSize(
          text: title,
          style: style,
          maxWidth: labelStyle.maxWidth,
        ).width;
        if (titleWidth > widestTitleWidth) {
          widestTitleWidth = titleWidth;
        }
      }
    }

    double widestSubTitleWidth = 0;
    if (nodeSubTitles != null && nodeSubTitles!.isNotEmpty) {
      final style = labelStyle.subTitleStyle ??
          Theme.of(context).textTheme.bodySmall ??
          const TextStyle();
      for (final subTitle in [nodeSubTitles!.first, nodeSubTitles!.last]) {
        final subTitleWidth = calculateTextSize(
          text: subTitle,
          style: style,
          maxWidth: labelStyle.maxWidth,
        ).width;
        if (subTitleWidth > widestSubTitleWidth) {
          widestSubTitleWidth = subTitleWidth;
        }
      }
    }

    final widestLabelWidth = max(widestTitleWidth, widestSubTitleWidth);

    final labelMaxWidth = widestLabelWidth +
        padding.left +
        padding.right +
        margin.left +
        margin.right;

    return labelMaxWidth > stepSize ? labelMaxWidth : stepSize;
  }

  /// Calculates the maximum width required for the node labels (titles and
  /// subtitles)
  /// based on the provided [labelStyle] and the current [BuildContext].
  ///
  /// If [hasNodeLabels] is false, returns 0. If maxWidth is finite,
  /// returns that value directly. Otherwise, it computes the widest text width
  /// among all node titles and subtitles using their respective text styles,
  /// and returns the maximum of these widths.
  ///
  /// - [labelStyle]: The style configuration for the labels, including maximum
  ///  width and text styles.
  /// - [context]: The build context used to obtain theme data for default text
  ///  styles.
  ///
  /// Returns the maximum width required for the labels.
  double maxLabelWidth(StepLabelStyle labelStyle, BuildContext context) {
    if (!hasNodeLabels) return 0;

    if (labelStyle.maxWidth.isFinite) {
      return labelStyle.maxWidth;
    }

    if (nodeLabelBuilder != null) {
      return double.infinity;
    }

    double widestTitleWidth = 0;
    if (nodeTitles != null && nodeTitles!.isNotEmpty) {
      final style = labelStyle.titleStyle ??
          Theme.of(context).textTheme.labelMedium ??
          const TextStyle();
      for (final title in nodeTitles!) {
        final titleWidth = calculateTextSize(
          text: title,
          style: style,
          maxWidth: labelStyle.maxWidth,
        ).width;
        if (titleWidth > widestTitleWidth) {
          widestTitleWidth = titleWidth;
        }
      }
    }

    double widestSubTitleWidth = 0;
    if (nodeSubTitles != null && nodeSubTitles!.isNotEmpty) {
      final style = labelStyle.subTitleStyle ??
          Theme.of(context).textTheme.bodySmall ??
          const TextStyle();
      for (final subTitle in nodeSubTitles!) {
        final subTitleWidth = calculateTextSize(
          text: subTitle,
          style: style,
          maxWidth: labelStyle.maxWidth,
        ).width;
        if (subTitleWidth > widestSubTitleWidth) {
          widestSubTitleWidth = subTitleWidth;
        }
      }
    }

    return max(widestTitleWidth, widestSubTitleWidth);
  }

  /// Builds the nodes and lines for the step progress widget.
  ///
  /// This method constructs the visual representation of the step progress,
  /// including the step nodes and the connecting lines between them. The
  /// appearance and behavior of these elements are determined by the provided
  /// theme and visibility options.
  ///
  /// The method uses a [LayoutBuilder] to adapt to the available constraints
  /// and a [Stack] to layer the nodes and lines appropriately.
  ///
  /// Parameters:
  /// - `context`: The build context in which the widget is built.
  /// - `wholeBoxNotifier`: An optional ValueNotifier to retrieve RenderBox of
  /// the entire constrained box.
  /// - `lineBoxNotifier`: An optional ValueNotifier to retrieve RenderBox of
  /// the step lines.
  ///
  /// Returns:
  /// A [Widget] that contains the step nodes and lines.
  Widget buildNodesAndLines({
    required BuildContext context,
    ValueNotifier<RenderBox?>? wholeBoxNotifier,
    ValueNotifier<RenderBox?>? lineBoxNotifier,
  }) {
    final theme = StepProgressTheme.of(context)!.data;
    final stepLineStyle = theme.stepLineStyle;
    final nodeLabelAlignment = theme.nodeLabelAlignment ??
        (axis == Axis.horizontal
            ? StepLabelAlignment.top
            : StepLabelAlignment.right);
    //
    final maximumStepSize = Size(
      maxStepWidth(theme.nodeLabelStyle, context),
      maxStepHeight(theme.nodeLabelStyle, context),
    );
    return LayoutBuilder(
      builder: (_, constraint) {
        Widget buildWidget() {
          return ConstrainedBox(
            constraints: getBoxConstraint(constraints: constraint),
            child: Stack(
              alignment: getStackAlignment(
                stepLabelAlignment: nodeLabelAlignment,
              ),
              children: [
                if (visibilityOptions != StepProgressVisibilityOptions.nodeOnly)
                  buildStepLines(
                    boxNotifier: lineBoxNotifier,
                    style: stepLineStyle,
                    maxStepSize: maximumStepSize,
                  ),
                if (visibilityOptions != StepProgressVisibilityOptions.lineOnly)
                  buildStepNodes(
                    labelAlignment: nodeLabelAlignment,
                    lineSpacing: theme.stepLineSpacing,
                    maxStepSize: maximumStepSize,
                    labelMaxWidth: maxLabelWidth(theme.nodeLabelStyle, context),
                  ),
              ],
            ),
          );
        }

        if (wholeBoxNotifier != null) {
          return RenderingBoxWidget(
            boxNotifier: wholeBoxNotifier,
            child: buildWidget(),
          );
        } else {
          return buildWidget();
        }
      },
    );
  }

  /// Calculates the size required to render a given text string with the
  /// specified [TextStyle].
  ///
  /// This method uses a [TextPainter] to measure the width and height of the
  /// text, considering optional constraints such as [maxWidth], [maxLines],
  /// [textDirection], and [textAlign].
  ///
  /// - [text]: The string to be measured.
  /// - [style]: The [TextStyle] to apply to the text.
  /// - [maxWidth]: The maximum allowed width for the text. Defaults to
  /// [double.infinity].
  /// - [maxLines]: The maximum number of lines for the text. If null, the text
  /// can span unlimited lines.
  /// - [textDirection]: The directionality of the text. Defaults to
  /// [TextDirection.ltr].
  /// - [textAlign]: The alignment of the text. Defaults to [TextAlign.left].
  ///
  /// Returns a [Size] object representing the width and height required to
  /// render the text.
  Size calculateTextSize({
    required String text,
    required TextStyle style,
    double maxWidth = double.infinity,
    int? maxLines,
    TextDirection textDirection = TextDirection.ltr,
    TextAlign textAlign = TextAlign.left,
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textAlign: textAlign,
      textDirection: textDirection,
    )..layout(maxWidth: maxWidth);

    return textPainter.size;
  }
}
