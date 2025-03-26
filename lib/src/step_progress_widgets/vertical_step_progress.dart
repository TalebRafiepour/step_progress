import 'dart:async';

import 'package:flutter/material.dart';
import 'package:step_progress/src/helpers/data_cache.dart';
import 'package:step_progress/src/helpers/rendering_box_widget.dart';
import 'package:step_progress/src/step_label/step_label.dart';
import 'package:step_progress/src/step_label/step_label_style.dart';
import 'package:step_progress/src/step_label_alignment.dart';
import 'package:step_progress/src/step_line/step_line.dart';
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
/// The [totalSteps] parameter specifies the total number of steps in the
/// process, while the [currentStep] parameter indicates the current step
/// that the user is on. The [stepSize] parameter defines the size of each
/// step indicator.
///
/// The [visibilityOptions] parameter allows you to control the visibility of
/// various elements within the step progress widget, such as step titles and
/// subtitles.
///
/// The [reversed] parameter allows you to reverse the order of the steps.
///
/// The [enableLineExpandable] parameter determines whether the step lines
/// should be expandable to fill the available space between steps.
///
/// The [needsRebuildWidget] parameter is a [VoidCallback] function that can be
/// used to trigger a rebuild of the widget when necessary.
///
/// Optional parameters include [nodeTitles], [nodeSubTitles], [lineTitles],
/// and [lineSubTitles], which allow you to provide titles and subtitles for
/// step nodes and lines. The [onStepNodeTapped] callback can be used to handle
/// tap events on individual steps. The [onStepLineTapped] callback can be used
/// to handle tap events on the step lines.
///
/// The [nodeIconBuilder] allows you to customize the icons for each step.
///
/// The [nodeLabelBuilder] and [lineLabelBuilder] parameters allow you to
/// customize the labels for each step node and step line respectively.
///
/// Example usage:
/// ```dart
/// VerticalStepProgress(
///   totalStep: 5,
///   currentStep: 2,
///   stepSize: 30.0,
///   visibilityOptions: StepProgressVisibilityOptions.both,
///   reversed: false,
///   enableLineExpandable: true,
///   lineTitles: ['Line1', 'Line2', 'Line3', 'Line4'],
///   lineSubTitles: ['sub1', 'sub2', 'sub3', 'sub4'],
///   nodeTitles: ['Step 1', 'Step 2', 'Step 3', 'Step 4', 'Step 5'],
///   nodeSubTitles: ['Description 1', 'Description 2', 'Description 3',
///    'Description 4', 'Description 5'],
///   onStepNodeTapped: (step) {
///     print('Tapped on step: $step');
///   },
///   onStepLineTapped: (step) {
///     print('Tapped on step line: $step');
///   },
///   nodeIconBuilder: (step, completedStepIndex) {
///     return Icon(Icons.circle);
///   },
///   nodeLabelBuilder: (step, completedStepIndex) {
///     return Text('Node Label $step');
///   },
///   lineLabelBuilder: (step, completedStepIndex) {
///     return Text('Line Label $step');
///   },
///   needsRebuildWidget: () {
///     // Trigger a rebuild calling `setState((){})` in parent widget
///   },
/// );
/// ```
class VerticalStepProgress extends StepProgressWidget {
  const VerticalStepProgress({
    required super.totalSteps,
    required super.currentStep,
    required super.stepSize,
    required super.visibilityOptions,
    required super.needsRebuildWidget,
    super.enableLineExpandable,
    super.reversed,
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
    List<Widget> children = List.generate(totalSteps, (index) {
      final title = nodeTitles?.elementAtOrNull(index);
      final subTitle = nodeSubTitles?.elementAtOrNull(index);
      final isActive =
          highlightCompletedSteps ? index <= currentStep : index == currentStep;

      return StepGenerator(
        axis: Axis.vertical,
        width: stepSize,
        height: stepSize,
        anyLabelExist: nodeTitles != null || nodeSubTitles != null,
        stepIndex: index,
        title: title,
        subTitle: subTitle,
        isActive: isActive,
        stepNodeIcon: nodeIconBuilder?.call(index, currentStep),
        customLabelWidget: nodeLabelBuilder?.call(index, currentStep),
        onTap: () => onStepNodeTapped?.call(index),
      );
    });
    if (reversed) {
      children = children.reversed.toList();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
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
    ValueNotifier<RenderBox?>? boxNotifier,
  }) {
    Widget buildWidget() {
      List<Widget> children = List.generate(totalSteps - 1, (index) {
        return StepLine(
          flex: getStepLineFlexNumber(index),
          axis: Axis.vertical,
          isActive:
              highlightCompletedSteps
                  ? index < currentStep
                  : index == currentStep - 1,
          onTap: () => onStepLineTapped?.call(index),
        );
      });
      if (reversed) {
        children = children.reversed.toList();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: maxStepSize / 2,
        horizontal:
            style.lineThickness >= stepSize
                ? 0
                : stepSize / 2 - style.lineThickness / 2,
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
    final maxStepHeight = maxStepSize(theme.nodeLabelStyle);
    //
    List<Widget> children = List.generate(totalSteps - 1, (index) {
      return Expanded(
        flex: getStepLineFlexNumber(index),
        child: StepLabel(
          style: theme.lineLabelStyle,
          alignment: theme.lineLabelAlignment ?? Alignment.centerRight,
          isActive: index < currentStep,
          customLabel: lineLabelBuilder?.call(index, currentStep),
          title: lineTitles?.elementAtOrNull(index),
          subTitle: lineSubTitles?.elementAtOrNull(index),
        ),
      );
    });
    if (reversed) {
      children = children.reversed.toList();
    }
    //
    return Padding(
      padding: EdgeInsets.symmetric(vertical: maxStepHeight / 2),
      child: Column(children: children),
    );
  }

  @override
  Alignment getStackAlignment({
    required StepLabelAlignment stepLabelAlignment,
  }) {
    if (!hasNodeLabels) return Alignment.center;
    if (stepLabelAlignment == StepLabelAlignment.right) {
      return Alignment.centerLeft;
    } else if (stepLabelAlignment == StepLabelAlignment.left) {
      return Alignment.centerRight;
    } else {
      return Alignment.center;
    }
  }

  @override
  BoxConstraints getBoxConstraint({required BoxConstraints constraints}) {
    final height =
        !constraints.hasBoundedHeight ? totalSteps * 1.45 * stepSize : null;
    return BoxConstraints.tightFor(height: height);
  }

  @override
  double maxStepSize(StepLabelStyle labelStyle) {
    final labelPadding = labelStyle.padding;
    final labelMargin = labelStyle.margin;
    final labelMaxHeight =
        // labelMaxHeight +
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

  @override
  Widget build(BuildContext context) {
    // If there are no line labels or we only want nodes, simply build nodes/lines.
    if (!hasLineLabels ||
        visibilityOptions == StepProgressVisibilityOptions.nodeOnly) {
      return buildNodesAndLines(context: context);
    }

    final theme = StepProgressTheme.of(context)!.data;

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

    Widget buildLineLabelWidget() => buildStepLineLabels(context: context);

    Widget positionLineLabels(
      Size wholeSize,
      Size lineSize,
      Offset linePosition,
    ) {
      Widget child;
      if (isLeftAligned()) {
        final gap = (wholeSize.width - linePosition.dx).abs();
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [buildLineLabelWidget(), SizedBox(width: gap)],
        );
      } else if (isRightAligned()) {
        final gap = (linePosition.dx + lineSize.width).abs();
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [SizedBox(width: gap), buildLineLabelWidget()],
        );
      } else {
        final wholeCenter = wholeSize.width / 2;
        final lineCenter = linePosition.dx + lineSize.width / 2;
        if (wholeCenter == lineCenter) {
          child = buildLineLabelWidget();
        } else if (wholeCenter < lineCenter) {
          final gap =
              (2 * linePosition.dx + lineSize.width - wholeSize.width).abs();
          child = Row(
            mainAxisSize: MainAxisSize.min,
            children: [SizedBox(width: gap), buildLineLabelWidget()],
          );
        } else {
          final gap =
              (wholeSize.width - (2 * linePosition.dx + lineSize.width)).abs();
          child = Row(
            mainAxisSize: MainAxisSize.min,
            children: [buildLineLabelWidget(), SizedBox(width: gap)],
          );
        }
      }
      return Directionality(textDirection: TextDirection.ltr, child: child);
    }

    final lineWidgetSize =
        DataCache().getData(DataCacheKey.lineWidgetSize) as Size?;
    final lineWidgetPosition =
        DataCache().getData(DataCacheKey.lineWidgetPosition) as Offset?;
    final wholeWidgetSizes =
        DataCache().getData(DataCacheKey.wholeWidgetSize) as Size?;
    if (lineWidgetSize != null &&
        wholeWidgetSizes != null &&
        lineWidgetPosition != null) {
      return Stack(
        alignment: getLineStackAlignment(),
        children: [
          buildNodesAndLines(context: context),
          positionLineLabels(
            wholeWidgetSizes,
            lineWidgetSize,
            lineWidgetPosition,
          ),
        ],
      );
    } else {
      // Define ValueNotifier to obtain widget RenderBox.
      final wholeWidgetBoxNotifier = ValueNotifier<RenderBox?>(null);
      final lineWidgetBoxNotifier = ValueNotifier<RenderBox?>(null);
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

                  // Render boxes for both widgets have been obtained.
                  // Disposing the notifiers to prevent memory leaks.
                  wholeWidgetBoxNotifier.dispose();
                  lineWidgetBoxNotifier.dispose();
                  //
                  final wholeSize = wholeBox.size;
                  final lineSize = lineBox.size;
                  final linePosition = lineBox.localToGlobal(
                    Offset.zero,
                    ancestor: wholeBox,
                  );
                  // cache boxe sizes to retrieve them when step change
                  DataCache().setData(DataCacheKey.lineWidgetSize, lineSize);
                  DataCache().setData(
                    DataCacheKey.lineWidgetPosition,
                    linePosition,
                  );
                  DataCache().setData(DataCacheKey.wholeWidgetSize, wholeSize);
                  // then we rebuild widget with new sizes that cached
                  scheduleMicrotask(needsRebuildWidget.call);
                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ],
      );
    }
  }
}
