import 'package:flutter/material.dart';
import 'package:step_progress/src/step_node/ripple_effect_style.dart';
import 'package:step_progress/src/step_node/step_node_shape.dart';
import 'package:step_progress/src/step_node/step_node_shaped_container.dart';
import 'package:step_progress/src/step_progress_theme.dart';

/// A widget that displays a ripple effect around a step node.
///
/// The [StepNodeRipple] widget is used to create a ripple effect around a step
/// node with customizable shape, size, style, and visibility.
///
/// The ripple effect can be customized using the [style] parameter, which
/// accepts a [RippleEffectStyle] object. The number of ripples can be
/// controlled using the [count] parameter, and the visibility of the ripple
/// effect can be toggled using the [isVisible] parameter.
///
/// The [stepNodeShape] parameter defines the shape of the step node, while the
/// [width] and [height] parameters define the size of the ripple effect.
///
/// Example usage:
/// ```dart
/// StepNodeRipple(
///   stepNodeShape: StepNodeShape.circle,
///   width: 50.0,
///   height: 50.0,
///   style: RippleEffectStyle(color: Colors.blue),
///   count: 4,
///   isVisible: true,
/// )
/// ```
///
/// Parameters:
/// - [stepNodeShape]: The shape of the step node.
/// - [width]: The width of the ripple effect.
/// - [height]: The height of the ripple effect.
/// - [style]: The style of the ripple effect.
/// - [count]: The number of ripples. Defaults to 6.
/// - [isVisible]: Whether the ripple effect is visible. Defaults to true.
class StepNodeRipple extends StatelessWidget {
  const StepNodeRipple({
    required this.stepNodeShape,
    required this.width,
    required this.height,
    this.style = const RippleEffectStyle(),
    this.count = 6,
    this.isVisible = true,
    super.key,
  }) : assert(width >= 0, 'Width must be equal or greater than 0'),
       assert(height >= 0, 'Height must be equal or greater than 0'),
       assert(count >= 1, 'Count must be equal or greater than 1');

  /// The shape of the step node.
  final StepNodeShape stepNodeShape;

  /// The width of the ripple effect.
  final double width;

  /// The height of the ripple effect.
  final double height;

  /// The style of the ripple effect.
  final RippleEffectStyle style;

  /// The number of ripple effects.
  final int count;

  /// Whether the ripple effect is visible.
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final theme = StepProgressTheme.of(context)!.data;

    Duration animationDuration() {
      return style.animationDuration ?? theme.stepAnimationDuration;
    }

    return AnimatedOpacity(
      duration: animationDuration(),
      opacity: isVisible ? 1 : 0,
      child: AnimatedScale(
        duration: animationDuration(),
        scale: isVisible ? 1 : 0,
        child: !isVisible
            ? null
            : Stack(
                alignment: Alignment.center,
                children: List.generate(count, (index) {
                  return StepNodeShapedContainer(
                    stepNodeShape: stepNodeShape,
                    width: width - index * (width / count),
                    height: height - index * (height / count),
                    decoration: BoxDecoration(
                      color: style.foregroundColor ?? Colors.transparent,
                      border: Border.all(
                        color: style.borderColor ?? theme.activeForegroundColor,
                        width: style.borderWidth,
                      ),
                      borderRadius:
                          theme.stepNodeStyle.activeDecoration?.borderRadius ??
                          theme.stepNodeStyle.decoration.borderRadius,
                    ),
                  );
                }),
              ),
      ),
    );
  }
}
