import 'package:ash_lang/tokenizer/model/position.dart';
import 'package:ash_lang/tokenizer/model/token.dart';
import 'package:ash_lang/utils/utils.dart';

class Tokenizer {
  final String code;

  String get lookAhead {
    if (pos + 1 < code.length) {
      return code[pos + 1];
    }
    return "";
  }

  String get curr => code[pos];
  int pos = 0, line = 1, column = 1;

  List<Token> tokens = [];

  Tokenizer({required this.code});

  void next() {
    if (pos < code.length) {
      pos++;
      column++;
    }
  }

  Position getCurrentPos() => Position(line: line, column: column);

  addEof(TokenType type) {
    tokens.add(
      Token(
        type: type,
        value: null,
        pos: PositionRange(from: getCurrentPos()),
      ),
    );
  }

  addSingleCharToken(TokenType type) {
    tokens.add(
      Token(
        type: type,
        value: curr,
        pos: PositionRange(from: getCurrentPos()),
      ),
    );
    next();
  }

  addDoubleCharToken(TokenType firsType, TokenType secondType, String chars) {
    Position start = getCurrentPos();
    Token ft = Token(
      type: firsType,
      value: chars[0],
      pos: PositionRange(from: start),
    );
    next();
    if (pos < code.length && curr == chars[1]) {
      Token st = Token(
        type: secondType,
        value: chars,
        pos: PositionRange(from: start, to: getCurrentPos()),
      );
      next();
      tokens.add(st);
    } else {
      tokens.add(ft);
    }
  }

  addTripleCharToken(TokenType firsType, TokenType secondType,
      TokenType thirdType, String chars) {
    Position start = getCurrentPos();
    Token ft = Token(
      type: firsType,
      value: chars[0],
      pos: PositionRange(from: start),
    );
    next();
    if (pos < code.length && curr == chars[1]) {
      Token st = Token(
        type: secondType,
        value: chars[0] + chars[1],
        pos: PositionRange(from: start, to: getCurrentPos()),
      );
      next();
      if (pos < code.length && curr == chars[2]) {
        Token tt = Token(
          type: thirdType,
          value: chars,
          pos: PositionRange(from: start, to: getCurrentPos()),
        );
        next();
        tokens.add(tt);
      } else {
        tokens.add(st);
      }
    } else {
      tokens.add(ft);
    }
  }

  List<Token> tokenize() {
    while (pos < code.length) {
      if (whitespace.contains(curr)) {
        if (curr == "\n") {
          line++;
          column = 1;
        }
        next();
      } else if (numbers.contains(curr)) {
        parseNumberLiteral();
      } else if (chars.hasMatch(curr)) {
        parseIdentifier();
      } else if (curr == '"' || curr == "'") {
        parseStringLiteral(curr);
      } else if (curr == "+") {
        addDoubleCharToken(TokenType.plus, TokenType.plusEq, "+=");
      } else if (curr == "-") {
        addDoubleCharToken(TokenType.minus, TokenType.minusEq, "-=");
      } else if (curr == "*") {
        addDoubleCharToken(TokenType.multiply, TokenType.multiplyEq, "*=");
      } else if (curr == "/") {
        addDoubleCharToken(TokenType.divide, TokenType.divideEq, "/=");
      } else if (curr == "%") {
        addDoubleCharToken(TokenType.modulus, TokenType.modulusEq, "%=");
      } else if (curr == "^") {
        if (lookAhead == "=") {
          addDoubleCharToken(TokenType.power, TokenType.powerEq, "^=");
        } else if (lookAhead == "/") {
          addTripleCharToken(TokenType.power, TokenType.powerDivide,
              TokenType.powerDivideEq, "^/=");
        } else {
          addSingleCharToken(TokenType.power);
        }
      } else if (curr == "~") {
        addTripleCharToken(TokenType.tilde, TokenType.tildeDivide,
            TokenType.tildeDivideEq, "~/=");
      } else if (curr == "(") {
        addSingleCharToken(TokenType.lParan);
      } else if (curr == ")") {
        addSingleCharToken(TokenType.rParan);
      } else if (curr == "{") {
        addSingleCharToken(TokenType.lBrace);
      } else if (curr == "}") {
        addSingleCharToken(TokenType.rBrace);
      } else if (curr == "[") {
        addSingleCharToken(TokenType.lSquare);
      } else if (curr == "]") {
        addSingleCharToken(TokenType.rSquare);
      } else if (curr == "&") {
        addSingleCharToken(TokenType.and);
      } else if (curr == "|") {
        addSingleCharToken(TokenType.or);
      } else if (curr == "!") {
        addDoubleCharToken(TokenType.not, TokenType.neq, "!=");
      } else if (curr == ",") {
        addSingleCharToken(TokenType.comma);
      } else if (curr == ":") {
        addSingleCharToken(TokenType.colon);
      } else if (curr == ";") {
        addSingleCharToken(TokenType.semicolon);
      } else if (curr == "=") {
        addDoubleCharToken(TokenType.eq, TokenType.deq, "==");
      } else if (curr == ">") {
        addDoubleCharToken(TokenType.gt, TokenType.gte, ">=");
      } else if (curr == "<") {
        addDoubleCharToken(TokenType.lt, TokenType.lte, "<=");
      } else {
        throw Exception("Illegal char at [$line:$column]: '$curr'");
      }
    }
    addEof(TokenType.eof);
    return tokens;
  }

  void parseNumberLiteral() {
    String num = "";
    int dot = 0;

    Position from = getCurrentPos();

    while (pos < code.length && numbers.contains(curr)) {
      if (curr == '.') {
        dot++;
        if (dot > 1) {
          throw Exception("Invalid number at [$line:$column]: '$curr'");
        }
      }
      num += curr;
      next();
    }

    Position to = getCurrentPos();

    tokens.add(
      Token(
        type: dot == 0 ? TokenType.int : TokenType.double,
        value: dot == 0 ? int.parse(num) : double.parse(num),
        pos: PositionRange(from: from, to: to),
      ),
    );
  }

  parseStringLiteral(String quoteType) {
    String id = "";

    Position from = getCurrentPos();

    // Advance first quoteType
    next();

    while (pos < code.length && curr != quoteType) {
      id += curr;
      next();
    }

    // Advance last quoteType
    if (pos < code.length && curr == quoteType) {
      next();
    } else {
      throw Exception(
          "Invalid Syntax ${getCurrentPos()}: Expected $quoteType (Unterminated String Literal)");
    }

    Position to = getCurrentPos();
    tokens.add(
      Token(
        type: TokenType.stringLiteral,
        value: id,
        pos: PositionRange(from: from, to: to),
      ),
    );
  }

  parseIdentifier() {
    String id = "";

    Position from = getCurrentPos();

    while (pos < code.length && chars.hasMatch(curr)) {
      id += curr;
      next();
    }

    Position to = getCurrentPos();

    TokenType tokenType = id == "true" || id == "false"
        ? TokenType.booleanLiteral
        : TokenType.identifier;

    if (tokenType == TokenType.booleanLiteral) {
      tokens.add(
        Token(
          type: tokenType,
          value: id == "true" ? true : false,
          pos: PositionRange(from: from, to: to),
        ),
      );
    } else {
      tokens.add(
        Token(
          type: getTokenTypeFromId(id),
          value: id,
          pos: PositionRange(from: from, to: to),
        ),
      );
    }
  }
}
