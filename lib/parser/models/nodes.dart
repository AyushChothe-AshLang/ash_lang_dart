import 'package:ash_lang/parser/models/node.dart';

class NumberNode implements Node {
  double value;
  NumberNode({
    required this.value,
  });
  @override
  String toString() => "$value";
}

class AddNode extends BinaryOpNode {
  AddNode({required super.left, required super.right}) : super(op: '+');
}

class SubstractNode extends BinaryOpNode {
  SubstractNode({required super.left, required super.right}) : super(op: '-');
}

class MultiplyNode extends BinaryOpNode {
  MultiplyNode({required super.left, required super.right}) : super(op: '*');
}

class DivideNode extends BinaryOpNode {
  DivideNode({required super.left, required super.right}) : super(op: '/');
}

class PowerNode extends BinaryOpNode {
  PowerNode({required super.left, required super.right}) : super(op: '^');
}

class UnaryPlus extends UnaryNode {
  UnaryPlus({required super.node}) : super(op: '+');
}

class UnaryMinus extends UnaryNode {
  UnaryMinus({required super.node}) : super(op: '-');
}

class LessThanNode extends BinaryOpNode {
  LessThanNode({required super.left, required super.right}) : super(op: '<');
}

class LessThanEqNode extends BinaryOpNode {
  LessThanEqNode({required super.left, required super.right}) : super(op: '<=');
}

class GreaterThanNode extends BinaryOpNode {
  GreaterThanNode({required super.left, required super.right}) : super(op: '>');
}

class GreaterThanEqNode extends BinaryOpNode {
  GreaterThanEqNode({required super.left, required super.right})
      : super(op: '>=');
}

class EqualityNode extends BinaryOpNode {
  EqualityNode({required super.left, required super.right}) : super(op: '==');
}

class EOFNode implements Node {}
