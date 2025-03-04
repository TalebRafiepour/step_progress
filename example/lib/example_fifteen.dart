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
      body: SingleChildScrollView(
        child: Column(
          spacing: 48,
          children: [
            StepProgress(
              totalSteps: 4,
              lineTitles: const ['top 1', 'top 2', 'top 3'],
              controller: stepProgressController,
              theme: const StepProgressThemeData(
                lineLabelAlignment: Alignment.topCenter,
              ),
            ),
            StepProgress(
              totalSteps: 4,
              lineTitles: const ['top 1', 'top 2', 'top 3'],
              nodeTitles: const [
                'step 1',
                'step 2',
                'step 3',
                'step 4',
              ],
              controller: stepProgressController,
              theme: const StepProgressThemeData(
                lineLabelAlignment: Alignment.topCenter,
              ),
            ),
            StepProgress(
              totalSteps: 4,
              lineTitles: const ['top 1', 'top 2', 'top 3'],
              nodeTitles: const [
                'step 1',
                'step 2',
                'step 3',
                'step 4',
              ],
              controller: stepProgressController,
              theme: const StepProgressThemeData(
                lineLabelAlignment: Alignment.topCenter,
                nodeLabelAlignment: StepLabelAlignment.bottom,
              ),
            ),
            StepProgress(
              totalSteps: 4,
              lineTitles: const ['center 1', 'center 2', 'center 3'],
              controller: stepProgressController,
              theme: const StepProgressThemeData(
                lineLabelAlignment: Alignment.center,
              ),
            ),
            StepProgress(
              totalSteps: 4,
              lineTitles: const ['center 1', 'center 2', 'center 3'],
              nodeTitles: const [
                'step 1',
                'step 2',
                'step 3',
                'step 4',
              ],
              controller: stepProgressController,
              theme: const StepProgressThemeData(
                lineLabelAlignment: Alignment.center,
                nodeLabelAlignment: StepLabelAlignment.top,
              ),
            ),
            StepProgress(
              totalSteps: 4,
              lineTitles: const ['bottom 1', 'bottom 2', 'bottom 3'],
              nodeTitles: const [
                'title 1',
                'title 2',
                'title 3',
                'title 4',
              ],
              controller: stepProgressController,
              theme: const StepProgressThemeData(
                lineLabelAlignment: Alignment.bottomCenter,
              ),
            ),
            StepProgress(
              totalSteps: 4,
              lineTitles: const ['bottom 1', 'bottom 2', 'bottom 3'],
              nodeTitles: const [
                'title 1',
                'title 2',
                'title 3',
                'title 4 longe title here',
              ],
              controller: stepProgressController,
              theme: const StepProgressThemeData(
                lineLabelAlignment: Alignment.bottomCenter,
                nodeLabelAlignment: StepLabelAlignment.bottomTop,
              ),
            ),
            SizedBox(
              height: 400,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 30,
                  children: [
                    StepProgress(
                      totalSteps: 4,
                      height: 390,
                      axis: Axis.vertical,
                      lineTitles: const [
                        'left 1',
                        'left 2',
                        'left 3',
                      ],
                      controller: stepProgressController,
                      theme: const StepProgressThemeData(
                        lineLabelAlignment: Alignment.centerLeft,
                      ),
                    ),
                    StepProgress(
                      totalSteps: 4,
                      height: 390,
                      axis: Axis.vertical,
                      lineTitles: const [
                        'right 1',
                        'right 2',
                        'right 3',
                      ],
                      nodeTitles: const [
                        'step 1',
                        'step 2',
                        'step 3',
                        'step 4',
                      ],
                      controller: stepProgressController,
                      theme: const StepProgressThemeData(
                        nodeLabelAlignment: StepLabelAlignment.left,
                        lineLabelAlignment: Alignment.centerRight,
                      ),
                    ),
                    StepProgress(
                      totalSteps: 4,
                      height: 390,
                      axis: Axis.vertical,
                      lineTitles: const [
                        'right 1',
                        'right 2',
                        'right 3',
                      ],
                      nodeTitles: const [
                        'step 1',
                        'step 2',
                        'step 3',
                        'step 4',
                      ],
                      controller: stepProgressController,
                      theme: const StepProgressThemeData(
                        nodeLabelAlignment: StepLabelAlignment.right,
                        lineLabelAlignment: Alignment.centerRight,
                      ),
                    ),
                    StepProgress(
                      totalSteps: 4,
                      height: 390,
                      axis: Axis.vertical,
                      lineTitles: const [
                        'right 1',
                        'right 2',
                        'right 3',
                      ],
                      lineSubTitles: const ['sub 1', 'sub2', 'sub 3'],
                      nodeTitles: const [
                        'step 1',
                        'step 2',
                        'step 3',
                        'step 4',
                      ],
                      controller: stepProgressController,
                      theme: const StepProgressThemeData(
                        nodeLabelAlignment: StepLabelAlignment.leftRight,
                        lineLabelAlignment: Alignment.centerRight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 400,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 30,
                  children: [
                    StepProgress(
                      totalSteps: 4,
                      height: 390,
                      axis: Axis.vertical,
                      lineTitles: const [
                        'center 1',
                        'center 2',
                        'center 3',
                      ],
                      controller: stepProgressController,
                      theme: const StepProgressThemeData(
                        lineLabelAlignment: Alignment.center,
                      ),
                    ),
                    StepProgress(
                      totalSteps: 4,
                      height: 390,
                      axis: Axis.vertical,
                      lineTitles: const [
                        'center 1',
                        'center 2',
                        'center 3',
                      ],
                      nodeTitles: const [
                        'step 1',
                        'step 2',
                        'step 3',
                        'step 4',
                      ],
                      controller: stepProgressController,
                      theme: const StepProgressThemeData(
                        nodeLabelAlignment: StepLabelAlignment.left,
                        lineLabelAlignment: Alignment.center,
                      ),
                    ),
                    StepProgress(
                      totalSteps: 4,
                      height: 390,
                      axis: Axis.vertical,
                      lineTitles: const [
                        'center 1',
                        'center 2',
                        'center 3',
                      ],
                      nodeTitles: const [
                        'step 1',
                        'step 2',
                        'step 3',
                        'step 4',
                      ],
                      controller: stepProgressController,
                      theme: const StepProgressThemeData(
                        nodeLabelAlignment: StepLabelAlignment.right,
                        lineLabelAlignment: Alignment.center,
                      ),
                    ),
                    StepProgress(
                      totalSteps: 4,
                      height: 390,
                      axis: Axis.vertical,
                      lineTitles: const [
                        'center 1',
                        'center 2',
                        'center 3',
                      ],
                      nodeTitles: const [
                        'step 1',
                        'step 2',
                        'step 3',
                        'step 4',
                      ],
                      controller: stepProgressController,
                      theme: const StepProgressThemeData(
                        nodeLabelAlignment: StepLabelAlignment.leftRight,
                        lineLabelAlignment: Alignment.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
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
    );
  }
}
