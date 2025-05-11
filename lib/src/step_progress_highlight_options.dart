/// An enumeration that defines the available options for highlighting
/// steps in a step progress indicator. This can be used to customize
/// the appearance or behavior of highlighted steps.
enum StepProgressHighlightOptions {
  /// Highlights the current node in the step progress.
  highlightCurrentNode,
  /// Highlights the current line in the step progress.
  highlightCurrentLine,
  /// Highlights both the current node and line in the step progress.
  highlightCurrentNodeAndLine,
  /// Highlights the completed nodes in the step progress.
  highlightCompletedNodes,
  /// Highlights the completed lines in the step progress.
  highlightCompletedLines,
  /// Highlights both the completed nodes and lines in the step progress.
  highlightCompletedNodesAndLines,
}
