import 'package:flutter/material.dart';
import 'package:step_progress/src/helpers/keep_size_visibility.dart';
import 'package:step_progress/src/step_progress_theme.dart';

class StepLineLabel extends StatelessWidget {
  const StepLineLabel({required this.axis, this.label, super.key});

  final String? label;
  final Axis axis;

  bool get _isHorizontal => axis == Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    if (label == null) return const SizedBox.shrink();
    //
    final theme = StepProgressTheme.of(context)!.data;
    final stepLineLabelStyle =
        theme.lineLabelStyle.textStyle ??
        Theme.of(context).textTheme.labelMedium ??
        const TextStyle(fontSize: 14);
    final lineLabelAlignment =
        theme.lineLabelAlignment ??
        (_isHorizontal ? Alignment.topCenter : Alignment.centerRight);
    final lineThickness = theme.stepLineStyle.lineThickness;
    final borderWidth = theme.borderWidth;

    final padding =
        _isHorizontal
            ? EdgeInsets.symmetric(horizontal: theme.stepLineSpacing)
            : EdgeInsets.symmetric(vertical: theme.stepLineSpacing);

    // Builds the line using the available constraints.
    Widget buildLine(BoxConstraints constraints) {
      final decoration =
          borderWidth > 0
              ? BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.transparent,
                  width: borderWidth,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              )
              : const BoxDecoration(color: Colors.transparent);

      return Container(
        padding: padding,
        width: _isHorizontal ? constraints.constrainWidth() : lineThickness,
        height: _isHorizontal ? lineThickness : constraints.constrainHeight(),
        decoration: decoration,
      );
    }

    // Builds the text label.
    Widget buildLabel() => Text(label!, style: stepLineLabelStyle);

    return Expanded(
      child: LayoutBuilder(
        builder: (_, constraints) {
          return _isHorizontal
              ? _buildHorizontalLayout(
                lineLabelAlignment,
                constraints,
                buildLine,
                buildLabel(),
              )
              : Container(alignment: lineLabelAlignment, child: buildLabel());
        },
      ),
    );
  }

  Widget _buildHorizontalLayout(
    Alignment alignment,
    BoxConstraints constraints,
    Widget Function(BoxConstraints) buildLine,
    Widget buildLabel,
  ) {
    if (alignment == Alignment.topCenter ||
        alignment == Alignment.topRight ||
        alignment == Alignment.topLeft) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(alignment: alignment, child: buildLabel),
          buildLine(constraints),
          KeepSizeVisibility(visible: false, child: buildLabel),
        ],
      );
    } else if (alignment == Alignment.bottomCenter ||
        alignment == Alignment.bottomRight ||
        alignment == Alignment.bottomLeft) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          KeepSizeVisibility(visible: false, child: buildLabel),
          buildLine(constraints),
          Align(alignment: alignment, child: buildLabel),
        ],
      );
    } else {
      return Align(alignment: alignment, child: buildLabel);
    }
  }
}
