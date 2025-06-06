import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleEleven extends StatelessWidget {
  const ExampleEleven({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 4);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress -  diamond shape'),
      ),
      body: Column(
        spacing: 48,
        children: [
          StepProgress(
            totalSteps: 4,
            stepSize: 24,
            controller: stepProgressController,
            nodeTitles: const [
              'Step 1',
              'Step 2',
              'Step 3',
              'Step 4',
            ],
            padding: const EdgeInsets.all(18),
            theme: const StepProgressThemeData(
              shape: StepNodeShape.diamond,
              stepLineSpacing: 18,
              stepLineStyle: StepLineStyle(
                borderRadius: Radius.circular(4),
              ),
              nodeLabelStyle: StepLabelStyle(
                margin: EdgeInsets.only(bottom: 6),
              ),
              stepNodeStyle: StepNodeStyle(
                activeIcon: null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
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
