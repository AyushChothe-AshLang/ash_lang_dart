import 'package:ash_lang/tokenizer/model/position.dart';

enum TokenType {
  number, // 1234567890.
  plus, // +
  minus, // -
  multiply, //\ *
  divide, // /
  power, // ^
  lparam, // (
  rparam, // )
  eq, // =
  deq, // ==
  lt, // <
  gt, // >
  lte, // <=
  gte, // >=
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
