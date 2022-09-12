import 'dart:math';

import 'package:ash_lang/interpreter/models/scope.dart';
import 'package:ash_lang/interpreter/models/value.dart';
import 'package:ash_lang/interpreter/models/values.dart';
import 'package:ash_lang/parser/models/node.dart';
import 'package:ash_lang/parser/models/nodes.dart';

class Interpreter {
  final Node ast;

  Interpreter({required this.ast});

  Map<String, Function> inbuiltFunctions = {
    'print': print,
    'min': min,
    'max': max,
  };

  Value? run() {
    Scope globalScope = Scope();
    if (ast is! EOFNode) {
      walk(ast, globalScope);
    }
    return NullValue();
  }

  walk(Node node, Scope scope) {
    if (node is NumberNode) {
      return walkNumberNode(node, scope);
    } else if (node is StringNode) {
      return walkStringNode(node, scope);
    } else if (node is BooleanNode) {
      return walkBooleanNode(node, scope);
    } else if (node is UnaryNode) {
      return walkUnaryNode(node, scope);
    } else if (node is IdentifierNode) {
      return getCorrectValueType(scope.getSymbol(node.value));
    } else if (node is BinaryOpNode) {
      return walkBinaryOpNode(node, scope);
    } else if (node is FunctionCallNode) {
      return walkFunctionCallNode(node, scope);
    } else if (node is BlockStatementNode) {
      return walkBlockStatementNode(node, scope);
    }
    return null;
  }

  NumberValue walkNumberNode(NumberNode node, Scope scope) {
    return NumberValue(value: node.value);
  }

  StringValue walkStringNode(StringNode node, Scope scope) {
    return StringValue(value: node.value);
  }

  BooleanValue walkBooleanNode(BooleanNode node, Scope scope) {
    return BooleanValue(value: node.value);
  }

  NumberValue walkUnaryNode(UnaryNode node, Scope scope) {
    String op = node.op;
    switch (op) {
      case '+':
        return NumberValue(value: (walk(node, scope) as NumberNode).value);
      case '-':
        return NumberValue(value: -(walk(node, scope) as NumberNode).value);
    }
    throw Exception("Runtime Error!");
  }

  Value walkBlockStatementNode(BlockStatementNode node, Scope scope) {
    Scope localScope = Scope(parent: scope);
    for (Node n in node.statements) {
      walk(n, localScope);
    }
    return NullValue();
  }

  Value walkBinaryOpNode(BinaryOpNode node, Scope scope) {
    String op = node.op;
    switch (op) {
      case '+':
        return NumberValue(
            value:
                (walk(node.left, scope)).value + walk(node.right, scope).value);
      case '-':
        return NumberValue(
            value:
                walk(node.left, scope).value - walk(node.right, scope).value);
      case '*':
        return NumberValue(
            value:
                walk(node.left, scope).value * walk(node.right, scope).value);
      case '/':
        return NumberValue(
            value:
                walk(node.left, scope).value / walk(node.right, scope).value);
      case '^':
        return NumberValue(
            value:
                pow(walk(node.left, scope).value, walk(node.right, scope).value)
                    as double);
      case '&':
        return BooleanValue(
            value:
                walk(node.left, scope).value && walk(node.right, scope).value);
      case '|':
        return BooleanValue(
            value:
                walk(node.left, scope).value || walk(node.right, scope).value);
      case '=':
        dynamic right = walk(node.right, scope);
        scope.setSymbol((node as AssignmentNode).id.value, right.value);
        return right;
      case '==':
        return BooleanValue(
            value: (walk(node.left, scope)).value ==
                walk(node.right, scope).value);
      case '<':
        return BooleanValue(
            value:
                walk(node.left, scope).value < walk(node.right, scope).value);
      case '<=':
        return BooleanValue(
            value:
                walk(node.left, scope).value <= walk(node.right, scope).value);
      case '>':
        return BooleanValue(
            value:
                walk(node.left, scope).value > walk(node.right, scope).value);
      case '>=':
        return BooleanValue(
            value:
                walk(node.left, scope).value >= walk(node.right, scope).value);
      default:
        throw Exception("Runtime Error!");
    }
  }

  Value walkFunctionCallNode(FunctionCallNode node, Scope scope) {
    List<dynamic> args = node.args.map((e) => walk(e, scope).value).toList();
    if (inbuiltFunctions.containsKey(node.fn)) {
      dynamic res = Function.apply(inbuiltFunctions[node.fn]!, args);
      return getCorrectValueType(res);
    }
    throw Exception("Runtime Error: Function ${node.fn} Not Found!");
  }

  getCorrectValueType(dynamic res) {
    if (res is num) {
      return NumberValue(value: res as double);
    } else if (res is bool) {
      return BooleanValue(value: res);
    } else if (res is String) {
      return StringValue(value: res);
    }
    return NullValue();
  }
}
