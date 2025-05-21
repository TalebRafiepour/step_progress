import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleSix extends StatelessWidget {
  const ExampleSix({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 4);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress -  position label'),
      ),
      body: Column(
        spacing: 48,
        children: [
          StepProgress(
            totalSteps: 4,
            padding: const EdgeInsets.all(28),
            controller: stepProgressController,
            nodeTitles: const [
              'Step 1',
              'Step 2',
              'Step 3',
              'Step 4',
            ],
            theme: const StepProgressThemeData(
              nodeLabelAlignment: StepLabelAlignment.topBottom,
              stepLineSpacing: 2,
              stepLineStyle: StepLineStyle(
                lineThickness: 2,
              ),
            ),
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
    );
  }
}
