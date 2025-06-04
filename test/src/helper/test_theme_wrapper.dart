// A helper widget to supply the needed theme via StepProgressTheme.
import 'package:flutter/material.dart';
import 'package:step_progress/src/step_progress_theme.dart';
import 'package:step_progress/src/step_progress_theme_data.dart';

class TestThemeWrapper extends StatelessWidget {
  const TestThemeWrapper({required this.child, this.themeData, super.key});
  final Widget child;
  final StepProgressThemeData? themeData;

  @override
  Widget build(BuildContext context) {
    return StepProgressTheme(
      data: themeData ??
          const StepProgressThemeData(
            stepAnimationDuration: Duration(milliseconds: 200),
            activeForegroundColor: Colors.red, // some theme color
          ),
      child: MaterialApp(
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }
}
