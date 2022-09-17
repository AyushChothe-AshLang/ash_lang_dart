import 'package:ash_lang/tokenizer/model/position.dart';

enum TokenType {
  int, // 1234567890
  double, // 1234567890.1234
  stringLiteral, // "Ash" 'Ash'
  booleanLiteral, // true or flase
  identifier, // Variable or Function
  plus, // +
  minus, // -
  multiply, //\ *
  divide, // /
  modulus, // %
  power, // ^
  plusEq, // +=
  minusEq, // -=
  multiplyEq, //\ *=
  divideEq, // /=
  modulusEq, // %=
  powerEq, // ^=
  lParan, // (
  rParan, // )
  lBrace, // {
  rBrace, // }
  eq, // =
  neq, // \!=
  deq, // ==
  lt, // <
  gt, // >
  lte, // <=
  gte, // >=
  and, // &
  or, // |
  not, // \!
  comma, // ,
  colon, // :
  semicolon, // ;
  eof, // End of File
  // Keywords
  whileK, // while
  ifK, // if
  elseK, // else
  elifK, // elif
  fnK, // fn
  breakK, // break
  continueK, // continue
  returnK, // return
}

class Token {
  TokenType type;
  dynamic value;
  PositionRange pos;

  Token({
    required this.type,
    required this.pos,
    this.value,
  });

  @override
  String toString() => "${type.name}:$value:$pos";

  String getPos() => "$pos";
}
