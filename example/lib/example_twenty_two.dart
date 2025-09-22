import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleTwentyTwo extends StatelessWidget {
  const ExampleTwentyTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 3);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress - Line First Mode'),
      ),
      body: StepProgress(
        totalSteps: 3,
        padding: const EdgeInsets.all(10),
        axis: Axis.vertical,
        startWithLine: true,
        theme: const StepProgressThemeData(
          stepLineSpacing: 10,
        ),
        controller: stepProgressController,
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 40,
          children: [
            ElevatedButton(
              onPressed: stepProgressController.previousStep,
              child: const Icon(Icons.arrow_back, size: 20),
            ),
            ElevatedButton(
              onPressed: stepProgressController.nextStep,
              child: const Icon(Icons.arrow_forward, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
