import 'dart:convert';
import 'dart:io';
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
    'print': (dynamic s) => stdout.write(s),
    'println': (dynamic s) => stdout.writeln(s),
    'input': ([String msg = ""]) {
      stdout.write(msg);
      return stdin.readLineSync();
    },
    'min': min,
    'max': max,
    'int': (dynamic i) => i is double ? i.toInt() : int.parse(i.toString()),
    'double': (dynamic i) =>
        i is int ? i.toDouble() : double.parse(i.toString()),
    'str': (dynamic i) => i.toString(),
    'chr': (int i) => String.fromCharCode(i),
    'len': (dynamic s) => s.length,
    'split': (String s, String p) => s.split(p),
    'join': (List<String> s, String p) => s.join(p),
    'upper': (String s) => s.toUpperCase(),
    'lower': (String s) => s.toLowerCase(),
    // List Operations
    "at": (dynamic list, int i) =>
        list is Iterable ? list.elementAt(i) : list[i],
    // Map Operations
    "isPresent": (dynamic x, dynamic e) {
      if (x is List) {
        return x.contains(e);
      } else if (x is Map) {
        return x.containsKey(e);
      }
      throw Exception("isPresent() called on invalid object");
    },
    "get": (Map map, dynamic key) => map[key],
    "set": (Map map, dynamic key, dynamic value) => map[key] = value
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

  Value walk(Node node, Scope scope) {
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
    } else if (node is BreakNode) {
      return BreakValue();
    } else if (node is ContinueNode) {
      return ContinueValue();
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
    } else if (node is MultiDeclarationNode) {
      return walkMultiDeclarationNode(node, scope);
    } else if (node is BlockStatementNode) {
      return walkBlockStatementNode(node, scope);
    } else if (node is ListLiteralNode) {
      return walkListLiteralNode(node, scope);
    } else if (node is MapLiteralNode) {
      return walkMapLiteralNode(node, scope);
    }
    return NullValue();
  }

  Value walkNumberNode(node, Scope scope) {
    return getCorrectValueType(node.value);
  }

  StringValue walkStringNode(StringNode node, Scope scope) {
    return StringValue(value: jsonDecode('{"str":"${node.value}"}')['str']);
  }

  BooleanValue walkBooleanNode(BooleanNode node, Scope scope) {
    return BooleanValue(value: node.value);
  }

  ReturnValue walkReturnNode(ReturnNode node, Scope scope) {
    return ReturnValue(value: walk(node.value, scope).value);
  }

  Value walkUnaryNode(UnaryNode node, Scope scope) {
    String op = node.op;
    switch (op) {
      case '+':
        return getCorrectValueType((walk(node.value, scope)).value);
      case '-':
        return getCorrectValueType(-(walk(node.value, scope)).value);
      case '!':
        return getCorrectValueType(!(walk(node.value, scope).value));
    }
    throw Exception("Runtime Error!");
  }

  Value walkBlockStatementNode(BlockStatementNode node, Scope scope,
      {bool createLocalScope = true}) {
    Scope localScope = Scope(parent: scope);
    for (Node n in node.statements) {
      Value val = walk(n, createLocalScope ? localScope : scope);
      if ([ReturnValue, BreakValue, ContinueValue].contains(val.runtimeType)) {
        return val;
      }
    }
    return NullValue();
  }

  ListValue walkListLiteralNode(ListLiteralNode node, Scope scope) {
    List value = [];
    for (Node elem in node.elements) {
      value.add(walk(elem, scope).value);
    }
    return ListValue(value: value);
  }

  MapValue walkMapLiteralNode(MapLiteralNode node, Scope scope) {
    Map value = {};
    for (MapEntry<Node, Node> entry in node.entries.entries) {
      value[walk(entry.key, scope).value] = (walk(entry.value, scope).value);
    }
    return MapValue(value: value);
  }

  Value walkBinaryOpNode(BinaryOpNode node, Scope scope) {
    String op = node.op;

    dynamic leftId = (node.left);
    switch (op) {
      case '=':
        dynamic right = walk(node.right, scope);
        scope.setSymbol(leftId.value, right.value);
        return right;
      case '+=':
        dynamic right = walk(AddNode(left: leftId, right: node.right), scope);
        scope.setSymbol(leftId.value, right.value);
        return right;
      case '-=':
        dynamic right =
            walk(SubtractNode(left: leftId, right: node.right), scope);
        scope.setSymbol(leftId.value, right.value);
        return right;
      case '*=':
        dynamic right =
            walk(MultiplyNode(left: leftId, right: node.right), scope);
        scope.setSymbol(leftId.value, right.value);
        return right;
      case '/=':
        dynamic right =
            walk(DivideNode(left: leftId, right: node.right, op: "/"), scope);
        scope.setSymbol(leftId.value, right.value);
        return right;
      case '~/=':
        dynamic right =
            walk(DivideNode(left: leftId, right: node.right, op: "~/"), scope);
        scope.setSymbol(leftId.value, right.value);
        return right;
      case '^/=':
        dynamic right =
            walk(DivideNode(left: leftId, right: node.right, op: "^/"), scope);
        scope.setSymbol(leftId.value, right.value);
        return right;
      case '%=':
        dynamic right =
            walk(ModulusNode(left: leftId, right: node.right), scope);
        scope.setSymbol(leftId.value, right.value);
        return right;
      case '^=':
        dynamic right = walk(PowerNode(left: leftId, right: node.right), scope);
        scope.setSymbol(leftId.value, right.value);
        return right;
    }

    dynamic left = walk(node.left, scope).value;
    dynamic right = walk(node.right, scope).value;
    switch (op) {
      case '+':
        if ([int, double].contains(left.runtimeType) &&
            [int, double].contains(right.runtimeType)) {
          return getCorrectNumberValue(value: left + right);
        } else if (right is String && left is String) {
          return StringValue(value: left + right);
        } else if (right is List && left is List) {
          return ListValue(value: left + right);
        } else {
          throw Exception("Runtime Error: '$op' used on invalid operands!");
        }
      case '-':
        return getCorrectNumberValue(value: left - right);
      case '*':
        return getCorrectNumberValue(value: left * right);
      case '/':
        return getCorrectNumberValue(value: left / right);
      case '~/':
        return getCorrectNumberValue(value: left ~/ right);
      case '^/':
        return getCorrectNumberValue(value: ((left / right) as double).ceil());
      case '%':
        return getCorrectNumberValue(value: left % right);
      case '^':
        return getCorrectNumberValue(value: pow(left, right));
      case '&':
        return BooleanValue(value: left && right);
      case '|':
        return BooleanValue(value: left || right);
      case '==':
        return BooleanValue(value: left == right);
      case '!=':
        return BooleanValue(value: left != right);
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
      } else if (res is BreakValue) {
        break;
      } else if (res is ContinueValue) {
        continue;
      }
    }
    return NullValue();
  }

  Value walkMultiDeclarationNode(MultiDeclarationNode node, Scope scope) {
    for (DeclarationNode dec in node.declarations) {
      scope.declareSymbol(dec.left.value, walk(dec.right, scope).value);
    }
    return NullValue();
  }

  Value walkFunctionDeclarationNode(FunctionDeclarationNode node, Scope scope) {
    scope.declareSymbol(node.fnId.value, node);
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
          localScope.declareSymbol(
              params[i].value, walk(node.args[i], scope).value);
        }
        Value res = walkBlockStatementNode(
          fn.body,
          localScope,
          createLocalScope: false,
        );
        if (res is ReturnValue) {
          return getCorrectValueType(res.value);
        }
        return res;
      }
    }
    throw Exception("Runtime Error: Function ${node.fnId.value} Not Found!");
  }

  Value getCorrectValueType(dynamic res) {
    if (res is num) {
      return getCorrectNumberValue(value: res);
    } else if (res is bool) {
      return BooleanValue(value: res);
    } else if (res is String) {
      return StringValue(value: res);
    } else if (res is List) {
      return ListValue(value: res);
    } else if (res is Map) {
      return MapValue(value: res);
    }
    return NullValue();
  }

  Value getCorrectNumberValue({required dynamic value}) {
    if (value is int) {
      return IntNumberValue(value: value);
    } else if (value is double) {
      return DoubleNumberValue(value: value);
    }
    return NullValue();
  }
}
