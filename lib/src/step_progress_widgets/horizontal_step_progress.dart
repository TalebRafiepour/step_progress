import 'package:flutter/material.dart';
import 'package:step_progress/src/step_line/step_line.dart';
import 'package:step_progress/src/step_line/step_line_label.dart';
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
/// - [titles]: A list of titles for each step.
/// - [subTitles]: A list of subtitles for each step.
/// - [lineLabels]: A list of labels for each line segment of progress.
/// - [onStepNodeTapped]: A callback function that is called when a step is
/// tapped.
/// - [onStepLineTapped]: A callback function that is called when a line is
/// tapped.
/// - [nodeIconBuilder]: A builder function to create custom icons for each
/// step.
/// - [nodeActiveIconBuilder]: A builder function to create custom icons for
/// active steps.
/// - [key]: An optional key for the widget.
class HorizontalStepProgress extends StepProgressWidget {
  const HorizontalStepProgress({
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
        final title = titles?.elementAtOrNull(index);
        final subTitle = subTitles?.elementAtOrNull(index);
        final isActive =
            highlightCompletedSteps
                ? index <= currentStep
                : index == currentStep;

        return StepGenerator(
          width: stepSize,
          height: stepSize,
          stepIndex: index,
          anyLabelExist: titles != null || subTitles != null,
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
    Key? key,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: stepSize / 2 - style.lineThickness / 2,
        horizontal: maxStepSize / 2,
      ),
      child: Row(
        children: List.generate(totalStep - 1, (index) {
          return StepLine(
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
      padding: EdgeInsets.symmetric(horizontal: maxStepSize / 2),
      child: Row(
        children: List.generate(totalStep - 1, (index) {
          return StepLineLabel(
            axis: Axis.horizontal,
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
    //
    final stepNodeLabelExist = titles != null || subTitles != null;
    final stepNodeLabelAlignment =
        theme.stepLabelAlignment ?? StepLabelAlignment.top;

    final labelMaxWidth =
        (theme.labelStyle.maxWidth) +
        theme.labelStyle.padding.left +
        theme.labelStyle.padding.right +
        theme.labelStyle.margin.left +
        theme.labelStyle.margin.right;
    // The maximum size of a step node.
    final maxStepSize =
        ((titles != null || subTitles != null) &&
                labelMaxWidth.isFinite &&
                labelMaxWidth > stepSize)
            ? labelMaxWidth
            : stepSize;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            axis == Axis.horizontal && !constraints.hasBoundedWidth
                ? totalStep * 1.45 * stepSize
                : null;

        Alignment alignment() {
          if (!stepNodeLabelExist) {
            return Alignment.center;
          }
          switch (stepNodeLabelAlignment) {
            case StepLabelAlignment.top:
              return Alignment.bottomCenter;
            case StepLabelAlignment.bottom:
              return Alignment.topCenter;
            case StepLabelAlignment.left:
            case StepLabelAlignment.right:
            case StepLabelAlignment.topBottom:
            case StepLabelAlignment.bottomTop:
            case StepLabelAlignment.rightLeft:
            case StepLabelAlignment.leftRight:
              return Alignment.center;
          }
        }

        return ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: width),
          child: Stack(
            alignment: alignment(),
            children: [
              if (visibilityOptions != StepProgressVisibilityOptions.nodeOnly)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    buildStepLines(
                      style: stepLineStyle,
                      maxStepSize: maxStepSize,
                      highlightCompletedSteps: highlightCompletedSteps,
                    ),
                    if (lineLabels != null)
                      buildStepLineLabels(
                        stepLineStyle.lineThickness,
                        maxStepSize,
                      ),
                  ],
                ),
              if (visibilityOptions != StepProgressVisibilityOptions.lineOnly)
                buildStepNodes(
                  highlightCompletedSteps: highlightCompletedSteps,
                  labelAlignment: stepNodeLabelAlignment,
                ),
            ],
          ),
        );
      },
    );
  }
}
