import 'dart:math';

import 'package:ash_lang/interpreter/models/scope.dart';
import 'package:ash_lang/interpreter/models/value.dart';
import 'package:ash_lang/interpreter/models/values.dart';
import 'package:ash_lang/parser/models/node.dart';
import 'package:ash_lang/parser/models/nodes.dart';

class Interpreter {
  final Node ast;

  Interpreter({required this.ast});
  Scope globalScope = Scope();

  Map<String, Function> inbuiltFunctions = {
    'print': print,
    'min': min,
    'max': max,
    'int': (String i) => double.parse(i),
    'str': (dynamic i) => i.toString()
  };

  Value? run() {
    if (ast is! EOFNode) {
      (ast as BlockStatementNode)
          .statements
          .add(FunctionCallNode(fnId: IdentifierNode(value: 'main'), args: []));
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
    } else if (node is ReturnNode) {
      return walkReturnNode(node, scope);
    } else if (node is IdentifierNode) {
      return getCorrectValueType(scope.getSymbol(node.value));
    } else if (node is BinaryOpNode) {
      return walkBinaryOpNode(node, scope);
    } else if (node is IfStatementNode) {
      return walkIfStatementNode(node, scope);
    } else if (node is WhileLoopNode) {
      return walkWhileLoopNode(node, scope);
    } else if (node is FunctionDeclarationNode) {
      return walkFunctionDeclarationNode(node, scope);
    } else if (node is FunctionCallNode) {
      return walkFunctionCallNode(node, scope);
    } else if (node is BlockStatementNode) {
      return walkBlockStatementNode(node, scope);
    }
    return NullValue();
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

  ReturnValue walkReturnNode(ReturnNode node, Scope scope) {
    return ReturnValue(value: walk(node.returnNode, scope).value);
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

  Value walkBlockStatementNode(BlockStatementNode node, Scope scope,
      {bool createLocalScope = true}) {
    Scope localScope = Scope(parent: scope);
    for (Node n in node.statements) {
      Value val = walk(n, createLocalScope ? localScope : scope);
      if (val is ReturnValue) {
        return val;
      }
    }
    return NullValue();
  }

  Value walkBinaryOpNode(BinaryOpNode node, Scope scope) {
    String op = node.op;

    if (op == '=') {
      dynamic right = walk(node.right, scope);
      scope.setSymbol((node.left as IdentifierNode).value, right.value);
      return right;
    }

    dynamic left = walk(node.left, scope).value;
    dynamic right = walk(node.right, scope).value;
    switch (op) {
      case '+':
        if (left.runtimeType == right.runtimeType) {
          if (left is double) {
            return NumberValue(value: left + right);
          } else if (left is String) {
            return StringValue(value: left + right);
          }
        } else {
          throw Exception("Runtime Error: '$op' used on invalid operands!");
        }
        break;
      case '-':
        return NumberValue(value: left - right);
      case '*':
        return NumberValue(value: left * right);
      case '/':
        return NumberValue(value: left / right);
      case '%':
        return NumberValue(value: left % right);
      case '^':
        return NumberValue(value: pow(left, right) as double);
      case '&':
        return BooleanValue(value: left && right);
      case '|':
        return BooleanValue(value: left || right);
      case '==':
        return BooleanValue(value: left == right);
      case '<':
        return BooleanValue(value: left < right);
      case '<=':
        return BooleanValue(value: left <= right);
      case '>':
        return BooleanValue(value: left > right);
      case '>=':
        return BooleanValue(value: left >= right);
      default:
        throw Exception("Runtime Error!");
    }
    return NullValue();
  }

  Value walkIfStatementNode(IfStatementNode node, Scope scope) {
    Scope localScope = Scope(parent: scope);
    //Run if block if condition is true
    if (walk(node.condition, localScope).value == true) {
      return walkBlockStatementNode(node.trueBlock, localScope,
          createLocalScope: false);
    }
    //Run elif blocks if condition is true and skip next blocks
    if (node.elifBlocks.isNotEmpty) {
      for (ElifStatementNode elif in node.elifBlocks) {
        localScope = Scope(parent: scope);
        if (walk(elif.condition, localScope).value == true) {
          return walkBlockStatementNode(elif.trueBlock, localScope,
              createLocalScope: false);
        }
      }
    }
    //Run else block if present and condition of all above blocks is false
    if (node.elseBlock != null) {
      localScope = Scope(parent: scope);
      return walkBlockStatementNode(node.elseBlock!, localScope,
          createLocalScope: false);
    }
    return NullValue();
  }

  Value walkWhileLoopNode(WhileLoopNode node, Scope scope) {
    Scope localScope = Scope(parent: scope);
    while (walk(node.condition, localScope).value) {
      Value res = walkBlockStatementNode(node.block, localScope,
          createLocalScope: false);
      if (res is ReturnValue) {
        return res;
      }
    }
    return NullValue();
  }

  Value walkFunctionDeclarationNode(FunctionDeclarationNode node, Scope scope) {
    scope.setSymbol(node.fnId.value, node);
    return NullValue();
  }

  Value walkFunctionCallNode(FunctionCallNode node, Scope scope) {
    if (inbuiltFunctions.containsKey(node.fnId.value)) {
      List<dynamic> args = node.args.map((e) => walk(e, scope).value).toList();
      dynamic res = Function.apply(inbuiltFunctions[node.fnId.value]!, args);
      return getCorrectValueType(res);
    } else {
      dynamic fn = scope.getSymbol(node.fnId.value);
      if (fn is FunctionDeclarationNode) {
        List<IdentifierNode> params = fn.params;

        if (node.args.length != params.length) {
          throw Exception(
              "Runtime Error: Expected ${params.length} arguments found ${node.args.length}!");
        }
        Scope localScope = Scope(parent: scope);
        for (int i = 0; i < params.length; i++) {
          localScope.setSymbol(
              params[i].value, walk(node.args[i], scope).value);
        }
        return walkBlockStatementNode(
          fn.body,
          localScope,
          createLocalScope: false,
        );
      }
    }
    throw Exception("Runtime Error: Function ${node.fnId.value} Not Found!");
  }

  Value getCorrectValueType(dynamic res) {
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
