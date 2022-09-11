import 'package:ash_lang/parser/models/node.dart';
import 'package:ash_lang/parser/models/nodes.dart';
import 'package:ash_lang/tokenizer/model/token.dart';

class Parser {
  List<Token> tokens;
  Token get curr => tokens[pos];
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
      throw raiseInvalidSyntax();
    }
  }

  Node parse() {
    if (curr.type == TokenType.eof) {
      return EOFNode();
    }
    Node ast = equality();
    if (curr.type != TokenType.eof) {
      throw raiseInvalidSyntax();
    }
    return ast;
  }

  Node equality() {
    Node res = comparison();

    if (curr.type == TokenType.deq) {
      next();
      res = EqualityNode(left: res, right: comparison());
    }

    return res;
  }

  Node comparison() {
    Node res = expr();
    while (pos < tokens.length &&
        [TokenType.lt, TokenType.lte, TokenType.gt, TokenType.gte]
            .contains(curr.type)) {
      if (curr.type == TokenType.lt) {
        next();
        res = LessThanNode(left: res, right: expr());
        break;
      } else if (curr.type == TokenType.lte) {
        next();
        res = LessThanEqNode(left: res, right: expr());
        break;
      } else if (curr.type == TokenType.gt) {
        next();
        res = GreaterThanNode(left: res, right: expr());
        break;
      } else if (curr.type == TokenType.gte) {
        next();
        res = GreaterThanEqNode(left: res, right: expr());
        break;
      }
    }
    return res;
  }

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

  Node atom() {
    if (curr.type == TokenType.lparam) {
      eat(TokenType.lparam);
      Node res = comparison();
      eat(TokenType.rparam);
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
    } else {
      throw raiseInvalidSyntax();
    }
  }
}
