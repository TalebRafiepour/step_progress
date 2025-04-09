import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleEighteen extends StatelessWidget {
  const ExampleEighteen({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 5);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress -  Dotted Line'),
      ),
      body: StepProgress(
        totalSteps: 5,
        padding: const EdgeInsets.all(10),
        controller: stepProgressController,
        lineSubTitles: const [
          'Step 2',
          'Step 3',
          'Step 4',
          'Step 5',
        ],
        theme: const StepProgressThemeData(
          stepLineStyle: StepLineStyle(
            borderRadius: Radius.circular(8),
            borderStyle: OutterBorderStyle(
              isDotted: true,
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 40,
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
      ),
    );
  }
}
