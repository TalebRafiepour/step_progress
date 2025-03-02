import 'package:flutter/material.dart';
import 'package:step_progress/src/step_label_alignment.dart';
import 'package:step_progress/src/step_line/step_line_style.dart';
import 'package:step_progress/src/step_progress.dart';
import 'package:step_progress/src/step_progress_visibility_options.dart';

/// An abstract class that represents a step progress widget.
///
/// This widget is used to display a progress indicator with multiple steps.
///
/// The [StepProgressWidget] class is a [StatelessWidget] that requires the
/// total number of steps, the current step, and the size of each step.
///
/// The widget can also optionally display titles and subtitles for each step,
/// and handle tap events on each step.
///
/// Parameters:
/// - [totalStep]: The total number of steps in the progress indicator.
/// - [currentStep]: The current step in the progress indicator.
/// - [stepSize]: The size of each step in the progress indicator.
/// - [titles]: An optional list of titles for each step.
/// - [lineLabels]: An optional list of labels for each line segment.
/// - [axis]: The axis in which the step progress is laid out.
/// - [visibilityOptions]: The options to control the visibility of elements.
/// - [subTitles]: An optional list of subtitles for each step.
/// - [onStepNodeTapped]: An optional callback function that is called when a
/// step node is tapped.
/// - [onStepLineTapped]: An optional callback function that is called when a
/// step line is tapped.
/// - [nodeIconBuilder]: An optional builder for the icon of a step node.
/// - [nodeActiveIconBuilder]: An optional builder for the icon of an active
/// step node.
abstract class StepProgressWidget extends StatelessWidget {
  const StepProgressWidget({
    required this.totalStep,
    required this.currentStep,
    required this.stepSize,
    required this.axis,
    required this.visibilityOptions,
    this.titles,
    this.subTitles,
    this.lineLabels,
    this.onStepNodeTapped,
    this.onStepLineTapped,
    this.nodeIconBuilder,
    this.nodeActiveIconBuilder,
    super.key,
  }) : assert(
         titles == null || titles.length <= totalStep,
         'titles lenght must be equals to or less than total steps',
       ),
       assert(
         subTitles == null || subTitles.length <= totalStep,
         'subTitles lenght must be equals to or less than total steps',
       ),
       assert(
         lineLabels == null || lineLabels.length < totalStep,
         'lineLabels lenght must be less than total steps',
       );

  /// The total number of steps in the progress indicator.
  final int totalStep;

  /// The current step that is active or completed.
  final int currentStep;

  /// The size of each step in the progress indicator.
  final double stepSize;

  /// The titles for each step, if any.
  final List<String>? titles;

  /// The subtitles for each step, if any.
  final List<String>? subTitles;

  /// The labels for each line segment in the progress indicator.
  final List<String>? lineLabels;

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

  /// Builder for the icon of an active step node.
  final StepNodeIconBuilder? nodeActiveIconBuilder;

  /// Builds the step nodes widget.
  ///
  /// This method should be implemented to create the visual representation
  /// of the step nodes in the step progress widget.
  ///
  /// The [highlightCompletedSteps] parameter indicates whether the completed
  /// steps should be visually highlighted.
  /// The [labelAlignment] parameters indicates the alignment of labels.
  Widget buildStepNodes({
    required bool highlightCompletedSteps,
    required StepLabelAlignment labelAlignment,
  });

  /// Builds the step lines widget with the given style.
  ///
  /// This method should be implemented to create the visual representation
  /// of the lines connecting the step nodes in the step progress widget.
  ///
  /// [style] defines the appearance and style of the step lines.
  /// [maxStepSize] is the maximum size of the step nodes.
  /// [highlightCompletedSteps] indicates whether to highlight the completed
  /// steps.
  Widget buildStepLines({
    required StepLineStyle style,
    required double maxStepSize,
    required bool highlightCompletedSteps,
    Key? key,
  });

  Widget buildStepLineLabels(double lineThickness, double maxStepSize);
}
