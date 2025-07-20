import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleSixteen extends StatelessWidget {
  const ExampleSixteen({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 5);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress -  BreadCrumb Line'),
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
          stepLineSpacing: 28,
          stepLineStyle: StepLineStyle(
            lineThickness: 10,
            isBreadcrumb: true,
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
