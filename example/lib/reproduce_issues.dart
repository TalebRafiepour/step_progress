import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ReproduceIssues extends StatelessWidget {
  const ReproduceIssues({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 4);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress -  reproduce issue'),
      ),
      body: Column(
        spacing: 48,
        children: [
          StepProgress(
            totalSteps: 4,
            stepSize: 28,
            controller: stepProgressController,
            padding: const EdgeInsets.all(18),
            nodeTitles: const [
              'Step 1',
              'Step 2',
              'Step 3',
              'Step 4 and a long title',
            ],
            theme: const StepProgressThemeData(
              nodeLabelAlignment: StepLabelAlignment.top,
              stepLineStyle: StepLineStyle(
                lineThickness: 3,
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
