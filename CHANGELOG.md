# 2.7.1
- **Bug Fix**: Resolved an issue where node labels were not displaying correctly when using the `nodeLabelBuilder` callback for custom node label creation.
- **Enhanced Flexibility**: Added the `hasEqualNodeAndLineCount` property, a boolean that when set to `true` ensures equal count of lines and nodes in the widget for improved visual consistency.
- **Testing**: Added comprehensive tests for the new functionality to ensure reliability and proper behavior.
- **Documentation**: Updated the `README.md` file with examples and information about the new features.

# 2.7.0

- **Property Renaming**: Renamed the `stepSize` property to `stepNodeSize` for improved clarity and consistency.
- **Enhanced Visibility Options**: Updated the `StepProgressVisibilityOptions` enum to include the new `lineThenNode` state, allowing the line to appear before the node. This provides greater flexibility and customization, in addition to the default `nodeThenLine` behavior.
- **Testing**: Updated and added new widget tests to ensure compatibility with the latest changes.


# 2.6.2

- **Bug Fix**: Resolved an issue where `autoProgress` did not advance correctly when the previous step exceeded the current step.
- **Code Quality**: Applied Dart formatter to maintain consistent code style and readability.


# 2.6.1

- **Bug Fix**: Resolved an issue where the line would extend incorrectly when the title was large. [#25](https://github.com/TalebRafiepour/step_progress/issues/25)

# 2.6.0
- **Auto Start Progress**: Added the `autoStartProgress` property to the `StepProgress` constructor, enabling automatic progression through steps until completion.
- **Testing**: Introduced and updated widget tests to ensure the new feature functions as intended.
- **Documentation**: Expanded documentation to clarify the new functionality and assist contributors.

# 2.5.3
- **Icon Color Customization**: Introduced the `activeIconColor` property in `StepNodeStyle`, enabling straightforward customization of icon colors for active step nodes.
- **Testing Enhancements**: Expanded and updated widget tests to increase coverage for various states in the `StepLine` and `StepGenerator` widgets.
- **Documentation Improvements**: Enhanced the `README.md` with new examples and improved formatting for better readability.

# 2.5.1
- **License Update**: Amended the `LICENSE` file to reflect the correct legal entity name.
- **Dart SDK Compatibility**: Broadened the Dart SDK constraint to `>=3.0.0 <4.0.0`, ensuring compatibility across a wider spectrum of projects.


# 2.5.0
- **Refactor**: Replaced the `highlightCompletedSteps` property in `StepProgressThemeData` with a new `highlightOptions` enum for improved flexibility and customization.
- **Documentation Update**: Updated the `README.md` file with a new banner and corrected broken links.

# 2.4.1
- **Bug Fix**: Resolved a memory leak by ensuring `StepProgressController` is properly closed when the widget is disposed.

# 2.4.0
- **New Feature**: Introduced support for a dotted border line style, enhancing the visual appeal of step progress indicators. [#15](https://github.com/TalebRafiepour/step_progress/issues/15)
- **Breaking Change**: Updated the `borderRadius` property in `StepLineStyle` to use the `Radius` type instead of `BorderRadius`, ensuring more consistent customization options.

# 2.3.0
- **New Feature**: Added support for breadcrumb line style for enhanced visual representation. [#17](https://github.com/TalebRafiepour/step_progress/issues/17)
- **Bug Fix**: Adjusted the default alignment of step line titles to `topCenter` for improved consistency in horizontal axis.

# 2.2.1
- **Configuration Update**: Modified `analysis_options.yaml` to ignore the trailing commas rule.
- **Code Formatting**: Applied `dart format .` to ensure consistent code style.

# 2.2.0
- **Enhanced Customization**: Introduced `lineLabelAlignment` property in the theme for better positioning of `lineLabels`.
- **New Feature**: Added the `reversed` option to allow users to change the order of steps.
- **Improved Labeling**: Enabled display of `title` and `subtitles` relative to line segments.
- **Code Simplification**: Removed `nodeActiveIconBuilder` in favor of using `nodeIconBuilder` to reduce redundancy.
- **Renaming**: Renamed `stepLabelAlignment` theme property to `nodeLabelAlignment`.
- **New Builders**: Added `nodeLabelBuilder` and `lineLabelBuilder` to create customized labels.
- **Bug Fixes**:
  - Corrected vertical misalignment of lines and nodes.
  - Resolved rendering issue when `lineThickness` exceeds `stepSize`.
- **Documentation**: Updated `README.md` with additional examples showcasing `lineLabels`.
- **Testing**: Added new tests and updated existing ones, increasing code coverage to 96%.

# 2.1.2
- **Bug Fix**: Corrected the misalignment issue with step nodes [#18](https://github.com/TalebRafiepour/step_progress/issues/18).
- **Dependency Update**: Upgraded the Dart SDK to version `3.7.0` for improved compatibility and performance.

# 2.1.0
Here's what's new in version 2.1.0:

*   **Bug Fix:** Resolved line spacing issues that occurred when labels had margins.
*   **New Examples:** Added new examples to showcase the library's capabilities and usage.
*   **Enhanced Step Node Shapes:** Expanded the variety of available shapes for StepNode, including square, circle, triangle, hexagon, and diamond. [#12](https://github.com/TalebRafiepour/step_progress/issues/12).


# 2.0.1
* Move the `CONTRIBUTING.md` file to the root of project.
* Update `topics` of package in pubspec.yaml` file.

# 2.0.0
- **StepLabel Enhancements:**
  - Introduced `StepLabelStyle` for advanced customization.
  - Added animation support for the `StepLabel` widget.

- **StepProgress Improvements:**
  - Implemented `StepProgressTheme` to offer enhanced styling and theme customization.
  - Added support for vertical orientation in `StepProgress`.
  - Added `visibilityOptions` to allow toggling the visibility of lines and nodes.

- **StepLine Customizations:**
  - Added `lineSpacing` and `borderRadius` properties for `StepLine`.
  - Introduced `StepLineStyle` for advance customization of `StepLine`.
  

- **Additional Features:**
  - Launched the `subTitles` functionality to display subtitles beneath titles.
  - Provided the `onStepTapped` callback for custom handling when a step is tapped.
  - Defined the `onStepLineTapped` callback for improved interactivity with the stepper.
  - Enabled the `highlightCompletedSteps` option to control the display of active colors on completed steps.
  - Added callbacks `nodeIconBuilder` and `activeNodeIconBuilder` for custom node icon creation.
  - Rolled out the `activeBorderColor` property in the theme for additional customization.
  - Introduced `stepLabelAlignment` for flexible label positioning.

- **Codebase & Testing Enhancements:**
  - Refactored and optimized the codebase to simplify contributions and ongoing development.
  - Expanded documentation across all files to improve code readability.
  - Developed multiple examples demonstrating key functionalities of the package.
  - Implemented comprehensive unit and widget tests for the most critical widgets and classes.

# 1.0.8
* Updated the `README.md` file.

# 1.0.7
* Updated the `README.md` file.

# 1.0.6
* Updated the `README.md` file.

# 1.0.5
* Introduced the `stepAnimationDuration` property in the constructor.
* Updated the `README.md` file.

# 1.0.4
* Change `LICENSE` from `MIT` to `BSD-3-Clause`.
* Upgrade Dart version to `^3.6.1`.
* Update `README.md` file.

# 1.0.3
* Downgraded Dart version to `^3.5.4`.

# 1.0.2
* Updated the `.gitignore` file to include additional files and directories.
* Made minor updates to the `LICENSE` file for clarity.


# 1.0.1
* Formatted code.

# 1.0.0
* Fixed bug preventing progression to the next step when on the final step.
* Added GitHub Actions for code analysis and running tests on push to the master branch.
* Wrote unit and widget tests.
* Updated documentation.
* Cleaned and refactored code.
* Renamed widget to `StepProgress` from `Progress`.
* Renamed repository to `step_progress` from `step-progress`.

# 0.0.2
* Initialize package
