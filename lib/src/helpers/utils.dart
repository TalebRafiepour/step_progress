import 'package:flutter/material.dart';

abstract class Utils {
  static Size calculateTextSize({
    required String text,
    TextStyle? textStyle,
    int? maxLines,
    double maxWidth = double.infinity,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth.isFinite ? maxWidth : double.infinity);

    return textPainter.size;
  }
}
