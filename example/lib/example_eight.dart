import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleEight extends StatelessWidget {
  const ExampleEight({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 4);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress -  line spacing'),
      ),
      body: Column(
        spacing: 48,
        children: [
          StepProgress(
            totalSteps: 4,
            controller: stepProgressController,
            axis: Axis.vertical,
            height: 300,
            nodeTitles: const [
              'Step 1',
              'Step 2',
              'Step 3',
              'Step 4',
            ],
            padding: const EdgeInsets.all(18),
            theme: const StepProgressThemeData(
              nodeLabelAlignment: StepLabelAlignment.left,
              nodeLabelStyle: StepLabelStyle(
                labelAxisAlignment: CrossAxisAlignment.start,
              ),
              stepLineSpacing: 24,
              stepLineStyle: StepLineStyle(
                borderRadius: Radius.circular(8),
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
