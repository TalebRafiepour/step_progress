import 'package:flutter/foundation.dart';

/// A controller class that extends [ChangeNotifier] to manage the state and
/// notify listeners about changes in the step progress.
///
/// This class can be used to control the progress of steps in a step progress
/// indicator, allowing for updates and state management.
class StepProgressController extends ChangeNotifier {
  StepProgressController({required this.totalSteps, this.initialStep = 0})
      : assert(totalSteps > 0, 'totalSteps must be greater than 0'),
        assert(
          initialStep < totalSteps,
          'initialStep must be lower than $totalSteps',
        );

  /// The initial step to start from.
  final int initialStep;

  /// The total number of steps.
  final int totalSteps;

  /// The current step, initialized to the initial step.
  late int _currentStep = initialStep;

  /// Returns current step
  int get currentStep => _currentStep;

  /// validate newStep and set it to current step
  void setCurrentStep(int newStep) {
    assert(
      newStep >= -1 && newStep < totalSteps,
      'new step must be equal or greater than -1 and lower than $totalSteps',
    );
    if (_currentStep != newStep) {
      _currentStep = newStep;
      notifyListeners();
    }
  }

  /// Advances to the next step if the current step is not the last one.
  ///
  /// Increments the `currentStep` by one and notifies listeners if the
  /// incremented step is still less than the total number of steps.
  void nextStep() {
    if (_currentStep + 1 < totalSteps) {
      _currentStep++;
      notifyListeners();
    }
  }

  /// Moves to the previous step if the current step is equal or greater than 0.
  /// Decrements the `currentStep` by 1 and notifies listeners.
  void previousStep() {
    if (_currentStep >= 0) {
      _currentStep--;
      notifyListeners();
    }
  }
}
