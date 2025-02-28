import 'package:flutter/material.dart';
import 'package:step_progress/src/step_progress_theme.dart';

class StepLineLabel extends StatelessWidget {
  const StepLineLabel({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final themeData = StepProgressTheme.of(context)!.data;
    final stepLineLabelStyle =
        themeData.lineLabelStyle.textStyle ??
        Theme.of(context).textTheme.labelMedium ??
        const TextStyle(fontSize: 14);
    //
    return Text(label, style: stepLineLabelStyle);
  }
}
