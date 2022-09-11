import 'package:ash_lang/tokenizer/model/postion.dart';

enum TokenType {
  number,
  plus,
  minus,
  multiply,
  divide,
  power,
  lparam,
  rparam,
  eof,
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
