import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ReproduceIssues extends StatelessWidget {
  const ReproduceIssues({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 3);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress -  reproduce issue'),
      ),
      body: Column(
        spacing: 48,
        children: [
          StepProgress(
            totalSteps: 3,
            stepSize: 10,
            controller: stepProgressController,
            padding: const EdgeInsets.all(18),
            nodeTitles: const [
              'Step 1',
              'Step 2 here is a big',
              'Step 4',
            ],
            theme: const StepProgressThemeData(
              nodeLabelAlignment: StepLabelAlignment.top,
              nodeLabelStyle: StepLabelStyle(
                maxWidth: double.infinity,
              ),
              stepLineStyle: StepLineStyle(
                lineThickness: 3,
              ),
            ),
          ),
          StepProgress(
            totalSteps: 3,
            height: 300,
            axis: Axis.vertical,
            controller: stepProgressController,
            padding: const EdgeInsets.all(18),
            nodeTitles: const [
              'Step 1',
              'Step 2',
              'Step 4 here is a big title that should wrap',
            ],
            theme: const StepProgressThemeData(
                nodeLabelAlignment: StepLabelAlignment.right,
                stepLineStyle: StepLineStyle(
                  lineThickness: 3,
                ),
                nodeLabelStyle: StepLabelStyle(
                  maxWidth: double.infinity,
                  textAlign: TextAlign.start,
                )),
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
