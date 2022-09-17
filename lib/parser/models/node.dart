abstract class Node {
  @override
  String toString() => "$runtimeType";
}

abstract class NumberNode implements Node {}

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

abstract class UnaryNode implements Node {
  Node node;
  String op;
  UnaryNode({
    required this.node,
    required this.op,
  });
  @override
  String toString() => "($op$node)";
}
