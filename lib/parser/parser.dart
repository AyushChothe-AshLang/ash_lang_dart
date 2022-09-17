import 'package:ash_lang/parser/models/node.dart';
import 'package:ash_lang/parser/models/nodes.dart';
import 'package:ash_lang/tokenizer/model/token.dart';
import 'package:ash_lang/utils/utils.dart';

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

  void eatAnyIn(List<TokenType> types) {
    for (TokenType type in types) {
      if (curr.type == type) {
        next();
        return;
      }
    }
    throw Exception(
        "Invalid Syntax ${curr.getPos()}: Expected ${types.map((e) => '\'${e.name}\'').join(',')} found '${curr.type.name}'");
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

  Node primaryStatement() {
    if (curr.type == TokenType.identifier &&
        assignments.contains(lookAhead?.type)) {
      return assignment();
    } else if (curr.type == TokenType.fnK) {
      return functionDeclarationStatement();
    }
    throw Exception(
        "Invalid Syntax: Only (Variable and Function) Declaration are allowed in Global Scope");
  }

  /// Parses a Function Declaration Statement
  Node functionDeclarationStatement() {
    eat(TokenType.fnK);

    //Parses Function name
    IdentifierNode fnId = identifier();

    // Parses Funtion params
    eat(TokenType.lParan);
    List<IdentifierNode> params = [];

    if (curr.type == TokenType.identifier) {
      IdentifierNode param = identifier();
      params.add(param);
    }

    while (pos < tokens.length && curr.type != TokenType.rParan) {
      eat(TokenType.comma);
      IdentifierNode param = identifier();
      params.add(param);
    }
    eat(TokenType.rParan);

    // Parses Function body
    BlockStatementNode body = blockStatement();

    return FunctionDeclarationNode(
      fnId: fnId,
      params: params,
      body: body,
    );
  }

  /// Control flow Statement
  Node controlFlowStatement() {
    if (curr.type == TokenType.identifier &&
        assignments.contains(lookAhead?.type)) {
      return assignment();
    } else if (curr.type == TokenType.lBrace) {
      return blockStatement();
    } else if (curr.type == TokenType.ifK) {
      return ifStatement();
    } else if (curr.type == TokenType.whileK) {
      return whileStatement();
    } else if (curr.type == TokenType.returnK) {
      return returnStatement();
    }
    Node res = logicalAndOr();
    eat(TokenType.semicolon);
    return res;
  }

  /// Parses Return Statement
  ReturnNode returnStatement() {
    eat(TokenType.returnK);
    Node res = logicalAndOr();
    eat(TokenType.semicolon);
    return ReturnNode(returnNode: res);
  }

  /// Parses a Block { } Statement
  BlockStatementNode blockStatement() {
    List<Node> statements = [];
    eat(TokenType.lBrace);
    while (curr.type != TokenType.rBrace) {
      statements.add(controlFlowStatement());
    }
    eat(TokenType.rBrace);
    return BlockStatementNode(statements: statements);
  }

  /// Parses a while Statement
  WhileLoopNode whileStatement() {
    eat(TokenType.whileK);
    eat(TokenType.lParan);
    BinaryOpBooleanNode condition = logicalAndOr() as BinaryOpBooleanNode;
    eat(TokenType.rParan);
    BlockStatementNode block = blockStatement();

    return WhileLoopNode(condition: condition, block: block);
  }

  IfStatementNode ifStatement() {
    // Parse if condition
    eat(TokenType.ifK);
    eat(TokenType.lParan);
    BinaryOpBooleanNode condition = logicalAndOr() as BinaryOpBooleanNode;
    eat(TokenType.rParan);
    BlockStatementNode trueBlock = blockStatement();

    // Parse elif statements
    List<ElifStatementNode> elifBlocks = [];
    while (pos < tokens.length && curr.type == TokenType.elifK) {
      eat(TokenType.elifK);
      eat(TokenType.lParan);
      BinaryOpBooleanNode condition = logicalAndOr() as BinaryOpBooleanNode;
      eat(TokenType.rParan);
      BlockStatementNode trueBlock = blockStatement();
      elifBlocks
          .add(ElifStatementNode(condition: condition, trueBlock: trueBlock));
    }

    // Parse else block
    BlockStatementNode? elseBlock;
    if (curr.type == TokenType.elseK) {
      eat(TokenType.elseK);
      elseBlock = blockStatement();
    }

    return IfStatementNode(
      condition: condition,
      trueBlock: trueBlock,
      elifBlocks: elifBlocks,
      elseBlock: elseBlock,
    );
  }

  /// Parses a Assignment Statement
  Node assignment() {
    IdentifierNode left = identifier();
    String op = curr.value;
    eatAnyIn(assignments);
    Node right = logicalAndOr();
    eat(TokenType.semicolon);
    return AssignmentNode(left: left, right: right, op: op);
  }

  /// Parses a Function Call
  FunctionCallNode functionCall() {
    IdentifierNode fn = identifier();
    eat(TokenType.lParan);
    List<Node> args = [];

    if (curr.type != TokenType.rParan) {
      args.add(logicalAndOr());
    }

    while (pos < tokens.length && curr.type != TokenType.rParan) {
      eat(TokenType.comma);
      args.add(logicalAndOr());
    }
    eat(TokenType.rParan);
    return FunctionCallNode(fnId: fn, args: args);
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

  /// Parses == !=
  Node equality() {
    Node res = comparison();

    if (curr.type == TokenType.deq) {
      next();
      res = EqualityNode(left: res, right: comparison());
    } else if (curr.type == TokenType.neq) {
      next();
      res = NotEqualsNode(left: res, right: comparison());
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
        [TokenType.multiply, TokenType.divide, TokenType.modulus]
            .contains(curr.type)) {
      if (curr.type == TokenType.multiply) {
        next();
        res = MultiplyNode(left: res, right: factor());
      } else if (curr.type == TokenType.divide) {
        next();
        res = DivideNode(left: res, right: factor());
      } else if (curr.type == TokenType.modulus) {
        next();
        res = ModulusNode(left: res, right: factor());
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
    if (curr.type == TokenType.lParan) {
      eat(TokenType.lParan);
      Node res = logicalAndOr();
      eat(TokenType.rParan);
      return res;
    } else if (curr.type == TokenType.plus) {
      next();
      Node res = atom();
      return UnaryPlus(node: res);
    } else if (curr.type == TokenType.minus) {
      next();
      Node res = atom();
      return UnaryMinus(node: res);
    } else if (curr.type == TokenType.int) {
      Node res = IntNumberNode(value: curr.value);
      next();
      return res;
    } else if (curr.type == TokenType.double) {
      Node res = DoubleNumberNode(value: curr.value);
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
    } else if (curr.type == TokenType.identifier &&
        lookAhead?.type == TokenType.lParan) {
      return functionCall();
    } else if (curr.type == TokenType.identifier) {
      Node res = identifier();
      return res;
    } else {
      throw raiseInvalidSyntax();
    }
  }
}
