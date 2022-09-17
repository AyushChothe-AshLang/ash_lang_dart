import 'package:ash_lang/tokenizer/model/token.dart';

const numbers = "0123456789.";
const whitespace = " \n\t\r";
final chars = RegExp(r"\w");

const assignments = [
  TokenType.eq,
  TokenType.plusEq,
  TokenType.minusEq,
  TokenType.multiplyEq,
  TokenType.divideEq,
  TokenType.modulusEq,
  TokenType.powerEq,
  TokenType.tildeDivideEq,
  TokenType.powerDivideEq,
];

const keywords = {
  "while": TokenType.whileK,
  "if": TokenType.ifK,
  "else": TokenType.elseK,
  "elif": TokenType.elifK,
  "fn": TokenType.fnK,
  "break": TokenType.breakK,
  "continue": TokenType.continueK,
  "return": TokenType.returnK,
};

TokenType getTokenTypeFromId(String id) {
  if (keywords.containsKey(id)) {
    return keywords[id]!;
  }
  return TokenType.identifier;
}
