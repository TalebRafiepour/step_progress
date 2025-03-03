import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleSeven extends StatelessWidget {
  const ExampleSeven({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 4);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress -  without lines'),
      ),
      body: Column(
        spacing: 48,
        children: [
          StepProgress(
            totalSteps: 4,
            controller: stepProgressController,
            visibilityOptions: StepProgressVisibilityOptions.nodeOnly,
            // titles: const [
            //   'Step 1',
            //   'Step 2',
            //   'Step 3',
            //   'Step 4',
            // ],
            nodeSubTitles: const [
              'sub 1',
              'sub 2',
              'sub 3',
              'sub 4',
            ],
            padding: const EdgeInsets.all(18),
            theme: const StepProgressThemeData(
              stepLabelAlignment: StepLabelAlignment.right,
              nodeLabelStyle: StepLabelStyle(
                labelAxisAlignment: CrossAxisAlignment.start,
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
