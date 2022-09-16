import 'package:ash_lang/parser/models/node.dart';
import 'package:ash_lang/parser/models/nodes.dart';

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
      return walk(ast, indent: -1);
    }
    return "";
  }

  String walk(Node node, {required int indent, bool inRHS = false}) {
    String space = indentSpace(indent);
    if (node is AssignmentNode) {
      return "$space${(node.left as IdentifierNode).value} = ${walk(node.right, indent: indent, inRHS: true)};\n";
    } else if (node is NumberNode) {
      return "${node.value}";
    } else if (node is StringNode) {
      return "\"${node.value}\"";
    } else if (node is BooleanNode) {
      return "${node.value}";
    } else if (node is UnaryNode) {
      return "${node.op}${walk(node.node, indent: indent)}";
    } else if (node is IdentifierNode) {
      return node.value;
    } else if (node is ReturnNode) {
      return "${space}return ${walk(node.returnNode, indent: indent)};\n";
    } else if (node is BinaryOpNode) {
      return "(${walk(node.left, indent: indent)} ${node.op} ${walk(node.right, indent: indent, inRHS: true)})";
    } else if (node is IfStatementNode) {
      return "${space}if (${walk(node.condition, indent: indent)})${walk(node.trueBlock, indent: indent, inRHS: true)}"
          "${node.elifBlocks.isNotEmpty ? node.elifBlocks.map((e) => walk(e, indent: indent, inRHS: true)).join('') : ''}"
          "${node.elseBlock != null ? ' else ${walk(node.elseBlock!, indent: indent, inRHS: true)}' : ''}\n";
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
      String block = indent >= 0 ? (inRHS ? '{\n' : '$space{\n') : '';
      for (Node stmt in node.statements) {
        block += walk(stmt, indent: indent + 1);
      }
      block += (indent) >= 0 ? "$space}" : "";
      return block;
    }
    return "";
  }
}
