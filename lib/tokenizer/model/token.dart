import 'package:ash_lang/tokenizer/model/position.dart';

enum TokenType {
  number, // 1234567890.
  stringLiteral, // 1234567890.
  booleanLiteral, // 1234567890.
  identifier, // Variable
  plus, // +
  minus, // -
  multiply, //\ *
  divide, // /
  power, // ^
  lParam, // (
  rParam, // )
  lBrace, // {
  rBrace, // }
  eq, // =
  deq, // ==
  lt, // <
  gt, // >
  lte, // <=
  gte, // >=
  and, // &
  or, // |
  comma, // ,
  colon, // :
  semicolon, // ;
  eof, // End of File
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
  String toString() => "${type.name}:$value";

  String getPos() => "$pos";
}
