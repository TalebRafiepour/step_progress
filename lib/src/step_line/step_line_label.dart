import 'package:flutter/material.dart';

class StepLineLabel extends StatelessWidget {
  const StepLineLabel({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label);
  }
}
