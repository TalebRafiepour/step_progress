import 'package:flutter/material.dart';
import 'package:step_progress/src/step_progress_controller.dart';

/// A widget that displays a step progress line with customizable appearance.
/// Supports animation, orientation, and completion callbacks.
/// Useful for visualizing progress in multi-step processes.
class StepValueLine extends StatefulWidget {
  const StepValueLine({
    required this.activeColor,
    required this.borderRadius,
    required this.lineSize,
    required this.highlighted,
    required this.isHorizontal,
    required this.duration,
    this.onAnimationCompleted,
    this.controller,
    super.key,
  });

  /// Callback triggered when the animation is completed.
  final VoidCallback? onAnimationCompleted;

  /// The color used for the active state of the step line.
  final Color activeColor;

  /// The border radius applied to the step line.
  final Radius borderRadius;

  /// The size of the step line.
  final Size lineSize;

  /// Whether the step line is highlighted.
  final bool highlighted;

  /// Whether the step line is oriented horizontally.
  final bool isHorizontal;

  /// The duration of the animation.
  final Duration duration;

  /// Optional controller to manage and update the step progress state.
  final StepProgressController? controller;

  @override
  State<StepValueLine> createState() => _StepValueLineState();
}

class _StepValueLineState extends State<StepValueLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    animationController.forward();
    if (widget.onAnimationCompleted != null) {
      animationController.addStatusListener(statusListener);
    }
    widget.controller?.playAnimation = playAnimation;
    widget.controller?.pauseAnimation = pauseAnimation;
    widget.controller?.isAnimating = () => animationController.isAnimating;
    super.initState();
  }

  void statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onAnimationCompleted!();
    }
  }

  @override
  void dispose() {
    if (widget.onAnimationCompleted != null) {
      animationController.removeStatusListener(statusListener);
    }
    animationController.dispose();
    super.dispose();
  }

  /// Starts the animation if it is not already running.
  void playAnimation() {
    if (!animationController.isAnimating) {
      animationController.forward();
    }
  }

  /// Pauses the animation if it is currently running.
  void pauseAnimation() {
    if (animationController.isAnimating) {
      animationController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Container(
          width: widget.isHorizontal
              ? (widget.highlighted
                  ? widget.lineSize.width * animationController.value
                  : 0)
              : widget.lineSize.width,
          height: !widget.isHorizontal
              ? (widget.highlighted
                  ? widget.lineSize.height * animationController.value
                  : 0)
              : widget.lineSize.height,
          decoration: BoxDecoration(
            color: widget.activeColor,
            borderRadius: BorderRadius.all(widget.borderRadius),
          ),
        );
      },
    );
  }
}
