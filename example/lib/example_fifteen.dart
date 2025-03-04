import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class ExampleFifteen extends StatelessWidget {
  const ExampleFifteen({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProgressController = StepProgressController(totalSteps: 4);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepProgress -  LineLabel'),
      ),
      body: StepProgress(
        totalSteps: 4,
        padding: const EdgeInsets.all(10),
        lineTitles: const ['line title 1', 'line title 2', 'line title 3'],
        controller: stepProgressController,
        nodeIconBuilder: (index) {
          return const Icon(Icons.more_horiz,color: Colors.white,);
        },
        theme: const StepProgressThemeData(
          lineLabelAlignment: Alignment.bottomCenter,
          lineLabelStyle: StepLabelStyle(
            defualtColor: Colors.grey,
            activeColor: Colors.green,
          ),
          stepLineSpacing: 20,
          stepLineStyle: StepLineStyle(
            lineThickness: 3,
            borderRadius: BorderRadius.all(Radius.circular(4)),
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
