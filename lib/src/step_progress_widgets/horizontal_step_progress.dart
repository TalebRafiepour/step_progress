import 'package:flutter/material.dart';
import 'package:step_progress/src/helpers/rendering_box_widget.dart';
import 'package:step_progress/src/step_label/step_label.dart';
import 'package:step_progress/src/step_line/step_line.dart';
import 'package:step_progress/src/step_progress_widgets/step_generator.dart';
import 'package:step_progress/src/step_progress_widgets/step_progress_widget.dart';
import 'package:step_progress/step_progress.dart';

/// A widget that displays a horizontal step progress indicator.
///
/// The [HorizontalStepProgress] widget is a customizable step progress
/// indicator that displays steps horizontally. It extends the
/// [StepProgressWidget] class.
///
/// The widget requires the following parameters:
/// - [totalStep]: The total number of steps.
/// - [currentStep]: The current step index.
/// - [stepSize]: The size of each step.
/// - [visibilityOptions]: Options to control the visibility of various
/// elements.
///
/// Optional parameters include:
/// - [nodeTitles]: A list of titles for each step node.
/// - [nodeSubTitles]: A list of subtitles for each step node.
/// - [lineTitles]: A list of titles for each line segment of progress.
/// - [lineSubTitles]: A list of subTitles for each line segment of progress.
/// - [onStepNodeTapped]: A callback function that is called when a step is
/// tapped.
/// - [onStepLineTapped]: A callback function that is called when a line is
/// tapped.
/// - [nodeIconBuilder]: A builder function to create custom icons for each
/// step.
/// - [nodeLabelBuilder]: A builder for creating custom label widgets for
/// step nodes.
/// - [lineLabelBuilder]: A builder for creating custom label widgets for step
///  lines.
/// - [key]: An optional key for the widget.
class HorizontalStepProgress extends StepProgressWidget {
  const HorizontalStepProgress({
    required super.totalStep,
    required super.currentStep,
    required super.stepSize,
    required super.visibilityOptions,
    super.nodeTitles,
    super.nodeSubTitles,
    super.lineTitles,
    super.lineSubTitles,
    super.onStepNodeTapped,
    super.onStepLineTapped,
    super.nodeIconBuilder,
    super.nodeLabelBuilder,
    super.lineLabelBuilder,
    super.key,
  }) : super(axis: Axis.horizontal);

  /// Builds the step nodes for the horizontal step progress widget.
  ///
  /// This method constructs the visual representation of the step nodes
  /// in the horizontal step progress indicator.
  ///
  /// The [highlightCompletedSteps] parameter determines whether the completed
  /// steps should be visually highlighted.
  /// The [labelAlignment] parameter to specify node alignment depends on labels
  ///
  /// Returns a [Widget] that represents the step nodes.
  @override
  Widget buildStepNodes({
    required bool highlightCompletedSteps,
    required StepLabelAlignment labelAlignment,
  }) {
    CrossAxisAlignment crossAxisAlignment() {
      if (labelAlignment == StepLabelAlignment.top) {
        return CrossAxisAlignment.end;
      } else if (labelAlignment == StepLabelAlignment.bottom) {
        return CrossAxisAlignment.start;
      } else {
        return CrossAxisAlignment.center;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: crossAxisAlignment(),
      children: List.generate(totalStep, (index) {
        final title = nodeTitles?.elementAtOrNull(index);
        final subTitle = nodeSubTitles?.elementAtOrNull(index);
        final isActive =
            highlightCompletedSteps
                ? index <= currentStep
                : index == currentStep;

        return StepGenerator(
          width: stepSize,
          height: stepSize,
          stepIndex: index,
          anyLabelExist: nodeTitles != null || nodeSubTitles != null,
          title: title,
          subTitle: subTitle,
          isActive: isActive,
          stepNodeIcon: nodeIconBuilder?.call(index, currentStep),
          customLabelWidget: nodeLabelBuilder?.call(index, currentStep),
          onTap: () => onStepNodeTapped?.call(index),
        );
      }),
    );
  }

  /// Builds the step lines with the given style.
  ///
  /// The [style] parameter specifies the appearance of the step lines.
  /// The [maxStepSize] parameter determines the maximum size of a step.
  /// The [highlightCompletedSteps] parameter determines whether completed steps
  /// should be highlighted.
  ///
  /// Returns a [Widget] that represents the step lines.
  @override
  Widget buildStepLines({
    required StepLineStyle style,
    required double maxStepSize,
    required bool highlightCompletedSteps,
    ValueNotifier<RenderBox?>? boxNotifier,
  }) {
    Widget buildWidget() {
      return Row(
        children: List.generate(totalStep - 1, (index) {
          return StepLine(
            isActive:
                highlightCompletedSteps
                    ? index < currentStep
                    : index == currentStep - 1,
            onTap: () => onStepLineTapped?.call(index),
          );
        }),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical:
            style.lineThickness >= stepSize
                ? 0
                : stepSize / 2 - style.lineThickness / 2,
        horizontal: maxStepSize / 2,
      ),
      child:
          boxNotifier == null
              ? buildWidget()
              : RenderingBoxWidget(
                boxNotifier: boxNotifier,
                child: buildWidget(),
              ),
    );
  }

  @override
  Widget buildStepLineLabels({required BuildContext context}) {
    if (!hasLineLabels) {
      return const SizedBox.shrink();
    }
    final theme = StepProgressTheme.of(context)!.data;
    final maxStepWidth = maxStepSize(theme.nodeLabelStyle);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: maxStepWidth / 2),
      child: Row(
        children: List.generate(totalStep - 1, (index) {
          return Expanded(
            child:
                lineLabelBuilder?.call(index, currentStep) ??
                StepLabel(
                  style: theme.lineLabelStyle,
                  alignment: theme.lineLabelAlignment ?? Alignment.topCenter,
                  isActive: currentStep > index,
                  title: lineTitles?.elementAtOrNull(index),
                  subTitle: lineSubTitles?.elementAtOrNull(index),
                ),
          );
        }),
      ),
    );
  }

  @override
  Alignment getStackAlignment({
    required StepLabelAlignment stepLabelAlignment,
  }) {
    if (!hasNodeLabels) {
      return Alignment.center;
    }
    if (stepLabelAlignment == StepLabelAlignment.top) {
      return Alignment.bottomCenter;
    } else if (stepLabelAlignment == StepLabelAlignment.bottom) {
      return Alignment.topCenter;
    } else {
      return Alignment.center;
    }
  }

  @override
  BoxConstraints getBoxConstraint({required BoxConstraints constraints}) {
    final width =
        axis == Axis.horizontal && !constraints.hasBoundedWidth
            ? totalStep * 1.45 * stepSize
            : null;
    return BoxConstraints.tightFor(width: width);
  }

  @override
  double maxStepSize(StepLabelStyle labelStyle) {
    final labelPadding = labelStyle.padding;
    final labelMargin = labelStyle.margin;
    final labelMaxWidth =
        labelStyle.maxWidth +
        labelPadding.left +
        labelPadding.right +
        labelMargin.left +
        labelMargin.right;

    // Calculate the maximum size for the step node.
    return ((nodeTitles != null || nodeSubTitles != null) &&
            labelMaxWidth.isFinite &&
            labelMaxWidth > stepSize)
        ? labelMaxWidth
        : stepSize;
  }

  @override
  Widget build(BuildContext context) {
    // If there are no line labels or we only want nodes, simply build nodes/lines.
    if (!hasLineLabels ||
        visibilityOptions == StepProgressVisibilityOptions.nodeOnly) {
      return buildNodesAndLines(context: context);
    }

    // Define ValueNotifier to obtain widget RenderBox.
    final wholeWidgetBoxNotifier = ValueNotifier<RenderBox?>(null);
    final lineWidgetBoxNotifier = ValueNotifier<RenderBox?>(null);

    //
    final theme = StepProgressTheme.of(context)!.data;

    // Determine the alignment for the line labels.
    final lineLabelAlignment =
        theme.lineLabelAlignment ?? Alignment.centerRight;
    bool isTopAligned() =>
        lineLabelAlignment == Alignment.topCenter ||
        lineLabelAlignment == Alignment.topRight ||
        lineLabelAlignment == Alignment.topLeft;
    bool isBottomAligned() =>
        lineLabelAlignment == Alignment.bottomCenter ||
        lineLabelAlignment == Alignment.bottomRight ||
        lineLabelAlignment == Alignment.bottomLeft;

    Alignment getLineStackAlignment() {
      if (isTopAligned()) return Alignment.bottomCenter;
      if (isBottomAligned()) return Alignment.topCenter;
      return Alignment.center;
    }

    Widget buildLineLabelWidget() => buildStepLineLabels(context: context);

    return Stack(
      alignment: getLineStackAlignment(),
      children: [
        buildNodesAndLines(
          context: context,
          lineBoxNotifier: lineWidgetBoxNotifier,
          wholeBoxNotifier: wholeWidgetBoxNotifier,
        ),
        ValueListenableBuilder<RenderBox?>(
          valueListenable: wholeWidgetBoxNotifier,
          builder: (_, wholeBox, __) {
            if (wholeBox == null) {
              return const SizedBox.shrink();
            }
            return ValueListenableBuilder<RenderBox?>(
              valueListenable: lineWidgetBoxNotifier,
              builder: (_, lineBox, __) {
                if (lineBox == null) {
                  return const SizedBox.shrink();
                }

                final wholeSize = wholeBox.size;
                final lineSize = lineBox.size;
                final linePosition = lineBox.localToGlobal(
                  Offset.zero,
                  ancestor: wholeBox,
                );

                if (isTopAligned()) {
                  final gap = (wholeSize.height - linePosition.dy).abs();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [buildLineLabelWidget(), SizedBox(height: gap)],
                  );
                } else if (isBottomAligned()) {
                  final gap = (linePosition.dy + lineSize.height).abs();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [SizedBox(height: gap), buildLineLabelWidget()],
                  );
                } else {
                  final wholeCenter = wholeSize.height / 2;
                  final lineCenter = linePosition.dy + lineSize.height / 2;
                  final gap = (wholeCenter - lineCenter).abs();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        wholeCenter < lineCenter
                            ? [SizedBox(height: gap), buildLineLabelWidget()]
                            : [buildLineLabelWidget(), SizedBox(height: gap)],
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}
