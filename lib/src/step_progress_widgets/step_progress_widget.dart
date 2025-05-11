import 'package:flutter/material.dart';
import 'package:step_progress/src/helpers/rendering_box_widget.dart';
import 'package:step_progress/src/step_label/step_label_style.dart';
import 'package:step_progress/src/step_label_alignment.dart';
import 'package:step_progress/src/step_line/step_line_style.dart';
import 'package:step_progress/src/step_progress.dart';
import 'package:step_progress/src/step_progress_highlight_options.dart';
import 'package:step_progress/src/step_progress_theme.dart';
import 'package:step_progress/src/step_progress_visibility_options.dart';

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
/// (horizontal or vertical).
/// - [visibilityOptions]: Options to control the visibility of elements.
/// - [nodeSubTitles]: An optional list of subtitles for each step.
/// - [onStepNodeTapped]: An optional callback function triggered when a step
/// node is tapped.
/// - [onStepLineTapped]: An optional callback function triggered when a step
/// line is tapped.
/// - [nodeIconBuilder]: An optional builder for the icon of a step node.
/// - [nodeLabelBuilder]: A builder for creating custom label widgets for
/// step nodes.
/// - [lineLabelBuilder]: A builder for creating custom label widgets for step
///  lines.
/// - [reversed]: Indicates whether the step progress is displayed in reverse
/// order. It defaults to false.
/// - [needsRebuildWidget]: Callback to request a rebuild of the parent widget.
/// This is triggered when dynamic size calculations are needed.
/// - [highlightOptions]: Options to customize the highlight behavior of the
/// step progress widget.
abstract class StepProgressWidget extends StatelessWidget {
  const StepProgressWidget({
    required this.totalSteps,
    required this.currentStep,
    required this.stepSize,
    required this.axis,
    required this.visibilityOptions,
    required this.needsRebuildWidget,
    this.highlightOptions =
        StepProgressHighlightOptions.highlightCompletedNodesAndLines,
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
  }) : assert(
         nodeTitles == null || nodeTitles.length <= totalSteps,
         'nodeTitles lenght must be equals to or less than total steps',
       ),
       assert(
         nodeSubTitles == null || nodeSubTitles.length <= totalSteps,
         'nodeSubTitles lenght must be equals to or less than total steps',
       ),
       assert(
         lineTitles == null || lineTitles.length < totalSteps,
         'lineTitles lenght must be less than total steps',
       ),
       assert(
         lineSubTitles == null || lineSubTitles.length < totalSteps,
         'lineSubTitles lenght must be less than total steps',
       );

  /// The total number of steps in the progress indicator.
  final int totalSteps;

  /// The current step that is active or completed.
  final int currentStep;

  /// The size of each step in the progress indicator.
  final double stepSize;

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

  /// Determines if a step line at the given index should be highlighted
  /// based on the current step and highlight options.
  bool isHighlightedStepLine(int index) {
    if (highlightOptions ==
            StepProgressHighlightOptions.highlightCompletedLines ||
        highlightOptions ==
            StepProgressHighlightOptions.highlightCompletedNodesAndLines) {
      return index < currentStep;
    } else if (highlightOptions ==
            StepProgressHighlightOptions.highlightCurrentLine ||
        highlightOptions ==
            StepProgressHighlightOptions.highlightCurrentNodeAndLine) {
      return index == currentStep - 1;
    } else {
      return false;
    }
  }

  /// Determines if a step node at a given index should be highlighted.
  /// The highlighting behavior depends on the specified highlight options.
  bool isHighlightedStepNode(int index) {
    if (highlightOptions ==
            StepProgressHighlightOptions.highlightCompletedNodes ||
        highlightOptions ==
            StepProgressHighlightOptions.highlightCompletedNodesAndLines) {
      return index <= currentStep;
    } else if (highlightOptions ==
            StepProgressHighlightOptions.highlightCurrentNode ||
        highlightOptions ==
            StepProgressHighlightOptions.highlightCurrentNodeAndLine) {
      return index == currentStep;
    } else {
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
  Widget buildStepNodes({required StepLabelAlignment labelAlignment});

  /// Builds the step lines widget with the given style.
  ///
  /// This method should be implemented to create the visual representation
  /// of the lines connecting the step nodes in the step progress widget.
  ///
  /// [style] defines the appearance and style of the step lines.
  /// [maxStepSize] is the maximum size of the step nodes.
  Widget buildStepLines({
    required StepLineStyle style,
    required double maxStepSize,
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

  /// Calculates the maximum step size based on the provided label style.
  ///
  /// This method determines the maximum size of a step, which can be useful
  /// for layout purposes when displaying steps with labels.
  ///
  /// - Parameters:
  ///   - labelStyle: The style to be applied to the step labels.
  ///
  /// - Returns: The maximum size of a step as a double.
  double maxStepSize(StepLabelStyle labelStyle);

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
    final nodeLabelAlignment =
        theme.nodeLabelAlignment ??
        (axis == Axis.horizontal
            ? StepLabelAlignment.top
            : StepLabelAlignment.right);
    //
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
                    maxStepSize: maxStepSize(theme.nodeLabelStyle),
                  ),
                if (visibilityOptions != StepProgressVisibilityOptions.lineOnly)
                  buildStepNodes(labelAlignment: nodeLabelAlignment),
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
}
