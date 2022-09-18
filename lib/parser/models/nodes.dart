import 'package:ash_lang/parser/models/node.dart';

class IntNumberNode implements NumberNode<int> {
  @override
  int value;
  IntNumberNode({
    required this.value,
  });
  @override
  String toString() => "$runtimeType:$value";
}

class DoubleNumberNode implements NumberNode<double> {
  @override
  double value;
  DoubleNumberNode({
    required this.value,
  });
  @override
  String toString() => "$runtimeType:$value";
}

class StringNode implements Node<String> {
  @override
  String value;
  StringNode({
    required this.value,
  });
  @override
  String toString() => "$runtimeType:$value";
}

class BooleanNode implements Node<bool> {
  @override
  bool value;
  BooleanNode({
    required this.value,
  });
  @override
  String toString() => "$runtimeType:$value";
}

class IdentifierNode implements Node<String> {
  @override
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

  @override
  dynamic value;
}

class FunctionDeclarationNode implements Node {
  IdentifierNode fnId;
  List<IdentifierNode> params;
  BlockStatementNode body;

  FunctionDeclarationNode({
    required this.fnId,
    required this.params,
    required this.body,
  });
  @override
  String toString() => "fn $fnId(${params.join(',')}){$body}";

  @override
  dynamic value;
}

class FunctionCallNode implements Node {
  IdentifierNode fnId;
  List<Node> args;
  FunctionCallNode({
    required this.fnId,
    required this.args,
  });
  @override
  String toString() => "$fnId($args)";

  @override
  dynamic value;
}

class ReturnNode implements Node<Node> {
  @override
  Node value;
  ReturnNode({
    required this.value,
  });
}

class WhileLoopNode implements Node {
  BinaryOpBooleanNode condition;
  BlockStatementNode block;
  WhileLoopNode({
    required this.condition,
    required this.block,
  });
  @override
  String toString() => "while($condition){$block}";

  @override
  dynamic value;
}

class IfStatementNode implements Node {
  BinaryOpBooleanNode condition;
  BlockStatementNode trueBlock;
  List<ElifStatementNode> elifBlocks;
  BlockStatementNode? elseBlock;
  IfStatementNode({
    required this.condition,
    required this.trueBlock,
    this.elifBlocks = const [],
    this.elseBlock,
  });
  @override
  String toString() =>
      "if($condition){$trueBlock}${elifBlocks.join('')}else{$elseBlock}";

  @override
  dynamic value;
}

class ElifStatementNode implements Node {
  BinaryOpBooleanNode condition;
  BlockStatementNode trueBlock;
  ElifStatementNode({
    required this.condition,
    required this.trueBlock,
  });
  @override
  String toString() => "elif($condition){$trueBlock}";

  @override
  dynamic value;
}

class AddNode extends BinaryOpNumberNode {
  AddNode({required super.left, required super.right}) : super(op: '+');
}

class SubtractNode extends BinaryOpNumberNode {
  SubtractNode({required super.left, required super.right}) : super(op: '-');
}

class MultiplyNode extends BinaryOpNumberNode {
  MultiplyNode({required super.left, required super.right}) : super(op: '*');
}

class DivideNode extends BinaryOpNumberNode {
  DivideNode({required super.left, required super.right, required super.op});
}

class ModulusNode extends BinaryOpNumberNode {
  ModulusNode({required super.left, required super.right}) : super(op: '%');
}

class PowerNode extends BinaryOpNumberNode {
  PowerNode({required super.left, required super.right}) : super(op: '^');
}

class UnaryPlus extends UnaryNode {
  UnaryPlus({required super.value}) : super(op: '+');
}

class UnaryMinus extends UnaryNode {
  UnaryMinus({required super.value}) : super(op: '-');
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

class NotEqualsNode extends BinaryOpBooleanNode {
  NotEqualsNode({required super.left, required super.right}) : super(op: '!=');
}

class LogicalAndNode extends BinaryOpBooleanNode {
  LogicalAndNode({required super.left, required super.right}) : super(op: '&');
}

class LogicalOrNode extends BinaryOpBooleanNode {
  LogicalOrNode({required super.left, required super.right}) : super(op: '|');
}

class DeclarationNode extends BinaryOpNode {
  DeclarationNode({
    required IdentifierNode super.left,
    required super.right,
  }) : super(op: '=');
}

class MultiDeclarationNode extends Node {
  List<DeclarationNode> declarations;
  MultiDeclarationNode({required this.declarations});
}

class AssignmentNode extends BinaryOpNode {
  AssignmentNode({
    required IdentifierNode super.left,
    required super.right,
    required super.op,
  });
}

class BreakNode implements Node {
  @override
  dynamic value;
}

class ContinueNode implements Node {
  @override
  dynamic value;
}

class NullNode implements Node {
  @override
  dynamic value;
}

class EOFNode implements Node {
  @override
  dynamic value;
}
