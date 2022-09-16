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
}

class ReturnNode implements Node {
  Node returnNode;
  ReturnNode({
    required this.returnNode,
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

class ModulusNode extends BinaryOpNumberNode {
  ModulusNode({required super.left, required super.right}) : super(op: '%');
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

class LogicalOrNode extends BinaryOpBooleanNode {
  LogicalOrNode({required super.left, required super.right}) : super(op: '|');
}

class AssignmentNode extends BinaryOpNumberNode {
  AssignmentNode({required IdentifierNode super.left, required super.right})
      : super(op: '=');
}

class EOFNode implements Node {}
