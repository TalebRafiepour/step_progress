import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleTwentyTwo extends StatelessWidget {
  const ExampleTwentyTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 6);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress - Line First Mode'),
      ),
      body: StepProgress(
        totalSteps: 6,
        stepNodeSize: 20,
        padding: const EdgeInsets.symmetric(vertical: 24),
        visibilityOptions: StepProgressVisibilityOptions.lineThenNode,
        theme: const StepProgressThemeData(
            //stepLineSpacing: 20,
            stepNodeStyle: StepNodeStyle(
          shape: StepNodeShape.hexagon,
        )),
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
