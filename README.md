# StepProgress
[![Pub Version](https://img.shields.io/pub/v/step_progress.svg?label=pub&color=blue)](https://pub.dev/packages/step_progress/versions)
[![GitHub Stars](https://img.shields.io/github/stars/TalebRafiepour/step_progress?color=yellow&label=Stars)](https://github.com/TalebRafiepour/step_progress/stargazers)
[![GitHub opened issues](https://img.shields.io/github/issues/TalebRafiepour/step_progress?color=red)](https://github.com/TalebRafiepour/step_progress/issues)
[![GitHub closed issues](https://img.shields.io/github/issues-closed/TalebRafiepour/step_progress)](https://github.com/TalebRafiepour/step_progress/issues?q=is%3Aissue+is%3Aclosed)
![GitHub License](https://img.shields.io/github/license/TalebRafiepour/step_progress)

StepProgress is a lightweight package designed to display step progress indicators for completing multi-step tasks in a user interface. It provides customizable widgets to visually represent the progress of a task, making it easier for users to understand their current position and the steps remaining.

## Showcase
![step_progress_demo](https://github.com/TalebRafiepour/showcase/blob/main/step_progress/step_progress.gif?raw=true)

## Installation

To use StepProgress, you need to add it to your pubspec.yaml file:

```yaml
dependencies:
  step_progress: latest_version
```

Then, run `flutter pub get` to install the package.

## Usage
To use StepProgress in your Flutter app, first import the package:

```dart
import 'package:step_progress/step_progress.dart';
```

### Initialize your StepProgressController

```dart
final _stepProgressController =
      StepProgressController(totalStep: 4);
```

### Then pass your StepProgressController to the StepProgress widget and use it

```dart
StepProgress(
            controller: _stepProgressController,
            style: const StepProgressStyle(
              strokeColor: Color(0xff04A7B8),
              valueColor: Colors.white,
              backgroundColor: Color(0xff04A7B5),
              tickColor: Color(0xff04A7B5),
            ),
            onStepChanged: (index) {
              debugPrint('on step changed: $index');
            },
          ),
```
## Support the Package

We appreciate your support for the StepProgress package! You can help us by:

- Liking the package on [pub.dev](https://pub.dev/packages/step_progress).
- Starring the repository on [GitHub](https://github.com/TalebRafiepour/step_progress).
- Reporting any issues or bugs you encounter [here](https://github.com/TalebRafiepour/step_progress/issues).

Your contributions and feedback are invaluable to us!

## License

`StepProgress` is released under the `BSD-3-Clause` License.

## Contact Me 📨

Feel free to reach out to me through the following platforms:

<a href="https://github.com/TalebRafiepour"><img src= "https://img.icons8.com/ios-glyphs/344/github.png" width = "40px"/></a> <a href="https://www.linkedin.com/in/taleb-rafiepour/"><img src= "https://img.icons8.com/color/344/linkedin.png" width = "40px"/></a> <a href="mailto:taleb.r75@gmail.com"><img src= "https://img.icons8.com/color/344/gmail-new.png" width = "40px"/></a>

I look forward to connecting with you!