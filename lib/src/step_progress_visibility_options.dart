/// Defines the visibility options for displaying steps in a step progress
/// indicator.
///
/// - [nodeOnly]: Only the node (step indicator) is visible.
/// - [lineOnly]: Only the connecting line between steps is visible.
/// - [nodeThenLine]: The node is shown first, followed by the connecting
/// line.
/// - [lineThenNode]: The connecting line is shown first, followed by the
/// node.
enum StepProgressVisibilityOptions {
  nodeOnly,
  lineOnly,
  nodeThenLine,
  lineThenNode,
}
