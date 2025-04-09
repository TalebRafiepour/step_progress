import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleTwelve extends StatelessWidget {
  const ExampleTwelve({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 4);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress -  hexagon shape'),
      ),
      body: Column(
        spacing: 48,
        children: [
          StepProgress(
            totalSteps: 4,
            stepSize: 24,
            height: 390,
            axis: Axis.vertical,
            controller: stepProgressController,
            nodeTitles: const [
              'Step 1',
              'Step 2',
              'Step 3',
              'Step 4',
            ],
            padding: const EdgeInsets.all(18),
            theme: const StepProgressThemeData(
              nodeLabelAlignment: StepLabelAlignment.leftRight,
              shape: StepNodeShape.hexagon,
              stepLineSpacing: 18,
              stepLineStyle: StepLineStyle(
                borderRadius: Radius.circular(4),
              ),
              stepNodeStyle: StepNodeStyle(
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
