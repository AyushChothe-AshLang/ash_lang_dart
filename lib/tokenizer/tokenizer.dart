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

  List<Token> tokenize() {
    while (pos < code.length) {
      if (whitespace.contains(curr)) {
        if (curr == "\n") {
          line++;
          column = 1;
        }
        next();
      } else if (numbers.contains(curr)) {
        parseNumber();
      } else if (curr == "+") {
        tokens.add(
          Token(
            type: TokenType.plus,
            value: '+',
            pos: PositionRange(from: getCurrentPos()),
          ),
        );
        next();
      } else if (curr == "-") {
        tokens.add(
          Token(
            type: TokenType.minus,
            value: '-',
            pos: PositionRange(from: getCurrentPos()),
          ),
        );
        next();
      } else if (curr == "*") {
        tokens.add(
          Token(
            type: TokenType.multiply,
            value: '*',
            pos: PositionRange(from: getCurrentPos()),
          ),
        );
        next();
      } else if (curr == "/") {
        tokens.add(
          Token(
            type: TokenType.divide,
            value: '/',
            pos: PositionRange(from: getCurrentPos()),
          ),
        );
        next();
      } else if (curr == "^") {
        tokens.add(
          Token(
            type: TokenType.power,
            value: '^',
            pos: PositionRange(from: getCurrentPos()),
          ),
        );
        next();
      } else if (curr == "(") {
        tokens.add(
          Token(
            type: TokenType.lparam,
            value: '(',
            pos: PositionRange(from: getCurrentPos()),
          ),
        );
        next();
      } else if (curr == ")") {
        tokens.add(
          Token(
            type: TokenType.rparam,
            value: ')',
            pos: PositionRange(from: getCurrentPos()),
          ),
        );
        next();
      } else if (curr == "=") {
        Position start = getCurrentPos();
        Token eq = Token(
          type: TokenType.eq,
          value: '=',
          pos: PositionRange(from: start),
        );
        next();
        if (pos < code.length && curr == '=') {
          Token deq = Token(
            type: TokenType.deq,
            value: '==',
            pos: PositionRange(from: start, to: getCurrentPos()),
          );
          tokens.add(deq);
          next();
        } else {
          tokens.add(eq);
        }
      } else if (curr == ">") {
        Position start = getCurrentPos();
        Token gt = Token(
          type: TokenType.gt,
          value: '>',
          pos: PositionRange(from: start),
        );
        next();
        if (pos < code.length && curr == '=') {
          Token gte = Token(
            type: TokenType.gte,
            value: '>=',
            pos: PositionRange(from: start, to: getCurrentPos()),
          );
          tokens.add(gte);
          next();
        } else {
          tokens.add(gt);
        }
      } else if (curr == "<") {
        Position start = getCurrentPos();
        Token lt = Token(
          type: TokenType.lt,
          value: '<',
          pos: PositionRange(from: start),
        );
        next();
        if (pos < code.length && curr == '=') {
          Token lte = Token(
            type: TokenType.lte,
            value: '<=',
            pos: PositionRange(from: start, to: getCurrentPos()),
          );
          tokens.add(lte);
          next();
        } else {
          tokens.add(lt);
        }
      } else {
        throw Exception("Illegal char at [$line:$column]: '$curr'");
      }
    }
    tokens.add(
      Token(
        type: TokenType.eof,
        pos: PositionRange(from: getCurrentPos()),
      ),
    );
    return tokens;
  }

  void parseNumber() {
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
}
