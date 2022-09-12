import 'package:ash_lang/parser/models/node.dart';

class NumberNode implements Node {
  double value;
  NumberNode({
    required this.value,
  });
  @override
  String toString() => "$runtimeType:$value";
}

class StringNode implements Node {
  String value;
  StringNode({
    required this.value,
  });
  @override
  String toString() => "$runtimeType:$value";
}

class BooleanNode implements Node {
  bool value;
  BooleanNode({
    required this.value,
  });
  @override
  String toString() => "$runtimeType:$value";
}

class IdentifierNode implements Node {
  String value;
  IdentifierNode({
    required this.value,
  });

  @override
  String toString() => "$runtimeType:$value";
}

class BlockStatementNode implements Node {
  List<Node> statements;
  BlockStatementNode({
    required this.statements,
  });
  @override
  String toString() => "$statements";
}

class FunctionCallNode implements Node {
  String fn;
  List<Node> args;
  FunctionCallNode({
    required this.fn,
    required this.args,
  });
  @override
  String toString() => "$fn($args)";
}

class AddNode extends BinaryOpNumberNode {
  AddNode({required super.left, required super.right}) : super(op: '+');
}

class SubstractNode extends BinaryOpNumberNode {
  SubstractNode({required super.left, required super.right}) : super(op: '-');
}

class MultiplyNode extends BinaryOpNumberNode {
  MultiplyNode({required super.left, required super.right}) : super(op: '*');
}

class DivideNode extends BinaryOpNumberNode {
  DivideNode({required super.left, required super.right}) : super(op: '/');
}

class PowerNode extends BinaryOpNumberNode {
  PowerNode({required super.left, required super.right}) : super(op: '^');
}

class UnaryPlus extends UnaryNode {
  UnaryPlus({required super.node}) : super(op: '+');
}

class UnaryMinus extends UnaryNode {
  UnaryMinus({required super.node}) : super(op: '-');
}

class LessThanNode extends BinaryOpBooleanNode {
  LessThanNode({required super.left, required super.right}) : super(op: '<');
}

class LessThanEqNode extends BinaryOpBooleanNode {
  LessThanEqNode({required super.left, required super.right}) : super(op: '<=');
}

class GreaterThanNode extends BinaryOpBooleanNode {
  GreaterThanNode({required super.left, required super.right}) : super(op: '>');
}

class GreaterThanEqNode extends BinaryOpBooleanNode {
  GreaterThanEqNode({required super.left, required super.right})
      : super(op: '>=');
}

class EqualityNode extends BinaryOpBooleanNode {
  EqualityNode({required super.left, required super.right}) : super(op: '==');
}

class LogicalAndNode extends BinaryOpBooleanNode {
  LogicalAndNode({required super.left, required super.right}) : super(op: '&');
}

class LogicalOrNode extends BinaryOpNode {
  LogicalOrNode({required super.left, required super.right}) : super(op: '|');
}

class AssignmentNode extends BinaryOpNumberNode {
  IdentifierNode id;
  AssignmentNode({required this.id, required super.right})
      : super(left: id, op: '=');
}

class EOFNode implements Node {}
