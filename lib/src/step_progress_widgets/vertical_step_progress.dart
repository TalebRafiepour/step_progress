import 'package:flutter/material.dart';
import 'package:step_progress/src/step_label_alignment.dart';
import 'package:step_progress/src/step_line/step_line.dart';
import 'package:step_progress/src/step_line/step_line_label.dart';
import 'package:step_progress/src/step_line/step_line_style.dart';
import 'package:step_progress/src/step_progress_theme.dart';
import 'package:step_progress/src/step_progress_visibility_options.dart';
import 'package:step_progress/src/step_progress_widgets/step_generator.dart';
import 'package:step_progress/src/step_progress_widgets/step_progress_widget.dart';

/// A widget that displays a vertical step progress indicator.
///
/// The [VerticalStepProgress] widget is a customizable widget that shows the
/// progress of a multi-step process in a vertical layout. It extends the
/// [StepProgressWidget] class and provides additional properties for
/// customization.
///
/// The [totalStep] parameter specifies the total number of steps in the
/// process, while the [currentStep] parameter indicates the current step
/// that the user is on. The [stepSize] parameter defines the size of each
/// step indicator.
///
/// The [visibilityOptions] parameter allows you to control the visibility of
/// various elements within the step progress widget, such as step titles and
/// subtitles.
///
/// Optional parameters include [titles] and [subTitles], which allow you to
/// provide titles and subtitles for each step. The [onStepNodeTapped] callback
/// can be used to handle tap events on individual steps. The [onStepLineTapped]
/// callback can be used to handle tap events on the step lines.
///
/// The [nodeIconBuilder] and [nodeActiveIconBuilder] parameters allow you to
/// customize the icons for each step. The [nodeIconBuilder] is used for
/// inactive steps, while the [nodeActiveIconBuilder] is used for the active
/// step.
///
/// Example usage:
/// ```dart
/// VerticalStepProgress(
///   totalStep: 5,
///   currentStep: 2,
///   stepSize: 30.0,
///   visibilityOptions: StepProgressVisibilityOptions.both,
///   lineLabels: ['Line1', 'Line2', 'Line3', 'Line4' ],
///   titles: ['Step 1', 'Step 2', 'Step 3', 'Step 4', 'Step 5'],
///   subTitles: ['Description 1', 'Description 2', 'Description 3',
///    'Description 4', 'Description 5'],
///   onStepNodeTapped: (step) {
///     print('Tapped on step: $step');
///   },
///   onStepLineTapped: (step) {
///     print('Tapped on step line: $step');
///   },
///   nodeIconBuilder: (step) {
///     return Icon(Icons.circle);
///   },
///   nodeActiveIconBuilder: (step) {
///     return Icon(Icons.check_circle);
///   },
/// );
/// ```
class VerticalStepProgress extends StepProgressWidget {
  const VerticalStepProgress({
    required super.totalStep,
    required super.currentStep,
    required super.stepSize,
    required super.visibilityOptions,
    super.titles,
    super.subTitles,
    super.lineLabels,
    super.onStepNodeTapped,
    super.onStepLineTapped,
    super.nodeIconBuilder,
    super.nodeActiveIconBuilder,
    super.key,
  }) : super(axis: Axis.vertical);

  /// Builds the step nodes for the vertical step progress widget.
  ///
  /// This method is responsible for creating and returning the widget
  /// that represents the step nodes in the vertical step progress.
  ///
  /// Override this method to customize the appearance and behavior
  /// of the step nodes.
  ///
  /// The [highlightCompletedSteps] parameter determines whether the
  /// completed steps should be highlighted.
  ///
  /// Returns a [Widget] that represents the step nodes.
  @override
  Widget buildStepNodes({
    required bool highlightCompletedSteps,
    required StepLabelAlignment labelAlignment,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(totalStep, (index) {
        final title = titles?.elementAtOrNull(index);
        final subTitle = subTitles?.elementAtOrNull(index);
        final isActive =
            highlightCompletedSteps
                ? index <= currentStep
                : index == currentStep;

        return StepGenerator(
          axis: Axis.vertical,
          width: stepSize,
          height: stepSize,
          anyLabelExist: titles != null || subTitles != null,
          stepIndex: index,
          title: title,
          subTitle: subTitle,
          isActive: isActive,
          stepNodeIcon: nodeIconBuilder?.call(index),
          stepNodeActiveIcon: nodeActiveIconBuilder?.call(index),
          onTap: () => onStepNodeTapped?.call(index),
        );
      }),
    );
  }

  /// Builds the step lines for the vertical step progress widget.
  ///
  /// This method takes a [StepLineStyle] object as a parameter, which defines
  /// the style of the step lines. The method returns a [Widget] that represents
  /// the step lines.
  ///
  /// The [style] parameter specifies the appearance of the step lines, such as
  /// color, thickness, and other visual properties.
  /// The [maxStepSize] parameter determines the maximum size of a step.
  ///
  /// Returns a [Widget] that displays the step lines according to the provided
  /// style.
  @override
  Widget buildStepLines({
    required StepLineStyle style,
    required double maxStepSize,
    required bool highlightCompletedSteps,
    Key? key,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: stepSize / 2,
        horizontal: stepSize / 2 - style.lineThickness / 2,
      ),
      child: Column(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(totalStep - 1, (index) {
          return StepLine(
            axis: Axis.vertical,
            isActive:
                highlightCompletedSteps
                    ? index < currentStep
                    : index == currentStep - 1,
            style: style,
            onTap: () => onStepLineTapped?.call(index),
          );
        }),
      ),
    );
  }

  @override
  Widget buildStepLineLabels(double lineThickness, double maxStepSize) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: stepSize / 2),
      child: Column(
        children: List.generate(totalStep - 1, (index) {
          return StepLineLabel(
            axis: Axis.vertical,
            label: lineLabels?.elementAtOrNull(index),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = StepProgressTheme.of(context)!.data;
    final stepLineStyle = theme.stepLineStyle;
    final highlightCompletedSteps = theme.highlightCompletedSteps;

    // Determine if the step nodes have associated labels.
    final hasNodeLabels = titles != null || subTitles != null;
    final nodeLabelAlignment =
        theme.stepLabelAlignment ?? StepLabelAlignment.right;
    final labelPadding = theme.labelStyle.padding;
    final labelMargin = theme.labelStyle.margin;
    final labelMaxWidth =
        theme.labelStyle.maxWidth +
        labelPadding.left +
        labelPadding.right +
        labelMargin.left +
        labelMargin.right;

    // Calculate the maximum size for the step node.
    final maxStepSize =
        ((titles != null || subTitles != null) &&
                labelMaxWidth.isFinite &&
                labelMaxWidth > stepSize)
            ? labelMaxWidth
            : stepSize;

    // Widget that builds nodes and lines.
    Widget buildNodesAndLines({GlobalKey? wholeKey, GlobalKey? lineKey}) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final height =
              !constraints.hasBoundedHeight
                  ? totalStep * 1.45 * stepSize
                  : null;

          Alignment getStackAlignment() {
            if (!hasNodeLabels) return Alignment.center;
            if (nodeLabelAlignment == StepLabelAlignment.right) {
              return Alignment.centerLeft;
            } else if (nodeLabelAlignment == StepLabelAlignment.left) {
              return Alignment.centerRight;
            } else {
              return Alignment.center;
            }
          }

          return ConstrainedBox(
            key: wholeKey,
            constraints: BoxConstraints.tightFor(height: height),
            child: Stack(
              alignment: getStackAlignment(),
              children: [
                if (visibilityOptions != StepProgressVisibilityOptions.nodeOnly)
                  buildStepLines(
                    key: lineKey,
                    style: stepLineStyle,
                    maxStepSize: maxStepSize,
                    highlightCompletedSteps: highlightCompletedSteps,
                  ),
                if (visibilityOptions != StepProgressVisibilityOptions.lineOnly)
                  buildStepNodes(
                    highlightCompletedSteps: highlightCompletedSteps,
                    labelAlignment: nodeLabelAlignment,
                  ),
              ],
            ),
          );
        },
      );
    }

    // If there are no line labels or we only want nodes, simply build nodes/lines.
    if (lineLabels == null ||
        lineLabels!.isEmpty ||
        visibilityOptions == StepProgressVisibilityOptions.nodeOnly) {
      return buildNodesAndLines();
    }

    // Define keys to obtain widget sizes.
    final wholeWidgetKey = GlobalKey();
    final lineWidgetKey = GlobalKey();

    // Determine the alignment for the line labels.
    final lineLabelAlignment =
        theme.lineLabelAlignment ?? Alignment.centerRight;
    bool isLeftAligned() =>
        lineLabelAlignment == Alignment.topLeft ||
        lineLabelAlignment == Alignment.centerLeft ||
        lineLabelAlignment == Alignment.bottomLeft;
    bool isRightAligned() =>
        lineLabelAlignment == Alignment.topRight ||
        lineLabelAlignment == Alignment.centerRight ||
        lineLabelAlignment == Alignment.bottomRight;

    Alignment getLineStackAlignment() {
      if (isLeftAligned()) return Alignment.centerRight;
      if (isRightAligned()) return Alignment.centerLeft;
      return Alignment.center;
    }

    Widget buildLineLabelWidget() =>
        buildStepLineLabels(stepLineStyle.lineThickness, maxStepSize);

    return Stack(
      alignment: getLineStackAlignment(),
      children: [
        buildNodesAndLines(wholeKey: wholeWidgetKey, lineKey: lineWidgetKey),
        FutureBuilder<void>(
          future: Future.delayed(Duration.zero),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox.shrink();
            }

            final wholeBox =
                wholeWidgetKey.currentContext!.findRenderObject()! as RenderBox;
            final lineBox =
                lineWidgetKey.currentContext!.findRenderObject()! as RenderBox;
            final wholeSize = wholeBox.size;
            final lineSize = lineBox.size;
            final linePosition = lineBox.localToGlobal(
              Offset.zero,
              ancestor: wholeBox,
            );

            if (isLeftAligned()) {
              final gap = (wholeSize.width - linePosition.dx).abs();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [buildLineLabelWidget(), SizedBox(width: gap)],
              );
            } else if (isRightAligned()) {
              final gap = (linePosition.dx + lineSize.width).abs();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [SizedBox(width: gap), buildLineLabelWidget()],
              );
            } else {
              final wholeCenter = wholeSize.width / 2;
              final lineCenter = linePosition.dx + lineSize.width / 2;
              if (wholeCenter == lineCenter) {
                return buildLineLabelWidget();
              } else if (wholeCenter < lineCenter) {
                final gap =
                    (2 * linePosition.dx + lineSize.width - wholeSize.width)
                        .abs();
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [SizedBox(width: gap), buildLineLabelWidget()],
                );
              } else {
                final gap =
                    (wholeSize.width - (2 * linePosition.dx + lineSize.width))
                        .abs();
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [buildLineLabelWidget(), SizedBox(width: gap)],
                );
              }
            }
          },
        ),
      ],
    );
  }
}
