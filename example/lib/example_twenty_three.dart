import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleTwentyThree extends StatelessWidget {
  const ExampleTwentyThree({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 3);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'StepProgress -Customized- Line FirstMode-EqualLineAndNode'),
      ),
      body: StepProgress(
        totalSteps: 3,
        stepNodeSize: 20,
        axis: Axis.vertical,
        padding: const EdgeInsets.symmetric(vertical: 24),
        visibilityOptions: StepProgressVisibilityOptions.lineThenNode,
        lineTitles: const [
          'Download Audacity application',
          'Connect to cloud storage',
          'Never lose your work in Audacity'
        ],
        theme: const StepProgressThemeData(
            stepLineSpacing: 20,
            //lineLabelAlignment: Alignment.bottomCenter,
            lineLabelStyle: StepLabelStyle(
              defualtColor: Colors.black87,
              activeColor: Colors.black87,
              margin: EdgeInsets.only(top: 10),
              titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            stepNodeStyle: StepNodeStyle(
              shape: StepNodeShape.circle,
            )),
        controller: stepProgressController,
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
              onPressed: stepProgressController.nextStep,
              child: const Icon(Icons.arrow_forward, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
