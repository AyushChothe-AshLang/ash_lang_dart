abstract class Node<T> {
  late T value;
  @override
  String toString() => "$runtimeType";
}

abstract class NumberNode<T> implements Node<T> {}

abstract class BinaryOpNode implements Node {
  Node left, right;
  String op;
  BinaryOpNode({
    required this.left,
    required this.right,
    required this.op,
  });
  @override
  String toString() => "($left$op$right)";

  @override
  dynamic value;
}

abstract class BinaryOpNumberNode extends BinaryOpNode {
  BinaryOpNumberNode({
    required super.left,
    required super.right,
    required super.op,
  });
}

abstract class BinaryOpBooleanNode extends BinaryOpNode {
  BinaryOpBooleanNode({
    required super.left,
    required super.right,
    required super.op,
  });
}

abstract class UnaryNode implements Node<Node> {
  @override
  Node value;
  String op;
  UnaryNode({
    required this.value,
    required this.op,
  });
  @override
  String toString() => "($op$value)";
}
