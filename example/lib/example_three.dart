import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleThree extends StatelessWidget {
  const ExampleThree({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: For 4 line steps, set totalSteps to 5 (4 lines + 1 endpoint)
    late final stepProgressController = StepProgressController(totalSteps: 5);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 26),
      appBar: AppBar(
        title: const Text('Line Stepper'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 48,
        children: [
          StepProgress(
            totalSteps: 5,
            visibilityOptions: StepProgressVisibilityOptions.lineOnly,
            controller: stepProgressController,
            highlightOptions: StepProgressHighlightOptions.highlightCurrentLine,
            onStepChanged: (currentIndex) {
              debugPrint('onStepChanged: $currentIndex');
            },
            onStepLineTapped: (index) {
              debugPrint('onStepLineTapped: $index');
            },
            theme: const StepProgressThemeData(
              stepLineSpacing: 6,
              defaultForegroundColor: Color.fromARGB(255, 55, 55, 55),
              activeForegroundColor: Color.fromARGB(255, 105, 105, 105),
              stepLineStyle: StepLineStyle(
                lineThickness: 9,
                borderRadius: Radius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 38,
            children: [
              ElevatedButton(
                onPressed: stepProgressController.previousStep,
                child: const Text('PREV'),
              ),
              ElevatedButton(
                onPressed: stepProgressController.nextStep,
                child: const Text('NEXT'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
