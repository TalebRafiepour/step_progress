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
        stepSize: 28,
        padding: const EdgeInsets.all(10),
        axis: Axis.vertical,
        reversed: true,
        controller: stepProgressController,
        nodeIconBuilder: (index, completedStepIndex) {
          if (index <= completedStepIndex) {
            //step completed
            return const Icon(
              Icons.check,
              size: 18,
              color: Colors.white,
            );
          }
          return null;
        },
        lineLabelBuilder: (index, completedStepIndex) {
          // here index is index of current line
          // (numbers of lines is equal to toalSteps - 1)
          if (index.isEven) {
            return Text(
              'December ${index + 10} 2020',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.white),
            );
          }
          return null;
        },
        nodeLabelBuilder: (index, completedStepIndex) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6,
            children: [
              Text(
                'Invisalign ClinCheck $index',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      decorationColor: const Color(0xFF4e97fc),
                      color: const Color(0xFF4e97fc),
                      decoration: TextDecoration.underline,
                    ),
              ),
              Text(
                '9:20 AM - 9:40 AM',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF7e7971),
                    ),
              ),
            ],
          );
        },
        theme: const StepProgressThemeData(
          defaultForegroundColor: Color(0xFF666666),
          activeForegroundColor: Color(0xFF4e97fc),
          lineLabelAlignment: Alignment.topLeft,
          nodeLabelStyle: StepLabelStyle(
            maxWidth: double.infinity,
            margin: EdgeInsets.all(4),
          ),
          lineLabelStyle: StepLabelStyle(
            maxWidth: double.infinity,
            margin: EdgeInsets.only(
              right: 18,
            ),
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
