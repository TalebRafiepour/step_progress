import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleFifteen extends StatelessWidget {
  const ExampleFifteen({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 4);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress -  LineLabel'),
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 48,
          children: [
            StepProgress(
              totalSteps: 4,
              lineLabels: const ['line 1', 'line 2', 'line 3'],
              controller: stepProgressController,
              theme: const StepProgressThemeData(
                lineLabelAlignment: Alignment.topCenter,
              ),
            ),
            StepProgress(
              totalSteps: 4,
              height: 390,
              axis: Axis.vertical,
              lineLabels: const ['line 1', 'line 2', 'line 3'],
              controller: stepProgressController,
              theme: const StepProgressThemeData(
                lineLabelAlignment: Alignment.centerLeft,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 38,
        children: [
          ElevatedButton(
            onPressed: stepProgressController.previousStep,
            child: const Text('Prev'),
          ),
          ElevatedButton(
            onPressed: stepProgressController.nextStep,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
