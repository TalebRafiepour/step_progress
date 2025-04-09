import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleThirteen extends StatelessWidget {
  const ExampleThirteen({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 4);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress -  star shape'),
      ),
      body: Column(
        spacing: 48,
        children: [
          StepProgress(
            totalSteps: 4,
            stepSize: 28,
            height: 390,
            axis: Axis.vertical,
            controller: stepProgressController,
            padding: const EdgeInsets.all(18),
            theme: const StepProgressThemeData(
              nodeLabelAlignment: StepLabelAlignment.left,
              shape: StepNodeShape.star,
              stepLineSpacing: 18,
              stepLineStyle: StepLineStyle(
                lineThickness: 3,
                borderRadius: Radius.circular(3),
              ),
              stepNodeStyle: StepNodeStyle(
                activeIcon: Icon(
                  Icons.verified_rounded,
                  size: 10,
                  color: Colors.white,
                ),
                icon: Icon(
                  Icons.more_horiz_outlined,
                  size: 10,
                  color: Colors.white,
                ),
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
