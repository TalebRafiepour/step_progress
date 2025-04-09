import 'package:flutter/material.dart';
import 'package:step_progress/src/helpers/data_cache.dart';
import 'package:step_progress/src/step_progress_widgets/horizontal_step_progress.dart';
import 'package:step_progress/src/step_progress_widgets/vertical_step_progress.dart';
import 'package:step_progress/step_progress.dart';

/// A typedef for a function that builds an optional widget to label a step in
/// a step progress indicator.
///
/// The function takes two parameters:
/// - `index`: The index of the current step.
/// - `completedStepIndex`: The index of the last completed step.
///
/// Returns an optional [Widget] that represents the label for the step.
typedef StepLabelBuilder = Widget? Function(int index, int completedStepIndex);

/// A typedef for a function that builds optional widget for a step node icon.
///
/// The function takes two parameters:
/// - `index`: The index of the current step.
/// - `completedStepIndex`: The index of the last completed step.
///
/// Returns an optional [Widget] that represents the icon for the step node.
typedef StepNodeIconBuilder =
    Widget? Function(int index, int completedStepIndex);

/// A typedef for a callback function that is triggered when a step line is
/// tapped.
///
/// The callback function takes an integer [index] as a parameter, which
/// represents the index of the tapped step line.
typedef OnStepLineTapped = void Function(int index);

/// A typedef for a callback function that is called when the step changes.
///
/// The [currentIndex] parameter indicates the index of the current step.
typedef OnStepChanged = void Function(int currentIndex);

/// A typedef for a callback function that is triggered when a step is tapped.
///
/// The callback function takes an integer [index] as a parameter, which
/// represents the index of the step that was tapped.
typedef OnStepNodeTapped = void Function(int index);

/// A widget that displays a step progress indicator.
///
/// The [StepProgress] widget is a customizable step progress indicator that
/// can be used to show the progress of a multi-step process.
///
/// The [totalSteps] parameter is required and specifies the total number of
/// steps in the progress indicator.
///
/// The [controller] parameter can be used to control the progress of the steps.
///
/// The [currentStep] parameter specifies the current step in the progress
/// indicator. It defaults to 0.
///
/// The [stepSize] parameter specifies the size of each step. It defaults to 34.
///
/// The [theme] parameter specifies the theme data for the step progress
/// indicator. It defaults to [StepProgressThemeData].
///
/// The [margin] parameter specifies the margin around the step progress
/// indicator. It defaults to [EdgeInsets.zero].
///
/// The [padding] parameter specifies the padding inside the step progress
/// indicator. It defaults to [EdgeInsets.zero].
///
/// The [axis] parameter specifies the axis along which the steps are laid out.
/// It defaults to [Axis.horizontal].
///
/// The [nodeTitles] parameter can be used to specify titles for each step.
///
/// The [nodeSubTitles] parameter can be used to specify subtitles for steps.
///
/// The [lineTitles] parameter can be used to specify titles for each step line
/// segment.
///
/// The [lineSubTitles] parameter can be used to specify subTitles for each
/// step line segment.
///
/// The [visibilityOptions] parameter can be used to control the visibility of
/// step progress elements.
///
/// The [width] parameter specifies the width of the step progress widget.
///
/// The [height] parameter specifies the height of the step progress widget.
///
/// The [onStepNodeTapped] parameter is a callback that is called when a step
/// node is tapped.
///
/// The [onStepLineTapped] parameter is a callback that is called when a step
/// line is tapped.
///
/// The [onStepChanged] parameter is a callback that is called when the current
/// step changes.
///
/// The [nodeIconBuilder] parameter is a builder function to create custom icons
/// for each step node.
///
/// The [nodeLabelBuilder] parameter is a builder function for creating custom
/// label widgets for step nodes.
///
/// The [lineLabelBuilder] parameter is a builder function for creating custom
/// label widgets for step lines.
///
/// The [reversed] parameter indicates whether the step progress is displayed
/// in reverse order. It defaults to false.
class StepProgress extends StatefulWidget {
  const StepProgress({
    required this.totalSteps,
    this.controller,
    this.currentStep = 0,
    super.key,
    this.stepSize = 34,
    this.width,
    this.height,
    this.theme = const StepProgressThemeData(),
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.axis = Axis.horizontal,
    this.reversed = false,
    this.visibilityOptions = StepProgressVisibilityOptions.both,
    this.nodeTitles,
    this.nodeSubTitles,
    this.lineTitles,
    this.lineSubTitles,
    this.onStepNodeTapped,
    this.onStepLineTapped,
    this.onStepChanged,
    this.nodeIconBuilder,
    this.nodeLabelBuilder,
    this.lineLabelBuilder,
  }) : assert(totalSteps > 0, 'totalSteps must be greater than 0'),
       assert(
         currentStep < totalSteps,
         'currentStep must be  lower than totalSteps',
       ),
       assert(
         nodeTitles == null || nodeTitles.length <= totalSteps,
         'nodeTitles must be equals to or less than total steps',
       ),
       assert(
         nodeSubTitles == null || nodeSubTitles.length <= totalSteps,
         'nodeSubTitles must be equals to or less than total steps',
       ),
       assert(
         lineTitles == null || lineTitles.length < totalSteps,
         'lineTitles must be less than total steps',
       ),
       assert(
         lineSubTitles == null || lineSubTitles.length < totalSteps,
         'lineSubTitles must be less than total steps',
       );

  /// List of Titles for each step in the progress
  final List<String>? nodeTitles;

  /// List of Subtitles for each step in the progress
  final List<String>? nodeSubTitles;

  /// List of titles for the line segments in the progress indicator.
  final List<String>? lineTitles;

  /// List of subTitles for the line segments in the progress indicator.
  final List<String>? lineSubTitles;

  /// Options to control the visibility of step progress elements.
  final StepProgressVisibilityOptions visibilityOptions;

  /// Size of each step indicator
  final double stepSize;

  /// The width of the step progress widget.
  final double? width;

  /// The height of the step progress widget.
  final double? height;

  /// Total number of steps in the progress
  final int totalSteps;

  /// Current step in the progress
  final int currentStep;

  /// Theme data for customizing the step progress appearance
  final StepProgressThemeData theme;

  /// Axis along which the steps are arranged (horizontal or vertical)
  final Axis axis;

  /// Callback function when a step is tapped
  final OnStepNodeTapped? onStepNodeTapped;

  /// Callback function that is triggered when a step line is tapped.
  final OnStepLineTapped? onStepLineTapped;

  /// The controller that manages the state and behavior of the step progress.
  final StepProgressController? controller;

  /// The margin around the step progress widget.
  final EdgeInsets margin;

  /// The padding inside the step progress widget.
  final EdgeInsets padding;

  /// Callback function that is called when the step changes.
  final OnStepChanged? onStepChanged;

  /// A builder function to create custom icons for each step node.
  final StepNodeIconBuilder? nodeIconBuilder;

  /// A builder for creating custom label widgets for step nodes.
  final StepLabelBuilder? nodeLabelBuilder;

  /// A builder for creating custom label widgets for step lines.
  final StepLabelBuilder? lineLabelBuilder;

  /// Indicates whether the step progress is displayed in reverse order.
  final bool reversed;

  @override
  _StepProgressState createState() {
    assert(
      controller == null || totalSteps == controller?.totalSteps,
      'totalSteps in controller must be equal to provided totalSteps',
    );
    return _StepProgressState();
  }
}

class _StepProgressState extends State<StepProgress>
    with SingleTickerProviderStateMixin {
  late int _currentStep = _getCurrentStep;

  @override
  void initState() {
    widget.controller?.addListener(() {
      _changeStep(widget.controller!.currentStep);
    });
    super.initState();
  }

  @override
  void dispose() {
    /// Clears the cache by calling the `clearCache` method on the `DataCache`
    /// instance.
    /// This method is used to remove all cached data, ensuring that the cache
    /// is empty.
    DataCache().clearCache();
    super.dispose();
  }

  /// Called whenever the widget configuration changes.
  /// This method changes the current step when it's changed in the parent
  /// widget by setState.
  @override
  void didUpdateWidget(covariant StepProgress oldWidget) {
    if (widget.currentStep != _currentStep ||
        oldWidget.controller != widget.controller) {
      _currentStep = _getCurrentStep;
    }
    super.didUpdateWidget(oldWidget);
  }

  /// Returns the current step of the progress.
  ///
  /// If a [StepProgressController] is provided, it retrieves the current step
  ///  from the controller. Otherwise, it uses the `currentStep`
  /// property of the widget.
  ///
  /// This getter ensures that the current step is always accurately retrieved
  /// based on the presence of a controller.
  int get _getCurrentStep {
    return widget.controller != null
        ? widget.controller!.currentStep
        : widget.currentStep;
  }

  /// Changes the current step to the specified [newStep].
  ///
  /// If [newStep] is the same as the current step, less than -1, or greater
  /// than or equal to the total number of steps, the function will return
  /// without making any changes.
  ///
  /// When the step is successfully changed, the state is updated and the
  /// `onStepChanged` callback is called with the new step value.
  ///
  /// [newStep] - The step to change to.
  void _changeStep(int newStep) {
    if (_currentStep == newStep ||
        newStep < -1 ||
        newStep >= widget.totalSteps) {
      return;
    }
    if (mounted) {
      setState(() {
        _currentStep = newStep;
      });
    }
    widget.onStepChanged?.call(_currentStep);
  }

  /// Triggers a rebuild of the widget if it is currently mounted.
  ///
  /// This method checks if the widget is mounted, and if so,
  /// calls `setState` to request a rebuild of the widget.
  void _needsRebuildWidget() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StepProgressTheme(
      data: widget.theme,
      child: Container(
        width: widget.width,
        height: widget.height,
        color: Colors.transparent,
        margin: widget.margin.add(
          EdgeInsets.all(widget.theme.borderStyle?.borderWidth ?? 0),
        ),
        padding: widget.padding,
        child:
            widget.axis == Axis.horizontal
                ? HorizontalStepProgress(
                  totalSteps: widget.totalSteps,
                  currentStep: _currentStep,
                  reversed: widget.reversed,
                  needsRebuildWidget: _needsRebuildWidget,
                  nodeTitles: widget.nodeTitles,
                  nodeSubTitles: widget.nodeSubTitles,
                  lineTitles: widget.lineTitles,
                  lineSubTitles: widget.lineSubTitles,
                  stepSize: widget.stepSize,
                  onStepNodeTapped: widget.onStepNodeTapped,
                  onStepLineTapped: widget.onStepLineTapped,
                  visibilityOptions: widget.visibilityOptions,
                  nodeIconBuilder: widget.nodeIconBuilder,
                  lineLabelBuilder: widget.lineLabelBuilder,
                  nodeLabelBuilder: widget.nodeLabelBuilder,
                )
                : VerticalStepProgress(
                  totalSteps: widget.totalSteps,
                  currentStep: _currentStep,
                  reversed: widget.reversed,
                  needsRebuildWidget: _needsRebuildWidget,
                  nodeTitles: widget.nodeTitles,
                  nodeSubTitles: widget.nodeSubTitles,
                  lineTitles: widget.lineTitles,
                  lineSubTitles: widget.lineSubTitles,
                  stepSize: widget.stepSize,
                  onStepNodeTapped: widget.onStepNodeTapped,
                  onStepLineTapped: widget.onStepLineTapped,
                  visibilityOptions: widget.visibilityOptions,
                  nodeIconBuilder: widget.nodeIconBuilder,
                  lineLabelBuilder: widget.lineLabelBuilder,
                  nodeLabelBuilder: widget.nodeLabelBuilder,
                ),
      ),
    );
  }
}
