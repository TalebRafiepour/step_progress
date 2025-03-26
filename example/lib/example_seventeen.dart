import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleSeventeen extends StatelessWidget {
  const ExampleSeventeen({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 4);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress -  Line Expansion'),
      ),
      body: StepProgress(
        totalSteps: 4,
        padding: const EdgeInsets.all(10),
        enableLineExpandable: true,
        visibilityOptions: StepProgressVisibilityOptions.lineOnly,
        theme: const StepProgressThemeData(
          stepLineSpacing: 4,
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
