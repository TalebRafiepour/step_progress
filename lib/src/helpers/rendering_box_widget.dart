import 'package:flutter/material.dart';

/// A widget that notifies a [ValueNotifier] with its [RenderBox] after the
/// widget has been rendered.
///
/// This widget takes a [child] widget and a [ValueNotifier] of
/// type [RenderBox?].
/// After the widget is rendered, it updates the [boxNotifier] with the
/// [RenderBox] of the widget.
///
/// This can be useful for obtaining the size and position of the widget after
/// it has been laid out.
///
/// Example usage:
/// ```dart
/// ValueNotifier<RenderBox?> boxNotifier = ValueNotifier<RenderBox?>(null);
///
/// RenderingBoxWidget(
///   child: YourWidget(),
///   boxNotifier: boxNotifier,
/// );
/// ```
///
/// The [boxNotifier] can then be used to access the [RenderBox] and its
/// properties.
class RenderingBoxWidget extends StatelessWidget {
  const RenderingBoxWidget({
    required this.child,
    required this.boxNotifier,
    super.key,
  });

  /// A widget that will be rendered within this box.
  final Widget child;

  /// A notifier that holds a reference to a RenderBox.
  final ValueNotifier<RenderBox?> boxNotifier;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      boxNotifier.value = context.findRenderObject() as RenderBox?;
    });
    return child;
  }
}
