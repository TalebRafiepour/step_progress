import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleTwentyOne extends StatelessWidget {
  const ExampleTwentyOne({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 5);
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: const Text('StepProgress - Instagram Story Like Stepper'),
      ),
      body: StepProgress(
        totalSteps: 5,
        padding: const EdgeInsets.all(10),
        controller: stepProgressController,
        visibilityOptions: StepProgressVisibilityOptions.lineOnly,
        theme: const StepProgressThemeData(
          activeForegroundColor: Color.fromARGB(255, 255, 255, 255),
          defaultForegroundColor: Color.fromARGB(255, 171, 168, 168),
          stepLineSpacing: 3,
          stepLineStyle: StepLineStyle(
            lineThickness: 5,
            borderRadius: Radius.circular(5),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 40,
          children: [
            ElevatedButton(
              onPressed: stepProgressController.previousStep,
              child: const Icon(Icons.arrow_back, size: 20),
            ),
            ElevatedButton(
              onPressed: () {
                // play or pause the step progress
              },
              child: const Icon(Icons.play_arrow, size: 20),
            ),
            ElevatedButton(
              onPressed: stepProgressController.nextStep,
              child: const Icon(Icons.arrow_forward, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
