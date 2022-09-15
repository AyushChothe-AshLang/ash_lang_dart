import 'package:ash_lang/tokenizer/model/position.dart';
import 'package:ash_lang/tokenizer/model/token.dart';
import 'package:ash_lang/utils/utils.dart';

class Tokenizer {
  final String code;
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
      tokens.add(st);
      next();
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
      } else if (curr == '"') {
      } else if (curr == "+") {
        addSingleCharToken(TokenType.plus);
      } else if (curr == "-") {
        addSingleCharToken(TokenType.minus);
      } else if (curr == "*") {
        addSingleCharToken(TokenType.multiply);
      } else if (curr == "/") {
        addSingleCharToken(TokenType.divide);
      } else if (curr == "^") {
        addSingleCharToken(TokenType.power);
      } else if (curr == "(") {
        addSingleCharToken(TokenType.lParan);
      } else if (curr == ")") {
        addSingleCharToken(TokenType.rParan);
      } else if (curr == "{") {
        addSingleCharToken(TokenType.lBrace);
      } else if (curr == "}") {
        addSingleCharToken(TokenType.rBrace);
      } else if (curr == "&") {
        addSingleCharToken(TokenType.and);
      } else if (curr == "|") {
        addSingleCharToken(TokenType.or);
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
        type: TokenType.number,
        value: double.parse(num),
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
