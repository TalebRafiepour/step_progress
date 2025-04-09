import 'dart:ui' show Color;

/// A class that defines the style for the outer border of a step progress
/// widget.
///
/// This class can be used to customize the appearance of the outer border,
/// such as its color, width, and other visual properties.
class OutterBorderStyle {
  const OutterBorderStyle({
    this.borderWidth = 2,
    this.defaultBorderColor = const Color.fromARGB(255, 191, 196, 195),
    this.activeBorderColor = const Color.fromARGB(255, 0, 167, 160),
    this.isDotted = false,
    this.dashPattern = const [0.7, 4],
  }) : assert(borderWidth > 0, 'borderWidth must be greater than 0');

  /// The width of the border around the step progress indicator.
  final double borderWidth;

  /// The default color of the border when the step is inactive.
  final Color defaultBorderColor;

  /// The color of the border when the step is active.
  final Color activeBorderColor;

  /// Determines whether the border is rendered as a dotted line.
  final bool isDotted;

  /// The pattern of dashes and gaps for a dotted border.
  final List<double> dashPattern;

  /// Creates a copy of this `OutterBorderStyle` with the given fields replaced
  /// by new values.
  OutterBorderStyle copyWith({
    double? borderWidth,
    Color? defaultBorderColor,
    Color? activeBorderColor,
    bool? isDotted,
    List<double>? dashPattern,
  }) {
    return OutterBorderStyle(
      borderWidth: borderWidth ?? this.borderWidth,
      defaultBorderColor: defaultBorderColor ?? this.defaultBorderColor,
      activeBorderColor: activeBorderColor ?? this.activeBorderColor,
      isDotted: isDotted ?? this.isDotted,
      dashPattern: dashPattern ?? this.dashPattern,
    );
  }
}
