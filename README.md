# StepProgress

[![Pub Version](https://img.shields.io/pub/v/step_progress.svg?label=pub&color=blue)](https://pub.dev/packages/step_progress/versions)
[![GitHub Stars](https://img.shields.io/github/stars/TalebRafiepour/step_progress?color=yellow&label=Stars)](https://github.com/TalebRafiepour/step_progress/stargazers)
[![GitHub Open Issues](https://img.shields.io/github/issues/TalebRafiepour/step_progress?color=red)](https://github.com/TalebRafiepour/step_progress/issues)
[![GitHub Closed Issues](https://img.shields.io/github/issues-closed/TalebRafiepour/step_progress)](https://github.com/TalebRafiepour/step_progress/issues?q=is%3Aissue+is%3Aclosed)
![GitHub License](https://img.shields.io/github/license/TalebRafiepour/step_progress)
[![codecov](https://codecov.io/gh/TalebRafiepour/step_progress/graph/badge.svg)](https://codecov.io/gh/TalebRafiepour/step_progress)


**StepProgress** is a lightweight and highly flexible package designed to display step progress indicators for completing multi-step tasks in a user interface. This package supports both **vertical and horizontal** orientations, allowing developers to customize the display according to their application's needs. It provides a variety of customizable widgets that visually represent the progress of a task, making it easier for users to understand their current position and the steps remaining. With this flexibility, **StepProgress** can seamlessly integrate into various UI designs, enhancing user experience across different platforms.

![StepProgress-horizontal-diamond-shape](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-11-stepprogress-diamond-shape.gif?raw=true)


## Features

- **Visual Step Indication**: Clearly displays progress through a sequence of steps, available in both horizontal and vertical orientations.
  
- **Theming and Customization**:
  - **Comprehensive Theme**: Easily customize the look and feel using `StepProgressThemeData`, controlling colors, text styles, and border properties.
  - **Step Sizing**: Adjust the size of step nodes with `stepSize`.
  - **Titles and Subtitles**: Add descriptive labels to each step nodes and lines for enhanced user understanding.
  - **Visibility Control**: Show or hide titles, subtitles, and connecting lines using `StepProgressVisibilityOptions`.
  - **Custom Icons**: Utilize custom icons for step nodes using `nodeIconBuilder`.
  - **Custom Labels**: Use `nodeLabelBuilder` and `lineLabelBuilder` to provide custom labels for step nodes and connecting lines.
  - **Breadcrumb Support**: Display connecting lines as breadcrumbs for a unique visual style using the `isBreadcrumb` property in `StepLineStyle`.
  
- **Interactive Elements**:
  - **Step Tapping**: Enable user interaction with steps using `onStepNodeTapped` callbacks.
  - **Line Tapping**: Provide actions when users tap on the lines connecting steps with `onStepLineTapped`.
  - **Step Change Notification**: Receive callbacks with `onStepChanged` when the current step is updated.
  
- **Programmatic Control**:
  - **`StepProgressController`**: Manage the current step externally, allowing integration with your application's logic.
  - **Initial Step**: Set the starting step with the `currentStep` property.
  - **Reversed**: Display steps in reverse order using the `reversed` property.
  
- **Flexible Layout**:
  - **Dimensions**: Control the width and height of the widget.
  - **Spacing**: Adjust margins and padding for optimal visual placement.

## Showcases

### Example 1: Vertical Step Progress
![StepProgress-vertical](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-1-step-progress-vertical.gif?raw=true)

#### Implementation

```dart
StepProgress(
  totalSteps: 4,
  controller: stepProgressController,
  axis: Axis.vertical,
  nodeTitles: const ['step 1', 'step 2', 'step 3', 'step 4'],
  onStepChanged: (index) {
    debugPrint('on step changed: $index');
  },
  onStepNodeTapped: (index) {
    debugPrint('on step tapped with index: $index');
  },
  onStepLineTapped: (index) {
    debugPrint('on step line tapped with index: $index');
  },
),
```

### Example 2: Horizontal Step Progress without Labels
![StepProgress-without-labels](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-2-step-progress-without-labels.gif?raw=true)

#### Implementation

```dart
StepProgress(
  totalSteps: 5,
  padding: const EdgeInsets.symmetric(horizontal: 24),
  controller: _stepProgressController,
  onStepChanged: (currentIndex) {
    setState(() {
      currentStep = currentIndex;
    });
  },
),
```

### Example 3: Horizontal Step Progress without Nodes
![StepProgress-without-nodes](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-3-step-line-mode.gif?raw=true)

#### Implementation

```dart
StepProgress(
  totalSteps: 5,
  visibilityOptions: StepProgressVisibilityOptions.lineOnly,
  controller: stepProgressController,
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
    highlightCompletedSteps: false,
    stepLineStyle: StepLineStyle(
      lineThickness: 9,
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  ),
),
```

### Example 4: Horizontal Step Progress Line Mode - Customized
![StepProgress-line-mode](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-4-step-line-mode.gif?raw=true)

#### Implementation

```dart
Row(
  children: [
    TextButton.icon(
      onPressed: stepProgressController.previousStep,
      label: const Text('PREV'),
      icon: const Icon(Icons.arrow_back_ios),
    ),
    Expanded(
      child: StepProgress(
        totalSteps: 5,
        visibilityOptions: StepProgressVisibilityOptions.lineOnly,
        controller: stepProgressController,
        theme: const StepProgressThemeData(
          defaultForegroundColor: Color(0xFFeeeee4),
          activeForegroundColor: Color(0xFF1A76D2),
        ),
      ),
    ),
    TextButton.icon(
      onPressed: stepProgressController.nextStep,
      label: const Text('NEXT'),
      icon: const Icon(Icons.arrow_forward_ios),
      iconAlignment: IconAlignment.end,
    ),
  ],
),
```

### Example 5: Horizontal Step Progress Custom Node Icon
![StepProgress-custom-node-icon](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-5-step-progress-custom-icon.gif?raw=true)

#### Implementation

```dart
StepProgress(
  totalSteps: 4,
  margin: const EdgeInsets.symmetric(horizontal: 12),
  controller: stepProgressController,
  nodeIconBuilder: (index, completedStepIndex) {
    if (index <= completedStepIndex) {
      return Text(
        '${index + 1}',
        style: const TextStyle(
          fontSize: 24,
          color: Color(0xFFb1acaa),
        ),
      );
    } else {
      return Text(
        '${index + 1}',
        style: const TextStyle(
          fontSize: 24,
          color: Color(0xFFa2a2ab),
        ),
      );
    }
  },
  theme: const StepProgressThemeData(
    defaultForegroundColor: Colors.white,
    activeForegroundColor: Colors.white,
    borderWidth: 4,
    activeBorderColor: Color(0xFF2d9ada),
    borderColor: Color(0xFFdee0e2),
    stepLineStyle: StepLineStyle(lineThickness: 0),
  ),
),
```

### Example 6: Horizontal Step Progress with Positioned Label
![StepProgress-positioned-labels](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-6-step-progress-position-labels.gif?raw=true)

#### Implementation

```dart
StepProgress(
  totalSteps: 4,
  controller: stepProgressController,
  nodeTitles: const ['Step 1', 'Step 2', 'Step 3', 'Step 4'],
  theme: const StepProgressThemeData(
    stepLabelAlignment: StepLabelAlignment.topBottom,
    stepLineSpacing: 2,
    stepLineStyle: StepLineStyle(lineThickness: 2),
  ),
),
```

### Example 7: Horizontal Step Progress Node Only
![StepProgress-node-only](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-7-step-progress-without-lines.gif?raw=true)

#### Implementation

```dart
StepProgress(
  totalSteps: 4,
  controller: stepProgressController,
  visibilityOptions: StepProgressVisibilityOptions.nodeOnly,
  nodeSubTitles: const ['sub 1', 'sub 2', 'sub 3', 'sub 4'],
  padding: const EdgeInsets.all(18),
  theme: const StepProgressThemeData(
    stepLabelAlignment: StepLabelAlignment.right,
    nodeLabelStyle: StepLabelStyle(labelAxisAlignment: CrossAxisAlignment.start),
  ),
),
```

### Example 8: Vertical Step Progress with lineSpacing
![StepProgress-vertical-lineSpacing](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-8-stepprogress-vertical-line-spacing.gif?raw=true)

#### Implementation

```dart
StepProgress(
  totalSteps: 4,
  controller: stepProgressController,
  axis: Axis.vertical,
  height: 300,
  nodeTitles: const [
    'Step 1',
    'Step 2',
    'Step 3',
    'Step 4',
  ],
  padding: const EdgeInsets.all(18),
  theme: const StepProgressThemeData(
    stepLabelAlignment: StepLabelAlignment.left,
    nodeLabelStyle: StepLabelStyle(
      labelAxisAlignment: CrossAxisAlignment.start,
    ),
    stepLineSpacing: 24,
    stepLineStyle: StepLineStyle(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
  ),
),
```

### Example 9: Horizontal Step Progress with Square shape
![StepProgress-horizontal-square-shape](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-9-stepprogress-square-shape.gif?raw=true)

#### Implementation

```dart
StepProgress(
  totalSteps: 4,
  controller: stepProgressController,
  nodeTitles: const [
    'Step 1',
    'Step 2',
    'Step 3',
    'Step 4',
  ],
  padding: const EdgeInsets.all(18),
  theme: const StepProgressThemeData(
    shape: StepNodeShape.square,
    stepLabelAlignment: StepLabelAlignment.top,
    stepLineSpacing: 24,
    stepNodeStyle: StepNodeStyle(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      activeDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
    ),
    stepLineStyle: StepLineStyle(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
  ),
),
```

### Example 10: Horizontal Step Progress with Triangle shape
![StepProgress-horizontal-triangle-shape](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-10-stepprogress-triangle-shape.gif?raw=true)

#### Implementation

```dart
StepProgress(
  totalSteps: 4,
  controller: stepProgressController,
  visibilityOptions: StepProgressVisibilityOptions.nodeOnly,
  nodeTitles: const [
    'Step 1',
    'Step 2',
    'Step 3',
    'Step 4',
  ],
  padding: const EdgeInsets.all(18),
  theme: const StepProgressThemeData(
    shape: StepNodeShape.triangle,
    stepLabelAlignment: StepLabelAlignment.left,
    stepNodeStyle: StepNodeStyle(
      activeIcon: null,
    ),
  ),
  ),
```

### Example 11: Horizontal Step Progress with Diamond shape
![StepProgress-horizontal-diamond-shape](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-11-stepprogress-diamond-shape.gif?raw=true)

#### Implementation

```dart
StepProgress(
  totalSteps: 4,
  stepSize: 24,
  controller: stepProgressController,
  nodeTitles: const [
    'Step 1',
    'Step 2',
    'Step 3',
    'Step 4',
  ],
  padding: const EdgeInsets.all(18),
  theme: const StepProgressThemeData(
    shape: StepNodeShape.diamond,
    stepLineSpacing: 18,
    stepLineStyle: StepLineStyle(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    nodeLabelStyle: StepLabelStyle(
      margin: EdgeInsets.only(bottom: 6),
    ),
    stepNodeStyle: StepNodeStyle(
      activeIcon: null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
    ),
  ),
),
```

### Example 12: Vertical Step Progress with Hexagon shape
![StepProgress-vertical-hexagon-shape](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-12-step-progress-vertical-hexagon-shape.gif?raw=true)

#### Implementation

```dart
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
    stepLabelAlignment: StepLabelAlignment.leftRight,
    shape: StepNodeShape.hexagon,
    stepLineSpacing: 18,
    stepLineStyle: StepLineStyle(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
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
```

### Example 13: Vertical Step Progress with Star shape
![StepProgress-vertical-star-shape](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-13-stepprogress-vertical-star-shape.gif?raw=true)

#### Implementation

```dart
StepProgress(
  totalSteps: 4,
  stepSize: 28,
  height: 390,
  axis: Axis.vertical,
  controller: stepProgressController,
  padding: const EdgeInsets.all(18),
  theme: const StepProgressThemeData(
    stepLabelAlignment: StepLabelAlignment.left,
    shape: StepNodeShape.star,
    stepLineSpacing: 18,
    stepLineStyle: StepLineStyle(
      lineThickness: 3,
      borderRadius: BorderRadius.all(
        Radius.circular(3),
      ),
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
```
### Example 14: Horizontal Step Progress with Line Labels
![StepProgress-horizontal-with-line-labels](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-14-stepprogress-line-labels.png?raw=true)

#### Implementation

```dart
StepProgress(
totalSteps: 4,
padding: const EdgeInsets.all(10),
lineTitles: const [
  'line title 1',
  'line title 2',
  'line title 3',
],
controller: stepProgressController,
nodeIconBuilder: (index, completedStepIndex) {
  if (index <= completedStepIndex) {
    return const Icon(
      Icons.check,
      color: Colors.white,
    );
  } else {
    return const Icon(
      Icons.more_horiz,
      color: Colors.white,
    );
  }
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
```
### Example 15: Customized Vertical Step Progress with Line Labels and Node Labels.
![StepProgress-vertical-customized-with-line-labels](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-15-stepprogress-custom-with-line-labels.png?raw=true)

#### Implementation

```dart
StepProgress(
  totalSteps: 6,
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
      spacing: 2,
      children: [
        Text(
          'Invisalign ClinCheck $index',
          maxLines: 3,
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
)
```
### Example 16: Horizontal Step Progress with Breadcrumb Lines.
![StepProgress-horizontal-with-breadcrumb-lines](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/sample-16-stepprogress-breadcrumb-lines.png?raw=true)

#### Implementation

```dart
StepProgress(
  totalSteps: 5,
  padding: const EdgeInsets.all(10),
  controller: stepProgressController,
  lineSubTitles: const [
    'Step 2',
    'Step 3',
    'Step 4',
    'Step 5',
  ],
  theme: const StepProgressThemeData(
    stepLineSpacing: 28,
    stepLineStyle: StepLineStyle(
      lineThickness: 10,
      isBreadcrumb: true,
    ),
  ),
)
```

## Installation

To use StepProgress, add it to your `pubspec.yaml` file:
```yaml
dependencies:
  step_progress: latest_version
```
Then, run the following command to install the package:
```bash
flutter pub get
```

## Usage

To use StepProgress in your Flutter app, first import the package:

```dart
import 'package:step_progress/step_progress.dart';
```

### Initialize Your StepProgressController

```dart
final _stepProgressController = StepProgressController(totalStep: 4);
```

### Then Pass Your StepProgressController to the StepProgress Widget

```dart
StepProgress(
  controller: _stepProgressController,
  totalSteps: 4,
  onStepChanged: (index) {
    debugPrint('on step changed: $index');
  },
),
```
## StepProgressThemeData parameters

| Property                | Description                                        | Type                | Default Value                       |
|-------------------------|----------------------------------------------------|---------------------|-------------------------------------|
|`defaultForegroundColor` | The default color of the step nodes.               | Color               | `Color.fromARGB(255, 191, 196, 195)`|
|`activeForegroundColor`  | The color of the active step node.                 | Color               | `Color.fromARGB(255, 0, 167, 160)`  |
|`highlightCompletedSteps`| Whether to highlight completed steps.              | bool                | `true`                              |
|`borderColor`            | The color of the border around the step nodes.     | Color               | `Colors.white`                      |
|`activeBorderColor`      | The color of the border when the step is active.   | Color?              |`null`                               |
|`borderWidth`            | The width of the border around the step nodes.     | double              | `0.0`                               |
|`enableRippleEffect`     | Whether to enable the ripple effect on step nodes. | bool                | `false`                             |
|`shape`                  | The shape of the step nodes (e.g., circle, square).| StepNodeShape       | `StepNodeShape.circle`              |
|`stepAnimationDuration`  | The duration of the animation for step transitions.| Duration            |`Duration(milliseconds: 150)`        |
|`stepLineSpacing`        | The spacing between step lines.                    | double              | `0.0`                               |
|`nodeLabelAlignment`     | The alignment of the labels for the step nodes.    | StepLabelAlignment? |`null`                               |
|`lineLabelAlignment`     | The alignment of the labels for the step lines.    | Alignment?          |`null`                               |
|`nodeLabelStyle`         | The style of the labels for the step nodes.        | StepLabelStyle      | `StepLabelStyle()`                  |
|`lineLabelStyle`         | The style of the labels for the step lines.        | StepLabelStyle      | `StepLabelStyle(maxWidth: double.infinity)`|
|`stepNodeStyle`          | The style of the step nodes.                       | StepNodeStyle       | `StepNodeStyle()`                   |
|`stepLineStyle`          | The style of the lines connecting the step nodes.  | StepLineStyle       | `StepLineStyle()`                   |
|`rippleEffectStyle`      | The style of the ripple effect on step nodes.      | RippleEffectStyle   | `RippleEffectStyle()`               |


## StepNodeStyle Properties

| Property               | Type            | Description                                                                                                  | Default Value|
| ---------------------- | --------------- | ------------------------------------------------------------------------------------------------------------ | ----------------------------- |
|`defaultForegroundColor`| `Color?`        | The default color for the foreground of the step node. If not set, it will be read from the theme.           | `null` |
|`activeForegroundColor` | `Color?`        | The color for the foreground of the step node when it is active. If not set, it will be read from the theme. | `null` |
|`animationDuration`     | `Duration?`     | The duration of the animation for the step node. If not set, it will be read from the theme.                 | `null` |
|`iconColor`             | `Color`         | The color of the icon.                             | `const Color.fromARGB(253, 6, 138, 129)` (teal color)                                    |
|`shape`                 | `StepNodeShape` | The shape of the step node.                                                                                  | `null` |
|`decoration`            | `BoxDecoration` | The decoration of the step node.                   | `const BoxDecoration(color: Color.fromARGB(50, 255, 255, 255))` (semi-transparent white) |
|`activeDecoration`      | `BoxDecoration` | The decoration of the step node when it is active.                                                           | `null` |
|`icon`                  | `Widget?`       | The icon widget to display.                                                                                  | `null` |
|`activeIcon`            | `Widget?`       | The icon widget to display when the step is active.| `const Icon(Icons.check, size: 18, color: Colors.white)`                                 |
|`enableRippleEffect`    | `bool`          | Whether to enable the ripple effect.               | `true`                                                                                   |


## RippleEffectStyle Properties

| Property           | Type         | Description                                                                               | Default Value |
|--------------------|--------------|-------------------------------------------------------------------------------------------|---------------|
| `foregroundColor`  | `Color?`     | The color of the ripple effect's foreground. If `null`, the theme determines the color.   | `null`        |
| `animationDuration`| `Duration?`  | The duration of the ripple effect animation. If `null`, the theme determines the duration.| `null`        |
| `borderColor`      | `Color?`     | The color of the ripple effect's border. If `null`, the theme determines the color.       | `null`        |
| `borderWidth`      | `double`     | The width of the ripple effect's border.                                                  | `1`           |


## StepLineStyle Properties

| Property           | Type          | Description                                                                            | Default Value         |
|--------------------|---------------|----------------------------------------------------------------------------------------|-----------------------|
| `foregroundColor`  | `Color?`      | The color of the step line. If not set, it will be determined by the theme.            | `null`                |
| `activeColor`      | `Color?`      | The color used when the step is active. If not set, it will be determined by the theme.| `null`                |
| `animationDuration`| `Duration?`   | The duration of the animation. If not set, it will be determined by the theme.         | `null`                |
| `lineThickness`    | `double`      | The thickness of the line in the step progress.                                        | `4.0`                 |
| `borderRadius`     | `BorderRadius`| The border radius of the line in the step progress.                                    | `BorderRadius.zero`   |
| `isBreadcrumb`     | `bool`        | Indicates whether the step line is displayed as a breadcrumb.                          | `false`               |
| `chevronAngle`     | `double`      | Specifies the angle of the chevron in the step line.                                   | `30.0`                |


## StepLabelStyle Properties

| Property             | Type                | Default Value              | Description                                                                 |
| -------------------- | ------------------- | -------------------------- | --------------------------------------------------------------------------- |
| `labelAxisAlignment` | `CrossAxisAlignment`| `CrossAxisAlignment.center`| The alignment of the label along the cross axis.                            |
| `titleStyle`         | `TextStyle?`        | `null`                     | The style to use for the title text.                                        |
| `subTitleStyle`      | `TextStyle?`        | `null`                     | The style to use for the subtitle text.                                     |
| `activeColor`        | `Color?`            | `null`                     | The color to use when the step is active.                                   |
| `defualtColor`       | `Color?`            | `null`                     | The color to use when the step is not active.                               |
| `textAlign`          | `TextAlign`         | `TextAlign.center`         | How the text should be aligned horizontally.                                |
| `titleMaxLines`      | `int`               | `3`                        | The maximum number of lines for the title text.                             |
| `maxWidth`           | `double`            | `48`                       | The maximum width of the step label.                                        |
| `subTitleMaxLines`   | `int`               | `3`                        | The maximum number of lines for the subtitle text.                          |
| `overflow`           | `TextOverflow`      | `TextOverflow.ellipsis`    | How visual overflow should be handled.                                      |
| `padding`            | `EdgeInsets`        | `EdgeInsets.zero`          | The amount of space to surround the label with.                             |
| `margin`             | `EdgeInsets`        | `EdgeInsets.all(2)`        | The amount of space to surround the label with.                             |
| `animationDuration`  | `Duration?`         | `null`                     | The duration of the animation when the style changes.                       |

--------------
## Support the Package

We appreciate your support for the StepProgress package! You can help us by:

- Liking the package on [pub.dev](https://pub.dev/packages/step_progress).
- Starring the repository on [GitHub](https://github.com/TalebRafiepour/step_progress).
- Reporting any issues or bugs you encounter [here](https://github.com/TalebRafiepour/step_progress/issues).

Your contributions and feedback are invaluable to us!

## Donate

**If you wants to support me: <a href="https://github.com/TalebRafiepour/TalebRafiepour/blob/main/DONATE.md" alt="Donate button"><img src="https://img.shields.io/badge/-Donate-red?logo=undertale" /></a>**

## License

`StepProgress` is released under the `BSD-3-Clause` License.

## Contact Me 📨

Feel free to reach out to me through the following platforms:

<a href="https://github.com/TalebRafiepour"><img src="https://img.icons8.com/ios-glyphs/344/github.png" width="40px"/></a>
<a href="https://www.linkedin.com/in/taleb-rafiepour/"><img src="https://img.icons8.com/color/344/linkedin.png" width="40px"/></a>
<a href="mailto:taleb.r75@gmail.com"><img src="https://img.icons8.com/color/344/gmail-new.png" width="40px"/></a>

I look forward to connecting with you!