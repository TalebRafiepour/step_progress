import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleNineteen extends StatelessWidget {
  const ExampleNineteen({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 5);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress -  HighlitCurrentStepNode'),
      ),
      body: StepProgress(
        totalSteps: 5,
        padding: const EdgeInsets.all(10),
        controller: stepProgressController,
        highlightOptions: StepProgressHighlightOptions.highlightCurrentNode,
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
