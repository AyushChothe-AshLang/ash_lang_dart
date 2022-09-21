import 'package:ash_lang/tokenizer/model/position.dart';

enum TokenType {
  int, // 1234567890
  double, // 1234567890.1234
  stringLiteral, // "Ash" 'Ash'
  booleanLiteral, // true or flase
  identifier, // Variable or Function
  plus, // +
  minus, // -
  multiply, // *
  divide, // /
  tildeDivide, // ~/
  powerDivide, // ^/
  modulus, // %
  power, // ^
  tilde, // ~
  plusEq, // +=
  minusEq, // -=
  multiplyEq, // *=
  divideEq, // /=
  tildeDivideEq, // ~/=
  powerDivideEq, // ^/=
  modulusEq, // %=
  powerEq, // ^=
  lParan, // (
  rParan, // )
  lBrace, // {
  rBrace, // }
  eq, // =
  neq, // !=
  deq, // ==
  lt, // <
  gt, // >
  lte, // <=
  gte, // >=
  and, // &
  or, // |
  not, // !
  comma, // ,
  colon, // :
  semicolon, // ;
  eof, // End of File
  // Keywords
  whileK, // while
  ifK, // if
  elifK, // elif
  elseK, // else
  fnK, // fn
  letK, // let
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
