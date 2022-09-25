import 'package:ash_lang/parser/models/node.dart';
import 'package:ash_lang/parser/models/nodes.dart';
import 'package:ash_lang/utils/utils.dart';

class Formatter {
  Node ast;

  Formatter({required this.ast});

  String indentSpace([int level = 0, int spaces = 2]) {
    String space = "";
    for (int i = 0; i < level; i++) {
      String sp = "";
      for (int j = 0; j < spaces; j++) {
        sp += " ";
      }
      space += sp;
    }
    return space;
  }

  String format() {
    if (ast is! EOFNode) {
      return walk(ast, indent: -1).trim();
    }
    return "";
  }

  String walk(Node node, {required int indent, bool inRHS = false}) {
    String space = indentSpace(indent);
    if (node is AssignmentNode) {
      return "$space${(node.left as IdentifierNode).value} ${node.op} ${walk(node.right, indent: indent, inRHS: true)};\n";
    } else if (node is NumberNode) {
      if (node is IntNumberNode) {
        return "${node.value}";
      } else if (node is DoubleNumberNode) {
        return "${node.value}";
      }
    } else if (node is StringNode) {
      return '"${node.value}"';
    } else if (node is BooleanNode) {
      return "${node.value}";
    } else if (node is UnaryNode) {
      return "${node.op}${walk(node.value, indent: indent, inRHS: true)}";
    } else if (node is IdentifierNode) {
      return node.value;
    } else if (node is ReturnNode) {
      return "${space}return ${walk(node.value, indent: indent, inRHS: true)};\n";
    } else if (node is DeclarationNode) {
      return "${walk(node.left, indent: indent)} ${node.op} ${walk(node.right, indent: indent, inRHS: true)}";
    } else if (node is BinaryOpBooleanNode) {
      return walkBinaryOpBooleanNode(node);
    } else if (node is BinaryOpNumberNode) {
      return walkBinaryOpNumberNode(node);
    } else if (node is MultiDeclarationNode) {
      return "${space}let ${node.declarations.map((e) => walk(e, indent: indent)).join(", ")};\n";
    } else if (node is IfStatementNode) {
      return "${space}if (${walk(node.condition, indent: indent)})${walk(node.trueBlock, indent: indent, inRHS: true)}"
          "${node.elifBlocks.isNotEmpty ? node.elifBlocks.map((e) => walk(e, indent: indent, inRHS: true)).join('') : ''}"
          "${node.elseBlock != null ? ' else${walk(node.elseBlock!, indent: indent, inRHS: true)}' : ''}\n";
    } else if (node is ElifStatementNode) {
      return " elif (${walk(node.condition, indent: indent)})${walk(node.trueBlock, indent: indent, inRHS: true)}";
    } else if (node is WhileLoopNode) {
      return "${space}while (${walk(node.condition, indent: indent)})${walk(node.block, indent: indent, inRHS: true)}\n";
    } else if (node is FunctionDeclarationNode) {
      return "fn ${node.fnId.value}(${node.params.map((e) => e.value).join(', ')})${walk(node.body, indent: indent, inRHS: true)}\n\n";
    } else if (node is FunctionCallNode) {
      if (inRHS) {
        return "${node.fnId.value}(${node.args.map((e) => walk(e, indent: indent, inRHS: true)).join(', ')})";
      }
      return "$space${node.fnId.value}(${node.args.map((e) => walk(e, indent: indent, inRHS: true)).join(', ')});\n";
    } else if (node is BlockStatementNode) {
      String block = indent >= 0 ? (inRHS ? ' {\n' : '$space{\n') : '';
      for (Node stmt in node.statements) {
        block += walk(stmt, indent: indent + 1);
      }
      block += (indent) >= 0 ? "$space}" : "";
      return block;
    }
    return inRHS ? "$node" : "$space$node\n";
  }

  String walkBinaryOpNumberNode(BinaryOpNumberNode node, [int parentPre = 0]) {
    int pre = precedence[node.runtimeType]!;
    String left = "", right = "";

    if (node.left is BinaryOpNumberNode) {
      left = walkBinaryOpNumberNode(node.left as BinaryOpNumberNode, pre);
    } else {
      left = walk(node.left, indent: 0, inRHS: true);
    }
    if (node.right is BinaryOpNumberNode) {
      right = walkBinaryOpNumberNode(node.right as BinaryOpNumberNode, pre);
    } else {
      right = walk(node.right, indent: 0, inRHS: true);
    }

    if (pre < parentPre) {
      return "($left ${node.op} $right)";
    } else {
      return "$left ${node.op} $right";
    }
  }

  String walkBinaryOpBooleanNode(BinaryOpBooleanNode node) {
    String out = "";
    String left = walk(node.left, indent: 0, inRHS: true);
    String right = walk(node.right, indent: 0, inRHS: true);
    if (node.left is BinaryOpNode) {
      out += "($left)";
    } else {
      out += left;
    }
    out += ' ${node.op} ';
    if (node.right is BinaryOpNode) {
      out += "($right)";
    } else {
      out += right;
    }
    return out;
  }
}
