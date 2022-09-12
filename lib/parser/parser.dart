import 'package:ash_lang/parser/models/node.dart';
import 'package:ash_lang/parser/models/nodes.dart';
import 'package:ash_lang/tokenizer/model/token.dart';

class Parser {
  List<Token> tokens;
  Token get curr => tokens[pos];
  Token? get lookAhead {
    if (pos + 1 < tokens.length) {
      return tokens[pos + 1];
    }
    return null;
  }

  int pos = 0;

  Parser({required this.tokens});

  Exception raiseInvalidSyntax() {
    return Exception("Invalid Syntax ${curr.getPos()}: '${curr.value}'");
  }

  void next() {
    if (pos < tokens.length) {
      pos++;
    }
  }

  void eat(TokenType type) {
    if (curr.type == type) {
      next();
    } else {
      throw Exception(
          "Invalid Syntax ${curr.getPos()}: Expected '${type.name}' found '${curr.type.name}'");
    }
  }

  /// Starts the Parsing
  Node parse() {
    Node ast = EOFNode();
    List<Node> statements = [];
    while (curr.type != TokenType.eof) {
      statements.add(primaryStatement());
    }
    return BlockStatementNode(
        statements: statements.isNotEmpty ? statements : [ast]);
  }

  /// Initial Statement
  Node primaryStatement() {
    if (curr.type == TokenType.lBrace) {
      return blockStatement();
    }
    Node res = valueStatement();
    eat(TokenType.semicolon);
    return res;
  }

  /// A statement that generates a value
  Node valueStatement() {
    if (curr.type == TokenType.identifier && lookAhead?.type == TokenType.eq) {
      return assignment();
    } else if (curr.type == TokenType.identifier &&
        lookAhead?.type == TokenType.lParam) {
      return functionCall();
    }
    return logicalAndOr();
  }

  /// Parses a Block { } Statement
  BlockStatementNode blockStatement() {
    List<Node> statements = [];
    eat(TokenType.lBrace);
    while (curr.type != TokenType.rBrace) {
      Node res = primaryStatement();
      statements.add(res);
    }
    eat(TokenType.rBrace);
    return BlockStatementNode(statements: statements);
  }

  /// Parses a Assignment Statement
  Node assignment() {
    IdentifierNode left = identifier();
    eat(TokenType.eq);
    Node right = valueStatement();
    return AssignmentNode(id: left, right: right);
  }

  /// Parses a Function Call
  FunctionCallNode functionCall() {
    IdentifierNode fn = identifier();
    eat(TokenType.lParam);
    List<Node> args = [valueStatement()];
    while (pos < tokens.length && curr.type != TokenType.rParam) {
      eat(TokenType.comma);
      args.add(valueStatement());
    }
    eat(TokenType.rParam);
    return FunctionCallNode(fn: fn.value, args: args);
  }

  /// Parses a Identifier
  IdentifierNode identifier() {
    IdentifierNode res = IdentifierNode(value: curr.value);
    eat(TokenType.identifier);
    return res;
  }

  /// Parses Logical & |
  Node logicalAndOr() {
    Node res = equality();
    while (pos < tokens.length &&
        [TokenType.and, TokenType.or].contains(curr.type)) {
      if (curr.type == TokenType.and) {
        next();
        res = LogicalAndNode(left: res, right: equality());
      } else {
        next();
        res = LogicalOrNode(left: res, right: equality());
      }
    }
    return res;
  }

  /// Parses ==
  Node equality() {
    Node res = comparison();

    if (curr.type == TokenType.deq) {
      next();
      res = EqualityNode(left: res, right: comparison());
    }

    return res;
  }

  /// Parses < <= >= >
  Node comparison() {
    Node res = expr();

    if (curr.type == TokenType.lt) {
      next();
      res = LessThanNode(left: res, right: expr());
    } else if (curr.type == TokenType.lte) {
      next();
      res = LessThanEqNode(left: res, right: expr());
    } else if (curr.type == TokenType.gt) {
      next();
      res = GreaterThanNode(left: res, right: expr());
    } else if (curr.type == TokenType.gte) {
      next();
      res = GreaterThanEqNode(left: res, right: expr());
    }

    return res;
  }

  /// Parses Mathematical Expression + -
  Node expr() {
    Node res = term();
    while (pos < tokens.length &&
        [TokenType.plus, TokenType.minus].contains(curr.type)) {
      if (curr.type == TokenType.plus) {
        next();
        res = AddNode(left: res, right: term());
      } else {
        next();
        res = SubstractNode(left: res, right: term());
      }
    }
    return res;
  }

  /// Parses Mathematical Expression * /
  Node term() {
    Node res = factor();
    while (pos < tokens.length &&
        [TokenType.multiply, TokenType.divide].contains(curr.type)) {
      if (curr.type == TokenType.multiply) {
        next();
        res = MultiplyNode(left: res, right: factor());
      } else if (curr.type == TokenType.divide) {
        next();
        res = DivideNode(left: res, right: factor());
      }
    }
    return res;
  }

  /// Parses Mathematical Expression ^
  Node factor() {
    Node res = atom();
    while (pos < tokens.length && [TokenType.power].contains(curr.type)) {
      if (curr.type == TokenType.power) {
        next();
        res = PowerNode(left: res, right: atom());
      }
    }
    return res;
  }

  /// Parses Mathematical Expression NumberLiteral Unary Identifier
  Node atom() {
    if (curr.type == TokenType.lParam) {
      eat(TokenType.lParam);
      Node res = logicalAndOr();
      eat(TokenType.rParam);
      return res;
    } else if (curr.type == TokenType.plus) {
      next();
      Node res = atom();
      return UnaryPlus(node: res);
    } else if (curr.type == TokenType.minus) {
      next();
      Node res = atom();
      return UnaryMinus(node: res);
    } else if (curr.type == TokenType.number) {
      Node res = NumberNode(value: curr.value);
      next();
      return res;
    } else if (curr.type == TokenType.stringLiteral) {
      Node res = StringNode(value: curr.value);
      next();
      return res;
    } else if (curr.type == TokenType.booleanLiteral) {
      Node res = BooleanNode(value: curr.value);
      next();
      return res;
    } else if (curr.type == TokenType.identifier) {
      Node res = identifier();
      return res;
    } else {
      throw raiseInvalidSyntax();
    }
  }
}
