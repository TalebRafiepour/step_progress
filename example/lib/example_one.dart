import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleOne extends StatelessWidget {
  const ExampleOne({super.key});

  @override
  Widget build(BuildContext context) {
    final StepProgressController stepProgressController =
        StepProgressController(totalSteps: 4);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress - vertical'),
      ),
      body: SafeArea(
        child: Column(
          spacing: 48,
          children: [
            StepProgress(
              totalSteps: 4,
              controller: stepProgressController,
              axis: Axis.vertical,
              nodeTitles: const [
                'step 1',
                'step 2',
                'step 3',
                'step 4',
              ],
              onStepChanged: (index) {
                debugPrint('on step changed: $index');
              },
              onStepNodeTapped: (index) {
                debugPrint('on step tapped with index: $index');
              },
              onStepLineTapped: (index) {
                debugPrint('on step line tapped with index: $index');
              },
            ),
            Row(
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
          ],
        ),
      ),
    );
  }
}
