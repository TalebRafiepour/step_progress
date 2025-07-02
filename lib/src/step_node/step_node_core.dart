import 'package:flutter/material.dart';
import 'package:step_progress/src/step_node/step_node_shape.dart';
import 'package:step_progress/src/step_node/step_node_shaped_container.dart';

/// Represents a single step node in a stepper widget.
///
/// This widget is responsible for displaying the visual representation of a
/// step, including its icon, color, shape, and size. It also handles the
/// visibility and animation of the step node.
///
class StepNodeCore extends StatelessWidget {
  const StepNodeCore({
    required this.stepNodeShape,
    this.decoration,
    this.icon = const Icon(Icons.check, size: 18, color: Colors.white),
    this.animationDuration = const Duration(milliseconds: 150),
    this.isVisible = true,
    this.iconColor,
    this.width,
    this.height,
    super.key,
  });

  /// The widget to display as the icon for this step node.  If null,
  /// a default icon is used.
  final Widget? icon;

  /// The color to use for the icon, if specified.
  final Color? iconColor;

  /// The decoration to apply to the step node.
  final BoxDecoration? decoration;

  /// The shape of the step node.  See [StepNodeShape] for available options.
  final StepNodeShape stepNodeShape;

  /// The width of the step node. If null, a default width is used.
  final double? width;

  /// The height of the step node. If null, a default height is used.
  final double? height;

  /// Whether or not this step node is visible.  If false, the node will not
  /// be rendered.
  final bool isVisible;

  /// The duration of the animation when the step node's state changes.
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: animationDuration,
      opacity: isVisible ? 1 : 0,
      child: AnimatedScale(
        duration: animationDuration,
        scale: isVisible ? 1 : 0,
        child: !isVisible
            ? null
            : StepNodeShapedContainer(
                width: width,
                height: height,
                stepNodeShape: stepNodeShape,
                decoration: decoration,
                child: iconColor != null
                    ? IconTheme(
                        data: IconThemeData(color: iconColor),
                        child: icon ?? const SizedBox.shrink(),
                      )
                    : icon ?? const SizedBox.shrink(),
              ),
      ),
    );
  }
}
