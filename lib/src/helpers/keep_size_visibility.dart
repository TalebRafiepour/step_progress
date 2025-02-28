import 'package:flutter/material.dart';

/// A widget that shows its [child] when [visible] is true, and when false
/// it is not inserted in the tree—only leaving behind a SizedBox with the
/// previously measured size of the child.
class KeepSizeVisibility extends StatefulWidget {
  const KeepSizeVisibility({
    required this.visible,
    required this.child,
    super.key,
  });

  final bool visible;
  final Widget child;

  @override
  _KeepSizeVisibilityState createState() => _KeepSizeVisibilityState();
}

class _KeepSizeVisibilityState extends State<KeepSizeVisibility> {
  Size _childSize = Size.zero;

  void _onChildSizeChanged(Size newSize) {
    if (_childSize != newSize) {
      _childSize = newSize;
      // rebuild widget tree with calculated child size, when child is invisible
      if (!widget.visible) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.visible) {
      // When visible, wrap the child in a MeasureSize widget to capture
      // its size.
      return MeasureSize(onChange: _onChildSizeChanged, child: widget.child);
    } else if (_childSize != Size.zero) {
      return SizedBox(width: _childSize.width, height: _childSize.height);
    } else {
      // render it to calculate size then remove it after size returned.
      return MeasureSize(onChange: _onChildSizeChanged, child: widget.child);
    }
  }
}

/// A helper widget that reports its own size once laid out.
///
class MeasureSize extends StatefulWidget {
  const MeasureSize({required this.onChange, required this.child, super.key});
  final Widget child;
  final ValueChanged<Size> onChange;

  @override
  _MeasureSizeState createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  @override
  Widget build(BuildContext context) {
    // LayoutBuilder allows us to capture and report the child's size.
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final renderObject = context.findRenderObject();
          if (renderObject is RenderBox) {
            final size = renderObject.size;
            widget.onChange(size);
          }
        });
        return widget.child;
      },
    );
  }
}
