import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleTwenty extends StatelessWidget {
  const ExampleTwenty({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 5);
    const nodeIcons = [
      Icon(Icons.home),
      Icon(Icons.star),
      Icon(Icons.settings),
      Icon(Icons.person),
      Icon(Icons.check)
    ];
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('StepProgress - Custom Stepper Without Lines'),
      ),
      body: StepProgress(
        totalSteps: 5,
        stepNodeSize: 75,
        padding: const EdgeInsets.all(10),
        controller: stepProgressController,
        visibilityOptions: StepProgressVisibilityOptions.nodeOnly,
        nodeIconBuilder: (index, completedStepIndex) => nodeIcons[index],
        theme: const StepProgressThemeData(
          stepAnimationDuration: Duration.zero,
          stepNodeStyle: StepNodeStyle(
            iconColor: Color(0xfffdfdfd),
            activeIconColor: Color(0xff72479e),
          ),
          activeForegroundColor: Color(0xFF181818),
          defaultForegroundColor: Color(0xff4c4c4c),
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
