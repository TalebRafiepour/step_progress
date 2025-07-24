import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/step_progress_controller.dart';

void main() {
  group('StepProgressController', () {
    test('initial state is set correctly', () {
      final controller = StepProgressController(initialStep: 1, totalSteps: 5);
      expect(controller.currentStep, 1);
      expect(controller.totalSteps, 5);
    });

    test('nextStep increments the current step', () {
      final controller = StepProgressController(totalSteps: 5)..nextStep();
      expect(controller.currentStep, 1);
    });

    test('previousStep decrements the current step', () {
      final controller = StepProgressController(initialStep: 1, totalSteps: 5)
        ..previousStep();
      expect(controller.currentStep, 0);
    });

    test('nextStep does not increment beyond total steps', () {
      final controller = StepProgressController(initialStep: 4, totalSteps: 5)
        ..nextStep();
      expect(controller.currentStep, 4);
    });

    test('previousStep does not decrement below -1', () {
      final controller = StepProgressController(totalSteps: 5)..previousStep();
      expect(controller.currentStep, -1);
    });

    test('listeners are notified when step changes', () {
      final controller = StepProgressController(totalSteps: 5);
      bool notified = false;
      controller
        ..addListener(() {
          notified = true;
        })
        ..nextStep();
      expect(notified, true);
    });
  });

  group('StepProgressController play and pause functions', () {
    test('playAnimation is called', () {
      final controller = StepProgressController(totalSteps: 3);
      bool played = false;
      controller.playAnimation = () {
        played = true;
      };
      controller.playAnimation();
      expect(played, true);
    });

    test('pauseAnimation is called', () {
      final controller = StepProgressController(totalSteps: 3);
      bool paused = false;
      controller.pauseAnimation = () {
        paused = true;
      };
      controller.pauseAnimation();
      expect(paused, true);
    });

    test('isAnimating returns true when set to true', () {
      final controller = StepProgressController(totalSteps: 3)
        ..isAnimating = () => true;
      expect(controller.isAnimating(), true);
    });

    test('isAnimating returns false when set to false', () {
      final controller = StepProgressController(totalSteps: 3)
        ..isAnimating = () => false;
      expect(controller.isAnimating(), false);
    });

    test('playAnimation and pauseAnimation can be swapped', () {
      final controller = StepProgressController(totalSteps: 3);
      bool played = false;
      bool paused = false;
      controller
        ..playAnimation = () {
          played = true;
        }
        ..pauseAnimation = () {
          paused = true;
        };
      controller.playAnimation();
      controller.pauseAnimation();
      expect(played, true);
      expect(paused, true);
    });

    test('isAnimating can be dynamically changed', () {
      final controller = StepProgressController(totalSteps: 3)
        ..isAnimating = () => false;
      expect(controller.isAnimating(), false);
      controller.isAnimating = () => true;
      expect(controller.isAnimating(), true);
    });

    test('playAnimation default does nothing', () {
      final controller = StepProgressController(totalSteps: 3);
      expect(() => controller.playAnimation(), returnsNormally);
    });

    test('pauseAnimation default does nothing', () {
      final controller = StepProgressController(totalSteps: 3);
      expect(() => controller.pauseAnimation(), returnsNormally);
    });

    test('isAnimating default returns false', () {
      final controller = StepProgressController(totalSteps: 3);
      expect(controller.isAnimating(), false);
    });
  });
}
