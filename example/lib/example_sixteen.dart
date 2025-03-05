import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleSixteen extends StatelessWidget {
  const ExampleSixteen({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 6);
    return Scaffold(
      backgroundColor: const Color(0xFF444444),
      appBar: AppBar(
        title: const Text('StepProgress -  Custom Vertical Timeline'),
      ),
      body: StepProgress(
        totalSteps: 6,
        padding: const EdgeInsets.all(10),
        axis: Axis.vertical,
        controller: stepProgressController,
        nodeIconBuilder: (index, completedStepIndex) {
          if (index <= completedStepIndex) {
            //step completed
            return const Icon(
              Icons.check,
              color: Colors.white,
            );
          }
          return null;
        },
        lineLabelBuilder: (index, completedStepIndex) {
          // here index is index of current line 
          // (numbers of lines is equal to toalSteps - 1)
          if (index.isEven) {
            return const Text('label');
          }
          return null;
        },
        theme: const StepProgressThemeData(
          defaultForegroundColor: Color(0xFF666666),
          activeForegroundColor: Color(0xFF4e97fc),
        ),
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
