import 'package:flutter/material.dart';
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

    return Expanded(
      child: Container(
        alignment: lineLabelAlignment,
        child: Text(label!, style: stepLineLabelStyle),
      ),
    );
  }
}
