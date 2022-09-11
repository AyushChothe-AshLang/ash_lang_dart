import 'dart:math';

import 'package:ash_lang/interpreter/models/value.dart';
import 'package:ash_lang/interpreter/models/values.dart';
import 'package:ash_lang/parser/models/node.dart';
import 'package:ash_lang/parser/models/nodes.dart';

class Interpreter {
  final Node ast;

  Interpreter({required this.ast});

  Value run() {
    if (ast != EOFNode) {
      return walk(ast);
    }
    return NullValue();
  }

  walk(Node node) {
    if (node is NumberNode) {
      return walkNumberNode(node);
    } else if (node is UnaryNode) {
      return walkUnaryNode(node);
    } else if (node is BinaryOpNode) {
      return walkBinaryOpNode(node);
    } else {
      throw Exception("Runtime Error");
    }
  }

  NumberValue walkNumberNode(NumberNode node) {
    return NumberValue(value: node.value);
  }

  NumberValue walkUnaryNode(UnaryNode node) {
    String op = node.op;
    switch (op) {
      case '+':
        return NumberValue(value: (walk(node) as NumberNode).value);
      case '-':
        return NumberValue(value: -(walk(node) as NumberNode).value);
    }
    throw Exception("Runtime Error");
  }

  Value walkBinaryOpNode(BinaryOpNode node) {
    String op = node.op;
    switch (op) {
      case '+':
        return NumberValue(
            value: (walk(node.left)).value + walk(node.right).value);
      case '-':
        return NumberValue(
            value: walk(node.left).value - walk(node.right).value);
      case '*':
        return NumberValue(
            value: walk(node.left).value * walk(node.right).value);
      case '/':
        return NumberValue(
            value: walk(node.left).value / walk(node.right).value);
      case '^':
        return NumberValue(
            value:
                pow(walk(node.left).value, walk(node.right).value) as double);
      case '==':
        return BooleanValue(
            value: (walk(node.left)).value == walk(node.right).value);
      case '<':
        return BooleanValue(
            value: walk(node.left).value < walk(node.right).value);
      case '<=':
        return BooleanValue(
            value: walk(node.left).value <= walk(node.right).value);
      case '>':
        return BooleanValue(
            value: walk(node.left).value > walk(node.right).value);
      case '>=':
        return BooleanValue(
            value: walk(node.left).value >= walk(node.right).value);
    }
    throw Exception("Runtime Error");
  }
}
